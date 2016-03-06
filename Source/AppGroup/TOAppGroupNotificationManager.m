//
//  TOAppGroupNotificationManager.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

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
@property (nonatomic, nullable) id<NSCoding>payload;
@property (nonatomic) BOOL lastInGroupForName;
@end

@interface TOAppGroupNotificationManager () <TOAppGroupURLProviding, TOAppGroupGlobalNotificationHandling>
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSNumberFormatter *numberFormatter;

@property (nonatomic) NSMutableDictionary *subscriptionsPerGroupIdentifier; // {groupid: {name: state}}
@property (nonatomic) NSMutableArray *orderedIdentifiers;
@property (nonatomic) dispatch_queue_t fileIOQueue;
@property (nonatomic) dispatch_queue_t notifyQueue;
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
    return self;
}

- (nullable NSString *)appIdentifier
{
    if (_appIdentifier == nil) {
        _appIdentifier = [NSBundle mainBundle].bundleIdentifier;
    }
    return _appIdentifier;
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
        NSLog(@"unable to use app group \"%@\", capabilities may not be correctly configured for your project, or the identifier may not equal that of a configured group", identifier);
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
    
    NSString *bundleIdentifier = self.appIdentifier;
    
    dispatch_async(self.fileIOQueue, ^{
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
    
    TOAppGroupSubscriptionState *subscription = [[TOAppGroupSubscriptionState alloc] init];
    subscription.block = block;
    subscription.queued = queued;
    
    // don't allow duplicate subscriptions
    @synchronized(self) {
        NSMutableDictionary *subscriptions = self.subscriptionsPerGroupIdentifier[identifier];
        if (subscriptions[name] != nil) {
            return NO;
        }
        subscriptions[name] = subscription; // subscriptionsPerGroupIdentifier is {identifier: subscription}, subscription is {name: TOAppGroupSubscriptionState}
    }
    
    dispatch_sync(self.fileIOQueue, ^{
        subscription.lastReceivedSequenceNumber = [self lastSequenceNumberForGroupIdentifier:identifier groupURL:appGroupURL name:name];
    });
    
    return YES;
}

- (BOOL)unsubscribeToNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    if (appGroupURL == nil) {
        return NO;
    }
    
    @synchronized(self) {
        NSMutableDictionary *subscriptions = self.subscriptionsPerGroupIdentifier[identifier];
        if (subscriptions[name] == nil) {
            return NO;
        }
        subscriptions[name] = nil;
    }
    
    NSString *bundleIdentifier = self.appIdentifier;
    
    dispatch_sync(self.fileIOQueue, ^{
        [self clearStoredSequenceNumberForGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:bundleIdentifier name:name];
    });
    
    return YES;
}

#pragma mark - Posting

- (BOOL)postNotificationForGroupIdentifier:(NSString *)identifier named:(NSString *)name payload:(nullable id<NSCoding>)payload
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    if (appGroupURL == nil) {
        return NO;
    }
    
    __block BOOL stored = NO;
    dispatch_sync(self.fileIOQueue, ^{
        if ([self storePostPayload:payload forGroupIdentifier:identifier groupURL:appGroupURL name:name]) {
            stored = YES;
        }
    });
    if (stored) {
        [self.notificationHelper postGlobalMessageWithGroupIdentifier:identifier];
    }
    return stored;
    
    // was:
//    if (![self storePostPayload:payload forGroupIdentifier:identifier groupURL:appGroupURL name:name]) {
//        return NO;
//    }
//    [self.notificationHelper postGlobalMessageWithGroupIdentifier:identifier];
//    return YES;
}

#pragma mark - Receiving

