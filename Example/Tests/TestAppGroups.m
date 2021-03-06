//
//  TestAppGroups.m
//  Example
//
//  Created by Pierre Houston on 2016-03-01.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//
//  TODO: test app group observer api, not just the notification manager
//  - hmm, to do that right it would be best to have an app extension

@import XCTest;
#import <TotalObserver/TotalObserver.h>
#import <TotalObserver/TOAppGroupNotificationManager.h>

static NSString * const tempFolderName = @"totalobserver-appgroup-test";
static NSString * const appBundleId = @"science.bananameter.totalobserver.test";
static NSString * const appGroupId1 = @"1234567890.totalobservertest.appgroup1";
static NSString * const appGroupId2 = @"2222222222.totalobservertest.appgroup2";

typedef NSString *(^BundleIdMapperBlock)(NSString *name);

@interface TestAppGroupManager : XCTestCase <TOAppGroupURLProviding, TOAppGroupBundleIdProviding, TOAppGroupGlobalNotificationHandling>
@property (nonatomic) NSURL *tempFolderURL;
@property (nonatomic, copy) BundleIdMapperBlock bundleIdMapper;
@end

@implementation TestAppGroupManager

- (void)setUp
{
    [super setUp];
    self.tempFolderURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tempFolderName]];
    NSLog(@"app group directory: %@", self.tempFolderURL.path);
    // inject override of appgroup manager's default notification delivery & post storage
    TOAppGroupNotificationManager *m = [TOAppGroupNotificationManager sharedManager];
    m.appIdentifier = appBundleId;
    m.urlHelper = self;
    m.notificationHelper = self;
    m.permitPostsWhenNoSubscribers = YES;
    m.cleanupFrequencyRandomFactor = 0; // don't cleanup posts automatically
    [[TOAppGroupNotificationManager sharedManager] addGroupIdentifier:appGroupId1];
    [[TOAppGroupNotificationManager sharedManager] addGroupIdentifier:appGroupId2];
}

- (void)tearDown
{
    [[TOAppGroupNotificationManager sharedManager] removeGroupIdentifier:appGroupId1];
    [[TOAppGroupNotificationManager sharedManager] removeGroupIdentifier:appGroupId2];
    [[NSFileManager defaultManager] removeItemAtURL:self.tempFolderURL error:NULL];
    [super tearDown];
}

// would do these, except that it would just be testing our injected notification delivery, which currently never rejects a group id
//- (void)testSubscribeWithNoGroup
//{
//    BOOL subscribed = [[TOAppGroupNotificationManager sharedManager] subscribeToNotificationsForGroupIdentifier:appGroupId1 named:@"a" withBlock:^(NSString *identifier, NSString *name, id payload, NSDate *postDate) { }];
//    XCTAssertFalse(subscribed);
//}
//
//- (void)testPostWithNoGroup
//{
//    BOOL posted = [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:@"a" payload:[self randomPayload]];
//    XCTAssertFalse(posted);
//}

- (void)testReceivingObservation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"AppGroup Notification"];
    NSString *notificationName = @"a";
    NSString *payloadString = [self randomPayload];
    
    [[TOAppGroupNotificationManager sharedManager] subscribeToNotificationsForGroupIdentifier:appGroupId1 named:notificationName withBlock:^(NSString *identifier, NSString *name, id payload, NSDate *postDate) {
        NSLog(@"received notification %@ / %@", name, payload);
        XCTAssertEqualObjects(payload, payloadString);
        [expectation fulfill];
    }];
    
    NSLog(@"posting notification %@ / %@", notificationName, payloadString);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName payload:payloadString];
    
    NSTimeInterval timeout = 2.0;
    [self waitForExpectationsWithTimeout:timeout handler:nil];
}

