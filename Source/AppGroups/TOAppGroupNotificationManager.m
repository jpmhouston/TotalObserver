//
//  TOAppGroupNotificationManager.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//
//  TODO:
//  - determine if updating post and sequence number files needs to be done within background tasks to avoid
//    app from terminating in an incorrect or an invalid state -- yes, i think this really is needed :^(
//  - consider a mode where the last-sequence-number is continued from one app launch to the next, this might
//    require that posts instead (?) be stored in a non-cache, backed-up directory for consistency across
//    restart and restores (um, or is the shared dir already that?)
//  - currently an app quitting without cleaning up its registered observations already leaves its
//    last-sequence-number file behind, except when not using the potential mode mentioned above, consider a
//    mechanism for expiring these stale files and allowing cleanup of posts that otherwise might be stuck
//    forever.

#import "TOAppGroupNotificationManager.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

static TOAppGroupNotificationManager *sharedInstance;
static NSString * const postFileNameSeparator = @"|";
static NSString * const postFileNameExtension = @"post";
static NSString * const postDictDateKey = @"d";
static NSString * const postDictPayloadKey = @"p";
static NSString * const sequenceNumberDirName = @"subscribers";
static NSString * const sequenceNumberFileNameExtension = @"seqnum";
static const u_int32_t defaultCleanupFrequencyRandomFactor = 20;

@interface TOAppGroupSubscriptionState : NSObject
@property (nonatomic, copy) TOAppGroupSubscriberBlock block;
@property (nonatomic, getter=isQueued) BOOL queued; // pick new name for this, inclusive? or the negative, latestOnly?
@property (nonatomic) NSInteger lastReceivedSequenceNumber;
@end

@interface TOAppGroupNotificationPost : NSObject
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger sequenceNumber;
@property (nonatomic) NSDate *date;
@property (nonatomic, nullable) id payload;
@property (nonatomic) BOOL lastInGroupForName;
@end

@interface TOAppGroupNotificationManager () <TOAppGroupURLProviding, TOAppGroupGlobalNotificationHandling>
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSNumberFormatter *numberFormatter;

@property (nonatomic) NSMutableDictionary *subscriptionsPerGroupIdentifier; // {groupid: {name: state}}
@property (nonatomic) NSMutableArray *orderedIdentifiers;
@property (nonatomic) dispatch_queue_t fileIOQueue;
@property (nonatomic) dispatch_queue_t notifyQueue;

@property (nonatomic, nullable) id<TOAppGroupURLProviding> urlHelper;
@property (nonatomic, nullable) id<TOAppGroupGlobalNotificationHandling> notificationHelper;
@property (nonatomic, nullable) id<TOAppGroupBundleIdProviding> bundleIdHelper;
@property (nonatomic, nullable) NSString *appIdentifier;
@property (nonatomic) BOOL permitPostsWhenNoSubscribers;
@property (nonatomic) u_int32_t cleanupFrequencyRandomFactor;
@end

@implementation TOAppGroupNotificationManager

@dynamic defaultGroupIdentifier;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    _fileManager = [[NSFileManager alloc] init];
    _numberFormatter = [[NSNumberFormatter alloc] init];
    _numberFormatter.numberStyle = NSNumberFormatterNoStyle;
    _numberFormatter.usesGroupingSeparator = NO;
    _numberFormatter.allowsFloats = NO;
    
    _subscriptionsPerGroupIdentifier = [[NSMutableDictionary alloc] init];
    _orderedIdentifiers = [[NSMutableArray alloc] init];
    
    _fileIOQueue = dispatch_queue_create("TOAppGroupNotificationManager-file-io", DISPATCH_QUEUE_SERIAL); // can we get away with DISPATCH_QUEUE_CONCURRENT?
    _notifyQueue = dispatch_queue_create("TOAppGroupNotificationManager-notify", DISPATCH_QUEUE_SERIAL);
    
    _appIdentifier = [NSBundle mainBundle].bundleIdentifier;
    _permitPostsWhenNoSubscribers = NO;
    _cleanupFrequencyRandomFactor = defaultCleanupFrequencyRandomFactor;
    return self;
}

- (nullable id<TOAppGroupURLProviding>)urlHelper
{
    return _urlHelper != nil ? _urlHelper : self;
}

- (nullable id<TOAppGroupGlobalNotificationHandling>)notificationHelper
{
    return _notificationHelper != nil ? _notificationHelper : self;
}

- (void)addGroupIdentifier:(NSString *)identifier
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    if (appGroupURL == nil) {
        NSLog(@"unable to use app group %@, capabilities may not be correctly configured for your project, or the identifier may not equal that of a configured group", identifier);
        return;
    }
    
    @synchronized(self) {
        if (self.subscriptionsPerGroupIdentifier[identifier] == nil) {
            self.subscriptionsPerGroupIdentifier[identifier] = [NSMutableDictionary dictionary];
            [self.orderedIdentifiers insertObject:identifier atIndex:0];
            [self.notificationHelper subscribeAppGroupNotificationManager:self toGlobalMessagesWithGroupIdentifier:identifier];
        }
        else {
            // adding same identifier again moves it to front of the order
            [self.orderedIdentifiers removeObject:identifier];
            [self.orderedIdentifiers insertObject:identifier atIndex:0];
        }
    }
}