- (void)globalNotificationCallbackForGroupIdentifier:(NSString *)identifier
{
    NSURL *appGroupURL = [self.urlHelper groupURLForGroupIdentifier:identifier];
    NSAssert1(appGroupURL != nil, @"group identifier %@ should be valid for notifications to be observed", identifier);
    
    NSString *bundleIdentifier = self.appIdentifier;
    
    dispatch_async(self.fileIOQueue, ^{
        
        NSDictionary *subscriptions;
        NSMutableSet *subscribedNames = [NSMutableSet set];
        NSMutableSet *subscribedNamesWithQueuedDelivery = [NSMutableSet set];
        NSMutableDictionary *subscriptionSequenceNumbers = [NSMutableDictionary dictionary];
        @synchronized(self) {
            subscriptions = self.subscriptionsPerGroupIdentifier[identifier]; // {name: TOAppGroupSubscriptionState}
            
            NSArray *subscribedNameArray = subscriptions.allKeys;
            [subscribedNames addObjectsFromArray:subscribedNameArray];
            for (NSString *name in subscribedNameArray) {
                [subscriptionSequenceNumbers setObject:@(((TOAppGroupSubscriptionState *)subscriptions[name]).lastReceivedSequenceNumber) forKey:name];
                if (((TOAppGroupSubscriptionState *)subscriptions[name]).queued) {
                    [subscribedNamesWithQueuedDelivery addObject:name];
                }
            }
        }
        if (subscriptions.count == 0) {
            return;
        }
        
        NSMutableArray *freshPosts = [self freshPostsForGroupIdentifier:identifier groupURL:appGroupURL subscriptions:subscriptionSequenceNumbers].mutableCopy;
        
        // ignore posts for names not subscribed to, and for those *are* subscribed to set lastInGroupForName flag appropriately
        // (its for the sake of setting lastInGroupForName that we're iterting backwards)
        NSMutableSet *encounteredNames = [NSMutableSet set];
        NSMutableSet *ignoredPosts = [NSMutableSet set];
        
        for (TOAppGroupNotificationPost *post in freshPosts.reverseObjectEnumerator) {
            if (![subscribedNames containsObject:post.name]) {
                [ignoredPosts addObject:post];
            }
            else if (![encounteredNames containsObject:post.name]) {
                post.lastInGroupForName = YES;
                [encounteredNames addObject:post.name];
            }
            else {
                post.lastInGroupForName = NO;
            }
        }
        [freshPosts removeObjectsInArray:ignoredPosts.allObjects];
        
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
                BOOL queuedSubscription = [subscribedNamesWithQueuedDelivery containsObject:post.name];
                
                //NSLog(@"found new post to group %@, name %@: #%d %@", identifier, post.name, (int)post.sequenceNumber, post.date);
                //NSLog(@"  %s deliver #%d, is-last=%s, queued-subcription=%s", (post.lastInGroupForName || queuedSubscription)?"will":"won't", (int)post.sequenceNumber, post.lastInGroupForName?"true":"false", queuedSubscription?"true":"false");
                
                if (post.lastInGroupForName || queuedSubscription) {
                    
                    dispatch_sync(self.fileIOQueue, ^{
                        [self storeSequenceNumber:post.sequenceNumber forGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:bundleIdentifier name:post.name];
                    });
                    
                    // avoid race conditions by synchronizing & re-testing subscription & seqnum validity
                    @synchronized(self) {
                        NSDictionary *subscriptions = self.subscriptionsPerGroupIdentifier[identifier];
                        TOAppGroupSubscriptionState *subscription = subscriptions[post.name];
                        
                        // !!! remove this logging yet?
                        if (subscription == nil)
                            NSLog(@"for group %@, name %@ caught case while handling post #%d where suddenly unsubscribed", identifier, post.name, (int)post.sequenceNumber);
                        else if (post.sequenceNumber <= subscription.lastReceivedSequenceNumber)
                            NSLog(@"for group %@, name %@ caught case while handling post #%d where subscription # suddenly advanced to %d", identifier, post.name, (int)post.sequenceNumber, (int)subscription.lastReceivedSequenceNumber);
                        
                        if (subscription != nil && post.sequenceNumber > subscription.lastReceivedSequenceNumber) {
                            subscription.lastReceivedSequenceNumber = post.sequenceNumber;
                            subscription.block(identifier, post.name, post.payload, post.date);
                        }
                    }
                }
            }
            
        });
        
    });
    
    // was:
//    ...
//    // update sequence numbers state files and call subscriber's blocks for each post
//    
//    for (TOAppGroupNotificationPost *post in freshPosts) {
//        //NSLog(@"found new post to group %@, name %@: #%d %@", identifier, post.name, (int)post.sequenceNumber, post.date);
//        
//        TOAppGroupSubscriptionState *subscription = subscriptions[post.name];
//        NSAssert1(subscription != nil, @"post for not-subscribed name %@ should have been filter out before now", post.name);
//        NSAssert3(post.sequenceNumber > subscription.lastReceivedSequenceNumber, @"old post for subscribed name %@ #%d (compared to #%d) should have been filter out before now", post.name, (int)post.sequenceNumber, (int)subscription.lastReceivedSequenceNumber);
//        
//        //NSLog(@"  %s deliver #%d, is-last=%s, queued-subcription=%s", (post.lastInGroupForName || subscription.queued)?"will":"won't", (int)post.sequenceNumber, post.lastInGroupForName?"true":"false", subscription.queued?"true":"false");
//        if (post.lastInGroupForName || subscription.queued) {
//            subscription.lastReceivedSequenceNumber = post.sequenceNumber;
//            [self storeSequenceNumber:post.sequenceNumber forGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:self.appIdentifier name:post.name];
//            
//            subscription.block(identifier, post.name, post.payload, post.date);
//        }
//    }
    
    // was updaing sequence number files in a batch after calling all notification blocks, now one-at-a-time just before calling each block
    // so now if app hangs or exits within the block then these notifications won't be replayed on the next launch
//    for (NSString *name in encounteredNames) {
//        TOAppGroupSubscriptionState *subscription = subscriptions[name];
//        NSAssert1(subscription != nil, @"not-subscribed name %@ should have been filter out before now", name);
//
//        [self storeSequenceNumber:subscription.lastReceivedSequenceNumber forGroupIdentifier:identifier groupURL:appGroupURL bundleIdentifier:self.appIdentifier name:name];
//    }
}

#pragma mark - Post storage

- (NSURL *)groupURLForGroupIdentifier:(NSString *)identifier
{
    return [self.fileManager containerURLForSecurityApplicationGroupIdentifier:identifier];
}