- (void)testSequenceNumbers
{
    XCTAssertNil([self clearFolder], @"temp directory couldn't be emptied, test will likely have further spurious assertion failures");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"AppGroup Sequence Numbers"];
    NSString *notificationName = @"a";
    NSString *payloadString;
    
    __block NSMutableArray *received = [NSMutableArray array];
    __weak typeof(self) welf = self;
    [[TOAppGroupNotificationManager sharedManager] subscribeToNotificationsForGroupIdentifier:appGroupId1 named:notificationName withBlock:^(NSString *identifier, NSString *name, id payload, NSDate *postDate) {
        NSLog(@"received notification %@ / %@", name, payload);
        [received addObject:payload];
        if (received.count < 3) return;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // delay enough to let writes to filesystem to finish
            
            // expect directory to contain: 1234567890.totalobservertest.appgroup1: a|1.post=xxx a|2.post=xxx a|3.post=xxx subscribers: science.bananameter.totalobserver.test: a.seqnum=3
            NSString *actualDirectoryContents = [welf directoryContentsForURL:welf.tempFolderURL];
            NSString *expectedDirectoryContents = [NSString stringWithFormat:@"%@: %@|1.post=%@ %@|2.post=%@ %@|3.post=%@ subscribers: %@: %@.seqnum=3",
                                                   appGroupId1, notificationName, received[0], notificationName, received[1], notificationName, received[2], appBundleId, notificationName];
            NSLog(@"dir contents = %@", actualDirectoryContents);
            XCTAssertEqualObjects(actualDirectoryContents, expectedDirectoryContents);
            
            [expectation fulfill];
            
        });
    }];
    
    payloadString = [self randomPayload]; NSLog(@"posting notification %@ / %@", notificationName, payloadString);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName payload:payloadString];
    payloadString = [self randomPayload]; NSLog(@"posting notification %@ / %@", notificationName, payloadString);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName payload:payloadString];
    payloadString = [self randomPayload]; NSLog(@"posting notification %@ / %@", notificationName, payloadString);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName payload:payloadString];
    
    NSTimeInterval timeout = 2.0;
    [self waitForExpectationsWithTimeout:timeout handler:nil];
}

- (void)testPosts
{
    XCTAssertNil([self clearFolder], @"temp directory couldn't be emptied, test will likely have further spurious assertion failures");
    
    NSString *notificationName1 = @"a";
    NSString *notificationName2 = notificationName1;
    NSString *notificationName3 = @"b";
    NSString *notificationName4 = @"c";
    NSString *payloadString1 = [self randomPayload];
    NSString *payloadString2 = [self randomPayload];
    NSString *payloadString3 = [self randomPayload];
    NSString *payloadString4 = [self randomPayload];
    
    NSLog(@"posting notification %@ / %@", notificationName1, payloadString1);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName1 payload:payloadString1];
    NSLog(@"posting notification %@ / %@", notificationName2, payloadString2);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName2 payload:payloadString2];
    NSLog(@"posting notification %@ / %@", notificationName3, payloadString3);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId2 named:notificationName3 payload:payloadString3];
    NSLog(@"posting notification %@ / %@", notificationName4, payloadString4);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId2 named:notificationName4 payload:payloadString4];
    
    // expect directory to contain: 1234567890.totalobservertest.appgroup1: a|1.post=xxx a|2.post=xxx 2222222222.totalobservertest.appgroup2: b|1.post=xxx c|1.post=xxx
    // posts start at 0 instead of 1 when there are no subscribers
    NSString *actualDirectoryContents = [self directoryContentsForURL:self.tempFolderURL];
    NSString *expectedDirectoryContents = [NSString stringWithFormat:@"%@: %@|1.post=%@ %@|2.post=%@ %@: %@|1.post=%@ %@|1.post=%@",
                                           appGroupId1, notificationName1, payloadString1, notificationName2, payloadString2, appGroupId2, notificationName3, payloadString3, notificationName4, payloadString4];
    NSLog(@"dir contents = %@", actualDirectoryContents);
    XCTAssertEqualObjects(actualDirectoryContents, expectedDirectoryContents);
}