- (void)removeGroupIdentifier:(NSString *)identifier
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    if (appGroupURL == nil) {
        return;
    }
    
    @synchronized(self) {
        [self.notificationHelper unsubscribeAppGroupNotificationManager:self fromGlobalMessagesWithGroupIdentifier:identifier];
        [self.subscriptionsPerGroupIdentifier removeObjectForKey:identifier];
        [self.orderedIdentifiers removeObject:identifier];
    }
    
    dispatch_async(self.fileIOQueue, ^{
        NSString *bundleIdentifier = self.appIdentifier ?: [self.bundleIdHelper bundleIdForRemovingGroupIdentifier:identifier];
        
        NSSet *names = [self storedSubscriptionNamesForGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:bundleIdentifier];
        for (NSString *name in names) {
            [self cleanupPostsForGroupIdentifier:identifier groupURL:appGroupURL name:name];
        }
        
        [self clearStoredSequenceNumbersForGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:bundleIdentifier];
    });
}

- (nullable NSString *)defaultGroupIdentifier
{
    @synchronized(self) {
        return self.orderedIdentifiers.firstObject;
    }
}

- (BOOL)isValidGroupIdentifier:(NSString *)identifier
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    return appGroupURL != nil;
}

#pragma mark - Subscribing

- (BOOL)subscribeToNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name queued:(BOOL)queued withBlock:(TOAppGroupSubscriberBlock)block
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    if (appGroupURL == nil) {
        return NO;
    }
    
    // store state of new subscription
    TOAppGroupSubscriptionState *subscription = [[TOAppGroupSubscriptionState alloc] init];
    subscription.block = block;
    subscription.queued = queued;
    @synchronized(self) {
        NSMutableDictionary *subscriptions = self.subscriptionsPerGroupIdentifier[identifier];
        if (subscriptions[name] != nil) { // don't permit duplicate subscriptions
            return NO;
        }
        subscriptions[name] = subscription; // subscriptionsPerGroupIdentifier is {identifier: subscription}, subscription is {name: TOAppGroupSubscriptionState}
    }
    
    // pick sequence number to match latest post or other subscriber, store it to make public this subscription
    dispatch_sync(self.fileIOQueue, ^{
        NSInteger lastSequenceNumber;
        if (![self hasStoredPostsForGroupIdentifier:identifier groupURL:appGroupURL name:name lastSequenceNumber:&lastSequenceNumber]) {
            NSDictionary *sequenceNumbersByName = [self storedSubscriptionSequenceNumbersForGroupIdentifier:identifier groupURL:appGroupURL names:@[name]];
            lastSequenceNumber = [self largestSequenceNumberAmong:sequenceNumbersByName[name] orIfNone:0];
        }
        
        subscription.lastReceivedSequenceNumber = lastSequenceNumber;
        //NSLog(@"for group %@, name \"%@\" set last sequence number to #%d", identifier, name, (int)lastSequenceNumber);
        
        NSString *bundleIdentifier = self.appIdentifier ?: [self.bundleIdHelper bundleIdForSubscribingToGroupIdentifier:identifier name:name];
        
        [self storeSequenceNumber:lastSequenceNumber forGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:bundleIdentifier name:name];
    });
    
    return YES;
}

- (BOOL)unsubscribeFromNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    if (appGroupURL == nil) {
        return NO;
    }
    
    // clear subscription state
    @synchronized(self) {
        NSMutableDictionary *subscriptions = self.subscriptionsPerGroupIdentifier[identifier];
        if (subscriptions[name] == nil) { // reject if not already subscribed
            return NO;
        }
        subscriptions[name] = nil;
    }
    
    // clear stored sequence number to make public this unsubscription
    dispatch_sync(self.fileIOQueue, ^{
        NSString *bundleIdentifier = self.appIdentifier ?: [self.bundleIdHelper bundleIdForUnsubscribingFromGroupIdentifier:identifier name:name];
        
        //NSLog(@"======== running clean-up for group %@, name \"%@\" on unsubscribe in app %@ ========", identifier, name, bundleIdentifier);
        [self cleanupPostsForGroupIdentifier:identifier groupURL:appGroupURL name:name];
        
        [self clearStoredSequenceNumberForGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:bundleIdentifier name:name];
    });
    
    return YES;
}

#pragma mark - Posting