- (BOOL)storePostPayload:(nullable id)payload forGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL name:(NSString *)name
{
    NSError *error;
    NSData *postData = nil;
    if (payload == nil) {
        payload = [NSData data];
    }
    else {
        postData = [NSPropertyListSerialization dataWithPropertyList:payload format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
        if (postData == nil) {
            NSLog(@"unable to serialze %@ payload: %@", payload?[payload class]:@"nil?", error.localizedDescription);
            return NO;
        }
    }
    
    NSInteger nextSequenceNumber = [self lastSequenceNumberForGroupIdentifier:identifier groupURL:appGroupURL name:name];
    // initially the most-recently used number, but immediately incremented at the top of the loop below to become the next number
    //NSLog(@"last sequence number for group %@, name %@ is %d", identifier, name, (int)nextSequenceNumber);
    
    while (1) {
        nextSequenceNumber += 1;
        NSURL *postURL = [self postURLForContainerURL:appGroupURL name:name sequenceNumber:nextSequenceNumber];;
        
        if (![self.fileManager createDirectoryAtURL:postURL.URLByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"unable to create post storage directory %@: %@", postURL.URLByDeletingLastPathComponent.lastPathComponent, error.localizedDescription);
            return NO;
        }
        
        if (![postData writeToURL:postURL options:NSDataWritingAtomic error:&error]) {
            if (error.code == NSFileWriteFileExistsError) {
                continue;
            } else {
                NSLog(@"unable to write post storage file %@: %@", postURL.path.lastPathComponent, error.localizedDescription);
                return NO;
            }
        }
        
        //NSLog(@"post for group %@ written to %@", identifier, postURL.path.lastPathComponent);
        return YES;
    }
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
    
    NSMutableArray *postResults = [NSMutableArray array];
    
    for (NSURL *url in directoryContents) {
        // skip directories
        NSNumber *isDirectoryNum;
        if ([url getResourceValue:&isDirectoryNum forKey:NSURLIsDirectoryKey error:NULL] && isDirectoryNum.boolValue) {
            continue;
        }
        
        // skip posts we've already seen, ie. seq num not > the last one
        NSString *postName;
        NSInteger postSequenceNumber;
        if (![self getFromPostURL:url name:&postName sequenceNumber:&postSequenceNumber]) {
            NSLog(@"unable to parse post name of file %@", url);
            continue;
        }
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
        [postResults addObject:post];
    }
    
    //NSLog(@"%d fresh post files, %d filtered-out filesystem item(s) for group %@", (int)postResults.count, (int)(directoryContents.count - postResults.count), identifier);
    
    // sort by post date
    [postResults sortUsingComparator:^NSComparisonResult(TOAppGroupNotificationPost *post1, TOAppGroupNotificationPost *post2) {
        return [post1.date compare:post2.date];
    }];
    
    return postResults;
}

- (void)cleanupPostsForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL name:(NSString *)name
{
    // !!! TODO
    // should use storedSubscriptionSequenceNumbersForGroupIdentifier:groupURL:names: to find all sequence numbers for this name
    // then delete all posts with an older or equal sequence number
}

- (NSInteger)lastSequenceNumberForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL name:(NSString *)name
{
    NSError *error;
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtURL:appGroupURL includingPropertiesForKeys:@[NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (directoryContents == nil && error.code != NSFileNoSuchFileError && error.code != NSFileReadNoSuchFileError) {
        NSLog(@"unable to scan directory for group %@, %@: %@", identifier, appGroupURL, error.localizedDescription);
        return 0;
        // when error code is NoSuchFileError, code below must work well with directoryContents == nil
    }
    
    NSInteger largestSequenceNumber = 0;
    for (NSURL *url in directoryContents) {
        // skip directories
        NSNumber *isDirectoryNum;
        if ([url getResourceValue:&isDirectoryNum forKey:NSURLIsDirectoryKey error:NULL] && isDirectoryNum.boolValue) {
            continue;
        }
        
        // see if this file is for our name, is its seq num is larger
        NSInteger postSequenceNumber = 0;
        if ([self matchedPostURL:url toName:name gettingSequenceNumber:&postSequenceNumber] && postSequenceNumber > largestSequenceNumber) {
            largestSequenceNumber = postSequenceNumber;
        }
    }
    
    return largestSequenceNumber;
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
    NSURL *sequenceNumbersDirURL = [[appGroupURL URLByAppendingPathComponent:sequenceNumberDirName] URLByAppendingPathComponent:self.appIdentifier];
    NSError *error;
    if (![self.fileManager createDirectoryAtURL:sequenceNumbersDirURL withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"unable to create app sequence number storage directory for group %@, %@: %@", identifier, sequenceNumbersDirURL, error.localizedDescription);
        return;
    }
    
    NSString *sequenceNumberFileName = [name stringByAppendingPathExtension:sequenceNumberFileNameExtension];
    NSURL *sequenceNumberFileURL = [sequenceNumbersDirURL URLByAppendingPathComponent:sequenceNumberFileName];
    
    NSData *fileData = [[self.numberFormatter stringFromNumber:@(sequenceNumber)] dataUsingEncoding:NSUTF8StringEncoding];
    if (![fileData writeToURL:sequenceNumberFileURL options:NSDataWritingAtomic error:&error]) {
        NSLog(@"unable to write sequence number file for group %@, name %@ %@: %@", identifier, name, sequenceNumberFileURL, error.localizedDescription);
        return;
    }
}

- (void)clearStoredSequenceNumberForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL bundleIdentifier:(NSString *)bundleIdentifier name:(NSString *)name
{
    NSURL *sequenceNumbersDirURL = [[appGroupURL URLByAppendingPathComponent:sequenceNumberDirName] URLByAppendingPathComponent:self.appIdentifier];
    
    NSString *sequenceNumberFileName = [name stringByAppendingPathExtension:sequenceNumberFileNameExtension];
    NSURL *sequenceNumberFileURL = [sequenceNumbersDirURL URLByAppendingPathComponent:sequenceNumberFileName];
    
    NSError *error;
    if (![self.fileManager removeItemAtURL:sequenceNumberFileURL error:&error] && error.code != NSFileNoSuchFileError) {
        NSLog(@"unable to delete app sequence number file for group %@, name %@ %@: %@", identifier, name, sequenceNumbersDirURL, error.localizedDescription);
    }
}

- (void)clearStoredSequenceNumbersForGroupIdentifier:(NSString *)identifier groupURL:(NSURL *)appGroupURL bundleIdentifier:(NSString *)bundleIdentifier
{
    NSURL *sequenceNumbersDirURL = [[appGroupURL URLByAppendingPathComponent:sequenceNumberDirName] URLByAppendingPathComponent:self.appIdentifier];
    NSError *error;
    if (![self.fileManager removeItemAtURL:sequenceNumbersDirURL error:&error] && error.code != NSFileNoSuchFileError) {
        NSLog(@"unable to delete app sequence number storage directory for group %@, %@: %@", identifier, sequenceNumbersDirURL, error.localizedDescription);
    }
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