- (void)testPostsCleanup
{
    XCTAssertNil([self clearFolder], @"temp directory couldn't be emptied, test will likely have further spurious assertion failures");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"AppGroup Posts Cleanup"];
    NSString *notificationName = @"a";
    NSString *payloadString;
    
    __block NSMutableArray *received = [NSMutableArray array];
    __weak typeof(self) welf = self;
    [[TOAppGroupNotificationManager sharedManager] subscribeToNotificationsForGroupIdentifier:appGroupId1 named:notificationName withBlock:^(NSString *identifier, NSString *name, id payload, NSDate *postDate) {
        NSLog(@"received notification %@ / %@", name, payload);
        [received addObject:payload];
        if (received.count < 3) return;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // after delay to allow file i/o queue to finish the cleanup,
            // expect directory to contain: 1234567890.totalobservertest.appgroup1: subscribers: science.bananameter.totalobserver.test: a.seqnum=3
            NSString *actualDirectoryContents = [welf directoryContentsForURL:welf.tempFolderURL];
            NSString *expectedDirectoryContents = [NSString stringWithFormat:@"%@: %@|3.post=%@ subscribers: %@: %@.seqnum=3", appGroupId1, notificationName, received[2], appBundleId, notificationName];
            NSLog(@"dir contents = %@", actualDirectoryContents);
            XCTAssertEqualObjects(actualDirectoryContents, expectedDirectoryContents);
            
            [expectation fulfill];
        });
    }];
    
    payloadString = [self randomPayload]; NSLog(@"posting notification %@ / %@", notificationName, payloadString);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName payload:payloadString];
    payloadString = [self randomPayload]; NSLog(@"posting notification %@ / %@", notificationName, payloadString);
    [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName payload:payloadString];
    
    // do 3rd post after a delay to ensure the notification block for the 2nd post gets executed first
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TOAppGroupNotificationManager sharedManager].cleanupFrequencyRandomFactor = 1; // force cleanup on every post
        
        NSString *lastPayloadString = [self randomPayload];
        NSLog(@"posting notification %@ / %@ and forcing cleanup of old post files", notificationName, lastPayloadString);
        [[TOAppGroupNotificationManager sharedManager] postNotificationForGroupIdentifier:appGroupId1 named:notificationName payload:lastPayloadString];
    });
    
    NSTimeInterval timeout = 4.0;
    [self waitForExpectationsWithTimeout:timeout handler:nil];
}

- (void)testMultipleApps
{
    XCTAssertNil([self clearFolder], @"temp directory couldn't be emptied, test will likely have further spurious assertion failures");
    
    [self doTestManyAppsWithCount:50 usingCleanup:NO];
}

- (void)testMultipleAppsWithCleanup
{
    XCTAssertNil([self clearFolder], @"temp directory couldn't be emptied, test will likely have further spurious assertion failures");
    
    [self doTestManyAppsWithCount:50 usingCleanup:YES];
}

- (void)testManyPostsByMultipleApps
{
    XCTAssertNil([self clearFolder], @"temp directory couldn't be emptied, test will likely have further spurious assertion failures");
    
    [self doTestManyAppsWithCount:1000 usingCleanup:NO];
}