- (BOOL)postNotificationForGroupIdentifier:(NSString *)identifier named:(NSString *)name payload:(nullable id)payload
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    if (appGroupURL == nil) {
        return NO;
    }
    
    // store post & notify other apps in group
    __block BOOL stored = NO;
    __block NSInteger cleanupSequenceNumber;
    dispatch_sync(self.fileIOQueue, ^{
        NSInteger psn, csn;
        if ([self storePostPayload:payload forGroupIdentifier:identifier groupURL:appGroupURL name:name gettingSequenceNumber:&psn cleanupSequenceNumber:&csn]) {
            stored = YES;
            cleanupSequenceNumber = csn;
            
            //NSLog(@"created new post to group %@, name \"%@\": #%d %@", identifier, name, (int)psn, [NSDate date]); // not exactly the same nsdate posted, close enuough
        }
    });
    if (stored) {
        [self.notificationHelper postGlobalMessageWithGroupIdentifier:identifier];
        
        // cleanup outdated posts every once & a while
        if (cleanupSequenceNumber >= 0 && self.cleanupFrequencyRandomFactor > 0 && arc4random_uniform(self.cleanupFrequencyRandomFactor) == 0) {
            dispatch_async(self.fileIOQueue, ^{
                //NSLog(@"======== running clean-up for group %@, name \"%@\" to seq num #%d after post ========", identifier, name, (int)cleanupSequenceNumber);
                [self cleanupPostsUpToSequenceNumber:cleanupSequenceNumber forGroupIdentifier:identifier groupURL:appGroupURL name:name];
            });
        }
        
        //else if (cleanupSequenceNumber >= 0 && self.cleanupFrequencyRandomFactor > 0) NSLog(@"skipping cleanup this time for group %@, name \"%@\" to seq num #%d", identifier, name, (int)cleanupSequenceNumber);
        //else NSLog(@"no cleanup needed for group %@, name \"%@\", limit seq num = %d, frequency factor = %d", identifier, name, (int)cleanupSequenceNumber, (int)self.cleanupFrequencyRandomFactor);
    }
    return stored;
}

#pragma mark - Receiving

- (void)globalNotificationCallbackForGroupIdentifier:(NSString *)identifier
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    NSAssert1(appGroupURL != nil, @"group identifier %@ should be valid for notifications to be observed", identifier);
    
    // remix subscriptions info for this identifier for use below outside of a synchronized block
    NSMutableDictionary *subscriptionSequenceNumbers = [NSMutableDictionary dictionary]; // {name: seq num}, parameter dict to pass to freshPostsForGroupIdentifier..
    NSMutableSet *subscribedNamesUsingQueuedDelivery = [NSMutableSet set]; // names which have queued flag set
    @synchronized(self) {
        NSDictionary *subscriptions = self.subscriptionsPerGroupIdentifier[identifier]; // {name: TOAppGroupSubscriptionState}
        
        for (NSString *name in subscriptions) {
            [subscriptionSequenceNumbers setObject:@(((TOAppGroupSubscriptionState *)subscriptions[name]).lastReceivedSequenceNumber) forKey:name];
            
            if (((TOAppGroupSubscriptionState *)subscriptions[name]).queued) {
                [subscribedNamesUsingQueuedDelivery addObject:name];
            }
        }
    }
    
    // if have no subscriptions, do nothing
    if (subscriptionSequenceNumbers.count == 0) {
        return;
    }
    
    dispatch_async(self.fileIOQueue, ^{
        NSMutableArray *freshPosts = [self freshPostsForGroupIdentifier:identifier groupURL:appGroupURL subscriptions:subscriptionSequenceNumbers].mutableCopy;
        
        // update sequence numbers state files and call subscriber's blocks for each post
        
        // by running this dispatched to the notify queue, will have exited our block the file io queue.
        // within is a sync-dispatch on the file io queue again, which should be ok
        // the issue is how to synchronize notifications and unsubscriptions, notably cannot use
        // dispatch_sync in unsubscribe method if we ever expect the subscription block to call it
        // (see "recursive locks" in dispatch_async man page).
        // rely on @synchronized below (which IS recursive) to prevent running the subscription block
        // after unsubscribe called, but don't prevent unnecessary calls to storeSequenceNumber
        
        dispatch_async(self.notifyQueue, ^{
            
            for (TOAppGroupNotificationPost *post in freshPosts) {
                BOOL queuedSubscription = [subscribedNamesUsingQueuedDelivery containsObject:post.name];
                
                //NSLog(@"found new post to group %@, name \"%@\": #%d %@", identifier, post.name, (int)post.sequenceNumber, post.date);
                //NSLog(@"  %s deliver #%d, is-last=%s, queued-subcription=%s", (post.lastInGroupForName || queuedSubscription)?"will":"won't", (int)post.sequenceNumber, post.lastInGroupForName?"true":"false", queuedSubscription?"true":"false");
                
                if (post.lastInGroupForName || queuedSubscription) {
                    
                    dispatch_sync(self.fileIOQueue, ^{
                        NSString *bundleIdentifier = self.appIdentifier ?: [self.bundleIdHelper bundleIdForReceivingPostWithGroupIdentifier:identifier name:post.name];
                        
                        [self storeSequenceNumber:post.sequenceNumber forGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:bundleIdentifier name:post.name];
                    });
                    
                    // avoid race conditions by synchronizing & re-testing subscription & seq num validity
                    // (why race? because different threads can be running this callback at the same time,
                    // and another one can be trying to deliver the same posts)
                    @synchronized(self) {
                        NSDictionary *subscriptions = self.subscriptionsPerGroupIdentifier[identifier];
                        TOAppGroupSubscriptionState *subscription = subscriptions[post.name];
                        
                        //if (subscription == nil)
                        //    NSLog(@"for group %@, name \"%@\" caught case while handling post #%d where suddenly unsubscribed", identifier, post.name, (int)post.sequenceNumber);
                        //else if (post.sequenceNumber <= subscription.lastReceivedSequenceNumber)
                        //    NSLog(@"for group %@, name \"%@\" caught case while handling post #%d where subscription # suddenly advanced to %d", identifier, post.name, (int)post.sequenceNumber, (int)subscription.lastReceivedSequenceNumber);
                        //else
                        //    NSLog(@"for group %@, name \"%@\" setting last sequence number to #%d and calling subscriber block", identifier, post.name, (int)post.sequenceNumber);
                        
                        if (subscription != nil && post.sequenceNumber > subscription.lastReceivedSequenceNumber) {
                            subscription.lastReceivedSequenceNumber = post.sequenceNumber;
                            subscription.block(identifier, post.name, post.payload, post.date);
                        }
                    }
                }
            }
            
        });
    });
}