- (void)testReliableObserver
{
    XCTAssertNil([self clearFolder], @"temp directory couldn't be emptied, test will likely have further spurious assertion failures");
    
    TOAppGroupNotificationManager *m = [TOAppGroupNotificationManager sharedManager];
    
    NSString *observerId = @"R";
    NSString *observeName = @"e"; // known to be the otherwise unobserved notification name posted by helper method doTestManyAppsWithCount:usingCleanup:
    
    m.bundleIdHelper = self;
    m.appIdentifier = nil; // force use of bundleIdHelper, our protocol methods will call the following block:
    self.bundleIdMapper = ^(NSString *name) {
        if ([name isEqualToString:observeName])
            return [appBundleId stringByAppendingString:observerId];
        NSLog(@"subscription name \"%@\" not found in our mockApps struct, can't map to bundle id for this test", name);
        return appBundleId;
    };
    
    // observe a few posts and then stop
    NSLog(@"A observing '%@'", observeName);
    
    int haltCount = 3;
    __block int count = 0;
    __block NSString *lastReceviedPayload = nil;
    [m subscribeToReliableNotificationsForGroupIdentifier:appGroupId1 named:observeName withBlock:^(NSString *identifier, NSString *name, NSArray *postDatesAndPayloads) {
        for (NSArray *post in postDatesAndPayloads) NSLog(@"%@<- %@ received '%@'", post.lastObject, observerId, name);
        
        if ((count += postDatesAndPayloads.count) >= haltCount) { // count receipt until a certain number received
            NSLog(@"%@ stopping observation after receiving '%@'", observerId, ((NSArray *)postDatesAndPayloads.lastObject).lastObject);
            
            [m unsubscribeFromReliableNotificationsForGroupIdentifier:appGroupId1 named:observeName allowingReliableResumption:YES];
            lastReceviedPayload = ((NSArray *)postDatesAndPayloads.lastObject).lastObject;
        }
    }];
    
    // perform posts
    NSArray *postLog = [self doTestManyAppsWithCount:200 usingCleanup:YES];
    
    XCTAssertNotNil(lastReceviedPayload, @"not enough posts named '%@'", observeName);
    if (!lastReceviedPayload) return;
    
    // find which payload should be received once we resume observing
    NSString *nextExpectedPayload = nil;
    BOOL found = NO; // found lastReceviedPayload
    for (NSArray *loggedPost in postLog) {
        if (!found && [loggedPost.lastObject isEqualToString:lastReceviedPayload]) found = YES;
        else if (found && [loggedPost.firstObject isEqualToString:observeName]) {
            nextExpectedPayload = loggedPost.lastObject;
            break;
        }
    }
    XCTAssert(found, @"unable to find last received post %@ in the returned log array", lastReceviedPayload);
    XCTAssertNotNil(nextExpectedPayload, @"not enough posts named '%@' (needed 1 more)", observeName);
    if (!nextExpectedPayload) return;
    NSLog(@"expect %@ to receive '%@' next", observerId, nextExpectedPayload);
    
    // resume observing
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"AppGroup Reliable Observer Resumed"]];
    
    [m subscribeToReliableNotificationsForGroupIdentifier:appGroupId1 named:observeName withBlock:^(NSString *identifier, NSString *name, NSArray *postDatesAndPayloads) {
        NSArray *firstPost = postDatesAndPayloads.firstObject;
        NSArray *lastPost = postDatesAndPayloads.lastObject;
        if (postDatesAndPayloads.count > 0) NSLog(@"%@<- %@ received '%@'", firstPost.lastObject, observerId, name);
        if (postDatesAndPayloads.count > 2) NSLog(@"... (%d more)", (int)postDatesAndPayloads.count - 2);
        if (postDatesAndPayloads.count > 1) NSLog(@"%@<- %@ received '%@'", lastPost.lastObject, observerId, name);
        
        [m unsubscribeFromReliableNotificationsForGroupIdentifier:appGroupId1 named:observeName allowingReliableResumption:YES];
        
        XCTAssert([firstPost.lastObject isEqualToString:nextExpectedPayload], @"first receveived in re-observation is %@, expected %@", firstPost.lastObject, nextExpectedPayload);
        [expectation fulfill];
    }];
    
    NSTimeInterval timeout = 1.0;
    [self waitForExpectationsWithTimeout:timeout handler:nil];
}

- (NSArray *)doTestManyAppsWithCount:(int)numEvents usingCleanup:(BOOL)cleanupOn
{
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"AppGroup Many Apps Posting & Receiving%s", cleanupOn?" With Cleanup":""]];
    
    struct NameAndCount { char *name; int count; };
    struct MockApp { char *bundleId; int numNotifications; struct NameAndCount notifications[4]; int numObservations; struct NameAndCount observations[4]; }; // our data below ever only uses 2 of the possible 4 spots
    int numMockApps = 3;
    struct MockApp mockApps[] = {
        { (char*)[appBundleId stringByAppendingString:@"X"].UTF8String, 2, {{"a",0}, {"b",0}}, 1, {{"c",0}} },
        { (char*)[appBundleId stringByAppendingString:@"Y"].UTF8String, 1, {{"c",0}},          2, {{"a",0}, {"d",0}} },
        { (char*)[appBundleId stringByAppendingString:@"Z"].UTF8String, 2, {{"d",0}, {"e",0}}, 1, {{"b",0}} }
        //                                              ^ bundle-id           ^ notifies             ^ observes
    };
    int numNames = 5; char *names[] = {"a","b","c","d","e"};
    
    static struct MockApp *mockAppsStatic = NULL;
    mockAppsStatic = mockApps; // the blocks below can't access 'mockApps' struct, can access 'mockAppsStatic' however
    
    TOAppGroupNotificationManager *m = [TOAppGroupNotificationManager sharedManager];
    if (cleanupOn) m.permitPostsWhenNoSubscribers = YES; // if cleaning up, don't leave behind all the unobserved 'e' posts, OR...
    if (cleanupOn) m.cleanupFrequencyRandomFactor = 8;
    
    // make the TOAppGroupNotificationManager call back to map subscription names to bundle id's
    m.bundleIdHelper = self;
    m.appIdentifier = nil; // force use of bundleIdHelper, our protocol methods will call the following block:
    __block BundleIdMapperBlock previousMapper = self.bundleIdMapper;
    self.bundleIdMapper = ^(NSString *name) {
        struct MockApp *mockApps = mockAppsStatic; // can't reference this array except via this global^Wstatic var
        for (int k = 0; k < numMockApps; ++k)
            for (int l = 0; l < mockApps[k].numObservations; ++l)
                if ([[NSString stringWithCString:mockApps[k].observations[l].name encoding:NSUTF8StringEncoding] isEqualToString:name])
                    return [NSString stringWithCString:mockApps[k].bundleId encoding:NSUTF8StringEncoding];;
        if (previousMapper) return previousMapper(name);
        NSLog(@"subscription name \"%@\" not found in our mockApps struct, can't map to bundle id for this test", name);
        return appBundleId;
    };
    
    // subscribe to the posts defined in mockApps[].observations
    // call the validate block on each observe - unless its nil, and it will be nil until all the test notifications are posted
    // then it will be set to a block that checks that all notifications posted have been received
    __block void (^validate)() = nil;
    
    for (int k = 0; k < numMockApps; ++k) {
        [m addGroupIdentifier:[NSString stringWithCString:mockApps[k].bundleId encoding:NSUTF8StringEncoding]];
        for (int l = 0; l < mockApps[k].numObservations; ++l) {
            NSString *name = [NSString stringWithCString:mockApps[k].observations[l].name encoding:NSUTF8StringEncoding];
            int *pcount = &(mockApps[k].observations[l].count);
            
            char *subscriberShortBundleId = mockApps[k].bundleId + strlen(mockApps[k].bundleId)-1;
            NSLog(@"%s observing '%@'", subscriberShortBundleId, name);
            
            [m subscribeToNotificationsForGroupIdentifier:appGroupId1 named:name withBlock:^(NSString *identifier, NSString *name, id payload, NSDate *postDate) {
//                NSLog(@"%@<- %s received '%@'", payload, subscriberShortBundleId, name);
                *pcount += 1; // count receipt
                if (validate != nil)
                    validate();
            }];
        }
    }
    
    for (int i = 0; i < numMockApps; ++i)
        for (int j = 0; j < mockApps[i].numNotifications; ++j)
            NSLog(@" %s will post '%s'", mockApps[i].bundleId + strlen(mockApps[i].bundleId)-1, mockApps[i].notifications[j].name);
    
    NSMutableArray *postLog = [NSMutableArray array];
    
    // make posts to a random one of the names many times, set callbackMockBundleIdentifiers so
    NSLog(@"sending %d posts...", numEvents);
    
    for (int eventCount = 0; eventCount < numEvents; ++eventCount) {
        int r = arc4random_uniform(numNames);
        NSString *name = [NSString stringWithCString:names[r] encoding:NSUTF8StringEncoding];
        NSString *payload = [NSString stringWithFormat:@"%d", eventCount];
        
        // find sender for sake of incrementing its count
        char *senderShortBundleId = NULL;
        int *pcount = NULL;
        for (int i = 0; !senderShortBundleId && i < numMockApps; ++i)
            for (int j = 0; !senderShortBundleId && j < mockApps[i].numNotifications; ++j)
                if (strcmp(names[r], mockApps[i].notifications[j].name) == 0) {
                    senderShortBundleId = mockApps[i].bundleId + strlen(mockApps[i].bundleId)-1;
                    pcount = &(mockApps[i].notifications[j].count);
                }
        XCTAssert(senderShortBundleId != NULL);
        XCTAssert(pcount != NULL, @"notification struct for '%s' not found", names[r]); // are strings in 'names' out of sync with structs in 'mockApps'?
        if (pcount == NULL) continue; // would have crashed below
        
        // find receiver to make manager obj pose as its bundle id
        char *receiverShortBundleId = NULL;
        for (int k = 0; !receiverShortBundleId && k < numMockApps; ++k)
            for (int l = 0; !receiverShortBundleId && l < mockApps[k].numObservations; ++l)
                if (strcmp(names[r], mockApps[k].observations[l].name) == 0) {
                    receiverShortBundleId = mockApps[k].bundleId + strlen(mockApps[k].bundleId)-1;
                }
//        if (!receiverShortBundleId) NSLog(@"%@-> %s posting '%@'", payload, senderShortBundleId, name);
//        else NSLog(@"%@-> %s posting '%@' to %s", payload, senderShortBundleId, name, receiverShortBundleId);
        *pcount += 1; // count post
        [m postNotificationForGroupIdentifier:appGroupId1 named:name payload:payload];
        
        [postLog addObject:@[name, payload]];
        
        if (eventCount == numEvents / 2 || (numEvents > 50 && (eventCount == 3 * numEvents / 4 || eventCount == numEvents / 4)) || (numEvents > 80 && eventCount == numEvents - 10))
            NSLog(@"%d posts remaining to send", numEvents - eventCount);
    }
    
    NSLog(@"all sent");
    
    // see if we've got them all already
    int undelivered = 0;
    for (int i = 0; i < numMockApps; ++i)
        for (int j = 0; j < mockApps[i].numNotifications; ++j)
            for (int k = 0; k < numMockApps; ++k)
                for (int l = 0; l < mockApps[k].numObservations; ++l)
                    if (strcmp(mockApps[i].notifications[j].name, mockApps[k].observations[l].name) == 0)
                        if (mockApps[i].notifications[j].count > mockApps[k].observations[l].count)
                            undelivered += mockApps[i].notifications[j].count - mockApps[k].observations[l].count;
    // all delivered is what we want to have happen, earlier versions weren't so good though and we needed the validate block to count the stragglers
    // when there's a validate block defined, its called in every subscription block (see subscribeToNotifications.. above)
    if (undelivered == 0) {
        NSLog(@"all received without waiting!");
        [expectation fulfill];
    } else
        validate = ^{
            struct MockApp *mockApps = mockAppsStatic; // can't reference this array except via this global^Wstatic var
            static int skiplogging = 0;
            int undelivered = 0;
            for (int i = 0; i < numMockApps; ++i)
                for (int j = 0; j < mockApps[i].numNotifications; ++j)
                    for (int k = 0; k < numMockApps; ++k)
                        for (int l = 0; l < mockApps[k].numObservations; ++l)
                            if (strcmp(mockApps[i].notifications[j].name, mockApps[k].observations[l].name) == 0)
                                if (mockApps[i].notifications[j].count > mockApps[k].observations[l].count)
                                    undelivered += mockApps[i].notifications[j].count - mockApps[k].observations[l].count;
            if (undelivered == 0) {
                NSLog(@"all received");
                [expectation fulfill];
            }
            else if (skiplogging > 0)
                --skiplogging;
            else {
                NSLog(@"%d posts still not received yet:", undelivered);
                for (int i = 0; i < numMockApps; ++i)
                    for (int j = 0; j < mockApps[i].numNotifications; ++j)
                        for (int k = 0; k < numMockApps; ++k)
                            for (int l = 0; l < mockApps[k].numObservations; ++l)
                                if (strcmp(mockApps[i].notifications[j].name, mockApps[k].observations[l].name) == 0) {
                                    char *senderShortBundleId = mockApps[i].bundleId + strlen(mockApps[i].bundleId)-1;
                                    char *receiverShortBundleId = mockApps[k].bundleId + strlen(mockApps[k].bundleId)-1;
                                    NSLog(@"'%s': %d sent from %s, %d received by %s", mockApps[i].notifications[j].name, mockApps[i].notifications[j].count, senderShortBundleId, mockApps[k].observations[l].count, receiverShortBundleId);
                                }
                if (undelivered > 200) skiplogging = (undelivered - 1) / 8;
                else if (undelivered > 25) skiplogging = (undelivered - 1) / 2;
                else skiplogging = undelivered - 2;
            }
        };
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    // total # seconds reported for 1000 posts might be ~= the duration in milliseconds for 1 post .. roughly 14, is that bad?
    
    // if had some stragglers before waiting, check again
    if (undelivered > 0) {
        undelivered = 0;
        for (int i = 0; i < numMockApps; ++i)
            for (int j = 0; j < mockApps[i].numNotifications; ++j)
                for (int k = 0; k < numMockApps; ++k)
                    for (int l = 0; l < mockApps[k].numObservations; ++l)
                        if (strcmp(mockApps[i].notifications[j].name, mockApps[k].observations[l].name) == 0)
                            if (mockApps[i].notifications[j].count > mockApps[k].observations[l].count)
                                undelivered += mockApps[i].notifications[j].count - mockApps[k].observations[l].count;
        if (undelivered > 0) NSLog(@"after timeout, %d posts still not received:", undelivered);
    }
    for (int i = 0; i < numMockApps; ++i)
        for (int j = 0; j < mockApps[i].numNotifications; ++j)
            for (int k = 0; k < numMockApps; ++k)
                for (int l = 0; l < mockApps[k].numObservations; ++l)
                    if (strcmp(mockApps[i].notifications[j].name, mockApps[k].observations[l].name) == 0) {
                        char *senderShortBundleId = mockApps[i].bundleId + strlen(mockApps[i].bundleId)-1;
                        char *receiverShortBundleId = mockApps[k].bundleId + strlen(mockApps[k].bundleId)-1;
                        NSLog(@"'%s': %d sent from %s, %d received by %s", mockApps[i].notifications[j].name, mockApps[i].notifications[j].count, senderShortBundleId, mockApps[k].observations[l].count, receiverShortBundleId);
                    }
    
    NSLog(@"dir contents (cleanup %s) = %@", cleanupOn?"ON":"OFF", [self directoryContentsForURL:self.tempFolderURL]);
    
    // unsubscribe to prevent calls to any of the subscription blocks being called between this method exiting and tearDown called
    for (int k = 0; k < numMockApps; ++k)
        for (int l = 0; l < mockApps[k].numObservations; ++l) {
            NSString *name = [NSString stringWithCString:mockApps[k].observations[l].name encoding:NSUTF8StringEncoding];
            [m unsubscribeFromNotificationsForGroupIdentifier:appGroupId1 named:name];
        }
    
    if (previousMapper) {
        self.bundleIdMapper = previousMapper;
    } else {
        self.bundleIdMapper = nil;
        m.bundleIdHelper = nil;
        m.appIdentifier = appBundleId;
    }
    
    return postLog;
}