#pragma mark - Post storage

- (NSURL *)groupURLForGroupIdentifier:(NSString *)identifier
{
    return [self.fileManager containerURLForSecurityApplicationGroupIdentifier:identifier];
}

- (BOOL)storePostPayload:(nullable id)payload forGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL name:(NSString *)name gettingSequenceNumber:(nullable NSInteger *)outSequenceNumber cleanupSequenceNumber:(nullable NSInteger *)outCleanupSequenceNumber
{
    // skip if no subscribers
    NSDictionary *sequenceNumbersByName = [self storedSubscriptionSequenceNumbersForGroupIdentifier:identifier groupURL:appGroupURL names:@[name]];
    NSDictionary *subscriberSequenceNumbers = sequenceNumbersByName[name];
    if (!self.permitPostsWhenNoSubscribers && subscriberSequenceNumbers.count == 0) {
        //NSLog(@"no subscribers, not bothering to store post for group %@, name \"%@\"", identifier, name);
        return NO;
    }
    
    // create data from payload
    NSError *error;
    NSData *postData;
    if (payload == nil) {
        postData = [NSData data];
    }
    else {
        postData = [NSPropertyListSerialization dataWithPropertyList:payload format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
        if (postData == nil) {
            NSLog(@"unable to serialze %@ payload: %@", payload?[payload class]:@"nil?", error.localizedDescription);
            return NO;
        }
    }
    
    // pick seq num
    NSInteger nextSequenceNumber;
    if ([self hasStoredPostsForGroupIdentifier:identifier groupURL:appGroupURL name:name lastSequenceNumber:&nextSequenceNumber]) {
        //NSLog(@"largest post file sequence number for group %@, name \"%@\" is %d", identifier, name, (int)nextSequenceNumber);
        nextSequenceNumber += 1;
        NSAssert2(nextSequenceNumber > [self smallestSequenceNumberAmong:subscriberSequenceNumbers orIfNone:-1], @"next sequence number picked is out of sequence, #%d vs received #s %@", (int)nextSequenceNumber, [subscriberSequenceNumbers.allValues componentsJoinedByString:@","]);
    }
    else {
        nextSequenceNumber = [self largestSequenceNumberAmong:subscriberSequenceNumbers orIfNone:-1];
        //NSLog(@"largest subscriber sequence number for group %@, name \"%@\" is %d", identifier, name, (int)nextSequenceNumber);
        nextSequenceNumber += 1;
    }
    
    // store data, contending with other apps doing the same by retrying at next seq num if intended file is taken
    for (;; nextSequenceNumber += 1) {
        NSURL *postURL = [self postURLForContainerURL:appGroupURL name:name sequenceNumber:nextSequenceNumber];;
        
        if (![self.fileManager createDirectoryAtURL:postURL.URLByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"unable to create post storage directory %@: %@", postURL.URLByDeletingLastPathComponent.lastPathComponent, error.localizedDescription);
            return NO;
        }
        
        if (![postData writeToURL:postURL options:NSDataWritingWithoutOverwriting error:&error]) {
            if (error.code == NSFileWriteFileExistsError) {
                continue;
            } else {
                NSLog(@"unable to write post storage file %@: %@", postURL.path.lastPathComponent, error.localizedDescription);
                return NO;
            }
        }
        
        //NSLog(@"post for group %@, name \"%@\" written to %@", identifier, name, postURL.path.lastPathComponent);
        break;
    }
    
    // return relevant sequence numbers
    if (outSequenceNumber != NULL) {
        *outSequenceNumber = nextSequenceNumber;
    }
    if (outCleanupSequenceNumber != NULL) {
        *outCleanupSequenceNumber = [self smallestSequenceNumberAmong:subscriberSequenceNumbers orIfNone:-1];
        
        //if (subscriberSequenceNumbers.count > 0) NSLog(@"    subscriber last sequence numbers for group %@, name \"%@\" = %@", identifier, name, [subscriberSequenceNumbers.allValues componentsJoinedByString:@","]);
    }
    return YES;
}

- (NSArray *)freshPostsForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL subscriptions:(NSDictionary *)subscriptionSequenceNumbers
{
    NSError *error;
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtURL:appGroupURL includingPropertiesForKeys:@[NSURLCreationDateKey,NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (directoryContents == nil && error.code != NSFileNoSuchFileError && error.code != NSFileReadNoSuchFileError) {
        NSLog(@"unable to scan directory for group %@, %@: %@", identifier, appGroupURL, error.localizedDescription);
        return nil;
        // when error code is NoSuchFileError, code below must work well with directoryContents == nil
    }
    
    NSSet *subscribedNames = [NSSet setWithArray:subscriptionSequenceNumbers.allKeys];
    NSMutableArray *postResults = [NSMutableArray array];
    
    for (NSURL *url in directoryContents) {
        // skip directories
        NSNumber *isDirectoryNum;
        if ([url getResourceValue:&isDirectoryNum forKey:NSURLIsDirectoryKey error:NULL] && isDirectoryNum.boolValue) {
            continue;
        }
        
        // skip post files we're not interested in...
        NSString *postName;
        NSInteger postSequenceNumber;
        if (![self getFromPostURL:url name:&postName sequenceNumber:&postSequenceNumber]) {
            NSLog(@"unable to parse post name of file %@", url);
            continue;
        }
        // .. posts for names not subscribed to
        if (![subscribedNames containsObject:postName]) {
            continue;
        }
        // .. posts that have previously been delivered, ie. seq num not > the last one
        NSNumber *sequenceNumberNum = subscriptionSequenceNumbers[postName];
        NSInteger lastSequenceNumber = sequenceNumberNum ? sequenceNumberNum.integerValue : 0;
        if (postSequenceNumber <= lastSequenceNumber) {
            continue;
        }
        
        // construct post object containing payload
        NSError *error;
        NSDate *postDate;
        if (![url getResourceValue:&postDate forKey:NSURLCreationDateKey error:&error]) {
            NSLog(@"unable to get post date from file %@: %@", url, error.localizedDescription);
        }
        NSData *postData = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if (!postData) {
            NSLog(@"unable to read post file %@: %@", url, error.localizedDescription);
            continue;
        }
        id payload = [NSPropertyListSerialization propertyListWithData:postData options:0 format:NULL error:&error];
        if (payload == nil) {
            NSLog(@"unable to reconstruct post payload from file %@: %@", url, error.localizedDescription);
        }
        
        TOAppGroupNotificationPost *post = [[TOAppGroupNotificationPost alloc] init];
        post.identifier = identifier;
        post.name = postName;
        post.sequenceNumber = postSequenceNumber;
        post.date = postDate;
        post.payload = payload;
        post.lastInGroupForName = NO; // set to YES for the correct posts below
        [postResults addObject:post];
    }
    
    //NSLog(@"%d fresh post files, %d filtered-out filesystem item(s) for group %@", (int)postResults.count, (int)(directoryContents.count - postResults.count), identifier);
    
    // sort by post date / seq num of posts sharing same name
    [postResults sortUsingComparator:^NSComparisonResult(TOAppGroupNotificationPost *post1, TOAppGroupNotificationPost *post2) {
        NSComparisonResult compareDates = [post1.date compare:post2.date];
        if (compareDates == NSOrderedSame && [post1.name isEqualToString:post2.name])
            return post1.sequenceNumber < post2.sequenceNumber ? NSOrderedAscending : NSOrderedDescending; // impossible to have same sequence numbers, file names would be identical
        else
            return compareDates;
    }];
    
    // now that its sorted, iterate backwards and set the lastInGroupForName flag for the last post for each name
    NSMutableSet *encounteredNames = [NSMutableSet set];
    for (TOAppGroupNotificationPost *post in postResults.reverseObjectEnumerator) {
        if (![encounteredNames containsObject:post.name]) {
            post.lastInGroupForName = YES;
            [encounteredNames addObject:post.name];
        }
        if ([encounteredNames isEqualToSet:subscribedNames]) break;
    }
    
    return postResults;
}

- (void)cleanupPostsForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL name:(NSString *)name
{
    // find all sequence numbers for this name to know which post files can be safely deleted
    NSDictionary *sequenceNumbersByName = [self storedSubscriptionSequenceNumbersForGroupIdentifier:identifier groupURL:appGroupURL names:@[name]];
    if (sequenceNumbersByName == nil) {
        return; // something weird going on, not safe to delete any
    }
    
    // continue the cleanup, if array was empty then calls with seq num = -1 to delete all posts
    NSInteger smallestReceivedSequenceNumber = [self smallestSequenceNumberAmong:sequenceNumbersByName[name] orIfNone:-1];
    [self cleanupPostsUpToSequenceNumber:smallestReceivedSequenceNumber forGroupIdentifier:identifier groupURL:appGroupURL name:name];
}

- (void)cleanupPostsUpToSequenceNumber:(NSInteger)limitSequenceNumber forGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL name:(NSString *)name
{
    // remove all post files up to & including this sequence number, they've been received by all subscribers
    // if sequence number is < 0 then delete all post files
    NSError *error;
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtURL:appGroupURL includingPropertiesForKeys:@[NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (directoryContents == nil && error.code != NSFileNoSuchFileError && error.code != NSFileReadNoSuchFileError) {
        NSLog(@"unable to scan directory for group %@, %@: %@", identifier, appGroupURL, error.localizedDescription);
        return;
    }
    else if (directoryContents == nil) {
        return; // directory not found? maybe there's no posts yet? in any case can't proceed
    }
    
    for (NSURL *url in directoryContents) {
        // skip directories
        NSNumber *isDirectoryNum;
        if ([url getResourceValue:&isDirectoryNum forKey:NSURLIsDirectoryKey error:NULL] && isDirectoryNum.boolValue) {
            continue;
        }
        
        // remove file if its seq num is <= limit
        NSInteger postSequenceNumber;
        if ([self matchedPostURL:url toName:name gettingSequenceNumber:&postSequenceNumber] && (limitSequenceNumber < 0 || postSequenceNumber <= limitSequenceNumber)) {
            if (![self.fileManager removeItemAtURL:url error:&error] && error.code != NSFileNoSuchFileError) { // if someone else has already removed the file, don't log complaint
                NSLog(@"unable to remove old post file %@: %@", url, error.localizedDescription);
            }
            //else NSLog(@"==== removed old post file %@", url);
        }
    }
}

- (BOOL)hasStoredPostsForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL name:(NSString *)name lastSequenceNumber:(nullable NSInteger *)outSequenceNumber
{
    NSError *error;
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtURL:appGroupURL includingPropertiesForKeys:@[NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (directoryContents == nil && error.code != NSFileNoSuchFileError && error.code != NSFileReadNoSuchFileError) {
        NSLog(@"unable to scan directory for group %@, %@: %@", identifier, appGroupURL, error.localizedDescription);
        return 0;
        // when error code is NoSuchFileError, code below must work well with directoryContents == nil
    }
    
    NSInteger largestSequenceNumber = NSNotFound;
    for (NSURL *url in directoryContents) {
        // skip directories
        NSNumber *isDirectoryNum;
        if ([url getResourceValue:&isDirectoryNum forKey:NSURLIsDirectoryKey error:NULL] && isDirectoryNum.boolValue) {
            continue;
        }
        
        // see if this file is for our name, is its seq num is larger
        NSInteger postSequenceNumber = 0;
        if ([self matchedPostURL:url toName:name gettingSequenceNumber:&postSequenceNumber] && (largestSequenceNumber == NSNotFound || postSequenceNumber > largestSequenceNumber)) {
            largestSequenceNumber = postSequenceNumber;
        }
    }
    
    if (largestSequenceNumber != NSNotFound && outSequenceNumber != nil) {
        *outSequenceNumber = largestSequenceNumber;
    }
    return largestSequenceNumber != NSNotFound;
}

#pragma mark - Darwin notifications

- (void)subscribeAppGroupNotificationManager:(TOAppGroupNotificationManager *)manager toGlobalMessagesWithGroupIdentifier:(NSString *)identifier
{
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    // for the darwin notifications, the identifier is used as the notification's name string
    CFNotificationCenterAddObserver(center, (__bridge const void *)(self), darwinNotificationCallback, (__bridge CFStringRef)identifier, NULL, 0);
}

- (void)unsubscribeAppGroupNotificationManager:(TOAppGroupNotificationManager *)manager fromGlobalMessagesWithGroupIdentifier:(NSString *)identifier
{
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterRemoveObserver(center, (__bridge const void *)(self), (__bridge CFStringRef)identifier, NULL);
}

- (void)postGlobalMessageWithGroupIdentifier:(NSString *)identifier
{
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(center, (__bridge CFStringRef)identifier, NULL, NULL, YES);
}

void darwinNotificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef identifierName, void const *object, CFDictionaryRef userInfo)
{
    NSString *identifier = (__bridge NSString *)identifierName;
    TOAppGroupNotificationManager *manager = (__bridge TOAppGroupNotificationManager *)observer; // is it bad form to create a local named 'self' in a C function?
    [manager globalNotificationCallbackForGroupIdentifier:identifier];
}

#pragma mark - Post pathnames

- (NSURL *)postURLForContainerURL:(NSURL *)containerURL name:(NSString *)name sequenceNumber:(NSInteger)sequenceNumber
{
    NSString *postFileName = [[NSString stringWithFormat:@"%@%@%d", name, postFileNameSeparator, (int)sequenceNumber] stringByAppendingPathExtension:postFileNameExtension];
    NSURL *postURL = [containerURL URLByAppendingPathComponent:postFileName];
    return postURL;
}

- (BOOL)getFromPostURL:(NSURL *)postURL name:(NSString **)outName sequenceNumber:(NSInteger *)outSequenceNumber
{
    NSString *name = [postURL.path.lastPathComponent stringByDeletingPathExtension];
    NSRange range = [name rangeOfString:postFileNameSeparator options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return NO;
    }
    
    if (outName != NULL) {
        *outName = [name substringToIndex:range.location];
    }
    if (outSequenceNumber != NULL) {
        NSNumber *sequenceNum = [self.numberFormatter numberFromString:[name substringFromIndex:range.location + 1]];
        *outSequenceNumber = sequenceNum.integerValue;
    }
    return YES;
}

- (BOOL)matchedPostURL:(NSURL *)postURL toName:(NSString *)matchName gettingSequenceNumber:(NSInteger *)outSequenceNumber
{
    NSString *name = [postURL.path.lastPathComponent stringByDeletingPathExtension];
    NSRange range = [name rangeOfString:postFileNameSeparator options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return NO;
    }
    if (![[name substringToIndex:range.location] isEqualToString:matchName]) {
        return NO;
    }
    
    if (outSequenceNumber != NULL) {
        NSNumber *sequenceNum = [self.numberFormatter numberFromString:[name substringFromIndex:range.location + 1]];
        *outSequenceNumber = sequenceNum.integerValue;
    }
    return YES;
}

#pragma mark - Sequence number state

- (void)storeSequenceNumber:(NSInteger)sequenceNumber forGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL bundleIdentifier:(NSString *)bundleIdentifier name:(NSString *)name
{
    NSURL *sequenceNumbersDirURL = [[appGroupURL URLByAppendingPathComponent:sequenceNumberDirName] URLByAppendingPathComponent:bundleIdentifier];
    NSError *error;
    if (![self.fileManager createDirectoryAtURL:sequenceNumbersDirURL withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"unable to create app sequence number storage directory for group %@, %@: %@", identifier, sequenceNumbersDirURL, error.localizedDescription);
        return;
    }
    
    NSString *sequenceNumberFileName = [name stringByAppendingPathExtension:sequenceNumberFileNameExtension];
    NSURL *sequenceNumberFileURL = [sequenceNumbersDirURL URLByAppendingPathComponent:sequenceNumberFileName];
    
    // check that there isn't a current file why contents is a larger sequence number
    NSData *oldFileData = [NSData dataWithContentsOfURL:sequenceNumberFileURL options:0 error:&error];
    if (oldFileData == nil && error.code != NSFileReadNoSuchFileError) {
        NSLog(@"unable to read sequence number file %@: %@", sequenceNumberFileURL, error.localizedDescription);
    }
    else if (oldFileData != nil) {
        NSString *fileString = [[NSString alloc] initWithData:oldFileData encoding:NSUTF8StringEncoding];
        NSNumber *sequenceNum = [self.numberFormatter numberFromString:fileString];
        if (sequenceNum == nil) {
            NSLog(@"unable to parse contents \"%@\" of sequence number file %@: %@", fileString, sequenceNumberFileURL, error.localizedDescription);
        }
        else if (sequenceNum.integerValue > sequenceNumber) {
            NSLog(@"sequence number file for group %@, name \"%@\" is already #%d, larger than intended #%d", identifier, name, (int)sequenceNum.integerValue, (int)sequenceNumber);
            return;
        }
    }
    
    NSData *fileData = [[self.numberFormatter stringFromNumber:@(sequenceNumber)] dataUsingEncoding:NSUTF8StringEncoding];
    if (![fileData writeToURL:sequenceNumberFileURL options:0 error:&error]) {
        NSLog(@"unable to write sequence number file for group %@, name \"%@\" %@: %@", identifier, name, sequenceNumberFileURL, error.localizedDescription);
        return;
    }
    
    //NSLog(@"wrote #%d to sequence number file for group %@, name \"%@\" bundleid %@", (int)sequenceNumber, identifier, name, bundleIdentifier);
}

- (void)clearStoredSequenceNumberForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL bundleIdentifier:(NSString *)bundleIdentifier name:(NSString *)name
{
    NSURL *sequenceNumbersDirURL = [[appGroupURL URLByAppendingPathComponent:sequenceNumberDirName] URLByAppendingPathComponent:bundleIdentifier];
    
    NSString *sequenceNumberFileName = [name stringByAppendingPathExtension:sequenceNumberFileNameExtension];
    NSURL *sequenceNumberFileURL = [sequenceNumbersDirURL URLByAppendingPathComponent:sequenceNumberFileName];
    
    NSError *error;
    if (![self.fileManager removeItemAtURL:sequenceNumberFileURL error:&error]) {
        if (error.code != NSFileNoSuchFileError) {
            NSLog(@"unable to delete app sequence number file for group %@, name \"%@\" %@: %@", identifier, name, sequenceNumberFileURL, error.localizedDescription);
        }
        return;
    }
    
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtURL:sequenceNumbersDirURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (directoryContents == nil) {
        NSLog(@"unable to read contents of app sequence number directory for group %@, name \"%@\" %@: %@", identifier, name, sequenceNumbersDirURL, error.localizedDescription);
        return;
    }
    if (directoryContents.count == 0) {
        if (![self.fileManager removeItemAtURL:sequenceNumbersDirURL error:&error]) {
            NSLog(@"unable to delete empty app sequence number directory for group %@, name \"%@\" %@: %@", identifier, name, sequenceNumbersDirURL, error.localizedDescription);
        }
    }
}

- (void)clearStoredSequenceNumbersForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL bundleIdentifier:(NSString *)bundleIdentifier
{
    NSURL *sequenceNumbersDirURL = [[appGroupURL URLByAppendingPathComponent:sequenceNumberDirName] URLByAppendingPathComponent:bundleIdentifier];
    NSError *error;
    if (![self.fileManager removeItemAtURL:sequenceNumbersDirURL error:&error] && error.code != NSFileNoSuchFileError) {
        NSLog(@"unable to delete app sequence number storage directory for group %@, %@: %@", identifier, sequenceNumbersDirURL, error.localizedDescription);
    }
}

- (NSSet *)storedSubscriptionNamesForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL bundleIdentifier:(NSString *)bundleIdentifier
{
    NSURL *sequenceNumbersDirURL = [[appGroupURL URLByAppendingPathComponent:sequenceNumberDirName] URLByAppendingPathComponent:bundleIdentifier];
    
    NSError *error;
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtURL:sequenceNumbersDirURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (directoryContents == nil && error.code != NSFileNoSuchFileError && error.code != NSFileReadNoSuchFileError) {
        NSLog(@"unable to scan app-specific sequence number storage directory for group %@, %@: %@", identifier, sequenceNumbersDirURL, error.localizedDescription);
        // no matter the error code, code below must work well with directoryContents == nil
    }
    
    NSMutableSet *nameResults = [NSMutableSet set];
    
    for (NSURL *fileURL in directoryContents) {
        NSString *name = fileURL.path.lastPathComponent.stringByDeletingPathExtension;
        [nameResults addObject:name];
    }
    
    return nameResults;
}

- (NSDictionary *)storedSubscriptionSequenceNumbersForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL names:(NSArray *)names
{
    NSURL *allSequenceNumbersDirURL = [appGroupURL URLByAppendingPathComponent:sequenceNumberDirName];
    NSError *error;
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtURL:allSequenceNumbersDirURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (directoryContents == nil && error.code != NSFileNoSuchFileError && error.code != NSFileReadNoSuchFileError) {
        NSLog(@"unable to scan sequence number storage directory for group %@, %@: %@", identifier, allSequenceNumbersDirURL, error.localizedDescription);
        return nil;
        // when error code is NoSuchFileError, code below must work well with directoryContents == nil
    }
    
    // directory contents are bundle-id/name.seqnum file containing sequence number string
    NSMutableDictionary *sequenceNumberResults = [NSMutableDictionary dictionary];
    
    for (NSURL *subdirectoryURL in directoryContents) {
        NSString *bundleIDForSubdirectory = subdirectoryURL.lastPathComponent;
        
        NSArray *subdirectoryContents = [self.fileManager contentsOfDirectoryAtURL:subdirectoryURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        if (subdirectoryContents == nil && error.code != NSFileNoSuchFileError && error.code != NSFileReadNoSuchFileError) {
            NSLog(@"unable to scan app-specific sequence number storage directory for group %@, %@: %@", identifier, subdirectoryURL, error.localizedDescription);
            // no matter the error code, code below must work well with subdirectoryContents == nil
        }
        
        for (NSURL *fileURL in subdirectoryContents) {
            NSString *name = fileURL.path.lastPathComponent.stringByDeletingPathExtension;
            if (names != nil && ![names containsObject:name]) { // skip if interested in only certain names and this isn't one of them
                continue;
            }
            
            NSData *fileData = [NSData dataWithContentsOfURL:fileURL options:0 error:&error];
            if (!fileData) {
                NSLog(@"unable to read sequence number file %@: %@", fileURL, error.localizedDescription);
                continue;
            }
            NSString *fileString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
            NSNumber *sequenceNum = [self.numberFormatter numberFromString:fileString];
            if (sequenceNum == nil) {
                NSLog(@"unable to parse contents \"%@\" of sequence number file %@: %@", fileString, fileURL, error.localizedDescription);
                continue;
            }
            
            // build results {name: {bundle-id: seqnum}}, yes intentionally reversed from directory structure that's bundle-id/name
            NSMutableDictionary *sequenceNumberResultsForName = sequenceNumberResults[name];
            if (sequenceNumberResultsForName == nil) {
                sequenceNumberResultsForName = [NSMutableDictionary dictionary];
                sequenceNumberResults[name] = sequenceNumberResultsForName;
            }
            sequenceNumberResultsForName[bundleIDForSubdirectory] = sequenceNum;
        }
    }
    
    return sequenceNumberResults;
}

- (NSInteger)smallestSequenceNumberAmong:(NSDictionary *)subscriberSequenceNumbers orIfNone:(NSInteger)notFoundNumber
{
    // find smallest (positive) sequence number, or the given default number if none
    NSInteger smallestReceivedSequenceNumber = NSNotFound;
    for (NSNumber *sequenceNumberNum in subscriberSequenceNumbers.allValues) {
        NSInteger sequenceNumber = sequenceNumberNum.integerValue;
        if (smallestReceivedSequenceNumber == NSNotFound || sequenceNumber < smallestReceivedSequenceNumber)
            smallestReceivedSequenceNumber = sequenceNumber;
    };
    return smallestReceivedSequenceNumber == NSNotFound ? notFoundNumber : smallestReceivedSequenceNumber;
}

- (NSInteger)largestSequenceNumberAmong:(NSDictionary *)subscriberSequenceNumbers orIfNone:(NSInteger)notFoundNumber
{
    // find largest sequence number, or the given default number if none
    NSInteger largestReceivedSequenceNumber = NSNotFound;
    for (NSNumber *sequenceNumberNum in subscriberSequenceNumbers.allValues) {
        NSInteger sequenceNumber = sequenceNumberNum.integerValue;
        if (largestReceivedSequenceNumber == NSNotFound || sequenceNumber > largestReceivedSequenceNumber)
            largestReceivedSequenceNumber = sequenceNumber;
    };
    return largestReceivedSequenceNumber == NSNotFound ? notFoundNumber : largestReceivedSequenceNumber;
}

@end


@implementation TOAppGroupSubscriptionState
- (NSString *)description { return [NSString stringWithFormat:@"<%@: %p, %s, last#=%d, b=%p>", NSStringFromClass(self.class), self, self.queued?"queued":"latest", (int)self.lastReceivedSequenceNumber, self.block]; }
@end

@implementation TOAppGroupNotificationPost
- (NSString *)description { return [NSString stringWithFormat:@"<%@: %p, \"%@\" #%d %@: %@>", NSStringFromClass(self.class), self, self.name, (int)self.sequenceNumber, self.date, self.payload ? [(NSObject *)self.payload description] : @"nil"]; }
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