#pragma mark -

- (NSString *)randomPayload
{
    return [NSString stringWithFormat:@"%c%c%c", 'a'+arc4random_uniform(26), 'a'+arc4random_uniform(26), 'a'+arc4random_uniform(26)];
}

- (NSString *)clearFolder
{
    if ([self directoryContentsForURL:self.tempFolderURL].length > 0)
        for (NSURL *leftoverURL in [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.tempFolderURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
            [[NSFileManager defaultManager] removeItemAtURL:leftoverURL error:NULL];
        };
    NSString *str = [self directoryContentsForURL:self.tempFolderURL];
    return str.length > 0 ? str : nil;
}

- (NSString *)directoryContentsForURL:(NSURL *)url
{
    NSMutableString *s = [NSMutableString string];
    // with directory enumerator:
    for (NSURL *fileURL in [[NSFileManager defaultManager] enumeratorAtURL:url includingPropertiesForKeys:@[NSURLNameKey,NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil]) {
        NSString *name; if (![fileURL getResourceValue:&name forKey:NSURLNameKey error:nil]) continue;
        NSNumber *isDirectory; if (![fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil]) continue;
        if (s.length > 0) [s appendString:@" "];
        if (!isDirectory.boolValue) [s appendFormat:@"%@=%@", name, [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfURL:fileURL] options:0 format:NULL error:NULL]];
        else [s appendFormat:@"%@:", name];
    }
    // or recursive:
//    for (NSURL *fileURL in [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[NSURLNameKey,NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
//        NSString *name; if (![fileURL getResourceValue:&name forKey:NSURLNameKey error:nil]) continue;
//        NSNumber *isDirectory; if (![fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil]) continue;
//        if (s.length > 0) [s appendString:@" "];
//        if (!isDirectory.boolValue) [s appendFormat:@"%@=%@", name, [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfURL:fileURL] options:0 format:NULL error:NULL]];
//        else [s appendFormat:@"%@: %@", name, [self recursiveDirectoryContentsForURL:fileURL]]; // or delimit with "%@:{ %@ }", can't do that when using directory enumerator
//    }
    return s;
}

- (NSString *)recursiveDirectoryContentsForURL:(NSURL *)url
{
    NSMutableString *s = [NSMutableString string];
    for (NSURL *fileURL in [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[NSURLNameKey,NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
        NSString *name; if (![fileURL getResourceValue:&name forKey:NSURLNameKey error:nil]) continue;
        NSNumber *isDirectory; if (![fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil]) continue;
        if (s.length > 0) [s appendString:@" "];
        if (isDirectory.boolValue) [s appendFormat:@"%@:{ %@ }", name, [self recursiveDirectoryContentsForURL:fileURL]];
        else [s appendFormat:@"%@=%@", name, [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfURL:fileURL] options:0 format:NULL error:NULL]];
    }
    return s;
}

// TOAppGroupURLProviding, TOAppGroupBundleIdProviding, TOAppGroupGlobalNotificationHandling protocols

- (NSURL *)groupURLForGroupIdentifier:(NSString *)identifier
{
    return [self.tempFolderURL URLByAppendingPathComponent:identifier];
}

- (NSString *)bundleIdForSubscribingToGroupIdentifier:(NSString *)identifier name:(NSString *)name
{
    return self.bundleIdMapper ? self.bundleIdMapper(name) : appBundleId;
}

- (NSString *)bundleIdForUnsubscribingFromGroupIdentifier:(NSString *)identifier name:(NSString *)name
{
    return self.bundleIdMapper ? self.bundleIdMapper(name) : appBundleId;
}

- (NSString *)bundleIdForReceivingPostWithGroupIdentifier:(NSString *)identifier name:(NSString *)name
{
    return self.bundleIdMapper ? self.bundleIdMapper(name) : appBundleId;
}

- (NSString *)bundleIdForRemovingGroupIdentifier:(NSString *)identifier
{
    return appBundleId; // can't call self.bundleIdMapper since no name, don't expect this to be called
}

- (void)subscribeAppGroupNotificationManager:(TOAppGroupNotificationManager *)manager toGlobalMessagesWithGroupIdentifier:(NSString *)identifier
{
    [self to_observeAllNotificationsNamed:identifier withBlock:^(id obj, TOObservation *obs) {
        [manager globalNotificationCallbackForGroupIdentifier:identifier];
    }];
}

- (void)unsubscribeAppGroupNotificationManager:(TOAppGroupNotificationManager *)manager fromGlobalMessagesWithGroupIdentifier:(NSString *)identifier
{
    [self to_stopObservingAllNotificationsNamed:identifier];
}

- (void)postGlobalMessageWithGroupIdentifier:(NSString *)identifier
{
    [self to_postNotificationNamed:identifier];
}

@end
