//
//  TestAppGroups.m
//  Example
//
//  Created by Pierre Houston on 2016-03-01.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

@import XCTest;
#import <TotalObserver/TotalObserver.h>
#import <TotalObserver/TOAppGroupNotificationManager.h>

static NSString * const tempFolderName = @"totalobserver-appgroup-test";
static NSString * const appBundleId = @"science.bananameter.totalobserver.test";
static NSString * const appGroupId1 = @"1234567890.totalobservertest.appgroup1";
static NSString * const appGroupId2 = @"2222222222.totalobservertest.appgroup2";

@interface TestAppGroups : XCTestCase <TOAppGroupURLProviding, TOAppGroupGlobalNotificationHandling>
@property (nonatomic) NSURL *tempFolderURL;
@end

@implementation TestAppGroups

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
    // add default app group
    [m addGroupIdentifier:appGroupId1];
}

- (void)tearDown
{
    [[TOAppGroupNotificationManager sharedManager] removeGroupIdentifier:appGroupId1];
    [[NSFileManager defaultManager] removeItemAtURL:self.tempFolderURL error:NULL];
    [super tearDown];
}

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

- (void)testRoundtripObservation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"AppGroup Notification"];
    NSString *notificationName = @"a";
    NSString *payloadString = [self randomPayload];
    
    [[TOAppGroupNotificationManager sharedManager] subscribeToNotificationsForGroupIdentifier:appGroupId1 named:notificationName queued:NO withBlock:^(NSString *identifier, NSString *name, id<NSCoding> payload, NSDate *postDate) {
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
    XCTAssertNil([self clearFolder], @"test will fail since temp directory couldn't be emptied");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"AppGroup Sequence Numbers"];
    NSString *notificationName = @"a";
    NSString *payloadString;
    
    __block NSMutableArray *received = [NSMutableArray array];
    [[TOAppGroupNotificationManager sharedManager] subscribeToNotificationsForGroupIdentifier:appGroupId1 named:notificationName queued:NO withBlock:^(NSString *identifier, NSString *name, id<NSCoding> payload, NSDate *postDate) {
        NSLog(@"received notification %@ / %@", name, payload);
        [received addObject:payload];
        if (received.count < 3) return;
        
        // expect directory to contain: 1234567890.totalobservertest.appgroup1: a|1.post=xxx a|2.post=xxx a|3.post=xxx subscribers: science.bananameter.totalobserver.test: a.seqnum=3
        NSString *actualDirectoryContents = [self directoryContentsForURL:self.tempFolderURL];
        NSString *expectedDirectoryContents = [NSString stringWithFormat:@"%@: %@|1.post=%@ %@|2.post=%@ %@|3.post=%@ subscribers: %@: %@.seqnum=3",
                                               appGroupId1, notificationName, received[0], notificationName, received[1], notificationName, received[2], appBundleId, notificationName];
        NSLog(@"dir contents = %@", actualDirectoryContents);
        XCTAssertEqualObjects(actualDirectoryContents, expectedDirectoryContents);
        
        [expectation fulfill];
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
    XCTAssertNil([self clearFolder], @"test will fail since temp directory couldn't be emptied");
    
    [[TOAppGroupNotificationManager sharedManager] addGroupIdentifier:appGroupId2]; // also setup this app group
    
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
    NSString *actualDirectoryContents = [self directoryContentsForURL:self.tempFolderURL];
    NSString *expectedDirectoryContents = [NSString stringWithFormat:@"%@: %@|1.post=%@ %@|2.post=%@ %@: %@|1.post=%@ %@|1.post=%@",
                                           appGroupId1, notificationName1, payloadString1, notificationName2, payloadString2, appGroupId2, notificationName3, payloadString3, notificationName4, payloadString4];
    NSLog(@"dir contents = %@", actualDirectoryContents);
    XCTAssertEqualObjects(actualDirectoryContents, expectedDirectoryContents);
    
    [[TOAppGroupNotificationManager sharedManager] removeGroupIdentifier:appGroupId2];
}

- (void)testManyApps
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"AppGroup Sequence Numbers"];
    
    struct NameAndCount { char *name; int count; };
    struct MockApp { char *bundleId; int numNotifications; struct NameAndCount notifications[4]; int numObservations; struct NameAndCount observations[4]; }; // our data below ever only uses 2 of the possible 4 spots
    int numMockApps = 3;
    struct MockApp mockApps[] = {
        { (char*)[appBundleId stringByAppendingString:@"X"].UTF8String, 2, {{"a",0}, {"b",0}}, 1, {{"c",0}} },
        { (char*)[appBundleId stringByAppendingString:@"Y"].UTF8String, 1, {{"c",0}},          2, {{"a",0}, {"d",0}} },
        { (char*)[appBundleId stringByAppendingString:@"Z"].UTF8String, 2, {{"d",0}, {"e",0}}, 1, {{"b",0}} }
    };
    int numNames = 5; char *names[] = {"a","b","c","d","e"};
    
    TOAppGroupNotificationManager *m = [TOAppGroupNotificationManager sharedManager];
    __block void (^validate)() = nil;
    
    // subscribe to the posts defined in mockApps[_}.observations
    for (int k = 0; k < numMockApps; ++k) {
        [m addGroupIdentifier:[NSString stringWithCString:mockApps[k].bundleId encoding:NSUTF8StringEncoding]];
        for (int l = 0; l < mockApps[k].numObservations; ++l) {
            NSString *name = [NSString stringWithCString:mockApps[k].observations[l].name encoding:NSUTF8StringEncoding];
            char *shortBundleId = mockApps[k].bundleId + strlen(mockApps[k].bundleId)-1;
            int *pcount = &(mockApps[k].observations[l].count);
            
            NSLog(@"%s observing '%@'", shortBundleId, name);
            [m subscribeToNotificationsForGroupIdentifier:appGroupId1 named:name queued:NO withBlock:^(NSString *identifier, NSString *name, id<NSCoding> payload, NSDate *postDate) {
                //NSLog(@"%@<- %s received '%@'", payload, shortBundleId, name);
                *pcount += 1; // count receipt
                if (validate != nil)
                    validate();
            }];
        }
    }
    
    for (int i = 0; i < numMockApps; ++i)
        for (int j = 0; j < mockApps[i].numNotifications; ++j)
            NSLog(@" %s will post '%s'", mockApps[i].bundleId + strlen(mockApps[i].bundleId)-1, mockApps[i].notifications[j].name);
    
    // make posts to a random one of the names many times, set callbackMockBundleIdentifiers so
    int eventCount = 0, eventMax = 1000;
    NSLog(@"performing %d posts...", eventMax);
    while (++eventCount < eventMax) {
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
        NSString *receiverBundleId = nil;
        for (int k = 0; !receiverShortBundleId && k < numMockApps; ++k)
            for (int l = 0; !receiverShortBundleId && l < mockApps[k].numObservations; ++l)
                if (strcmp(names[r], mockApps[k].observations[l].name) == 0) {
                    receiverShortBundleId = mockApps[k].bundleId + strlen(mockApps[k].bundleId)-1;
                    receiverBundleId = [NSString stringWithCString:mockApps[k].bundleId encoding:NSUTF8StringEncoding];
                }
        if (!receiverShortBundleId) ; //NSLog(@"%@-> %s posting '%@'", payload, senderShortBundleId, name);
        else {
            //NSLog(@"%@-> %s posting '%@' to %s", payload, senderShortBundleId, name, receiverShortBundleId);
            XCTAssertNotNil(receiverBundleId);
            if (receiverBundleId == nil) continue; // would have done wrong thing in postNotification..
            m.appIdentifier = receiverBundleId;
        }
        // can't reference this array except via this global var
        *pcount += 1; // count post
        [m postNotificationForGroupIdentifier:appGroupId1 named:name payload:payload];
    }
    
    static struct MockApp *mockAppsStatic = NULL;
    mockAppsStatic = mockApps;
    
    // after doing all the posts, set validate block for the upcoming final few receive blocks to call (see subscribeToNotifications.. above)
    validate = ^{
        struct MockApp *mockApps = mockAppsStatic; // can't reference this array except via this global^Wstatic var
        BOOL ok = YES;
        for (int i = 0; i < numMockApps; ++i)
            for (int j = 0; j < mockApps[i].numNotifications; ++j) {
                char *namestr = mockApps[i].notifications[j].name;
                
                for (int k = 0; k < numMockApps; ++k)
                    for (int l = 0; l < mockApps[k].numObservations; ++l)
                        if (strcmp(namestr, mockApps[k].observations[l].name) == 0) {
                            char *senderShortBundleId = mockApps[i].bundleId + strlen(mockApps[i].bundleId)-1;
                            char *receiverShortBundleId = mockApps[k].bundleId + strlen(mockApps[k].bundleId)-1;
                            NSLog(@"'%s': %d sent from %s, %d received by %s", namestr, mockApps[i].notifications[j].count, senderShortBundleId, mockApps[k].observations[l].count, receiverShortBundleId);
                            if (mockApps[i].notifications[j].count != mockApps[k].observations[l].count)
                                ok = NO;
                        }
            }
        if (ok)
            [expectation fulfill];
        else
            NSLog(@"all not received yet, still waiting...");
    };
    
    NSTimeInterval timeout = 5.0;
    [self waitForExpectationsWithTimeout:timeout handler:nil];
    
    // total # seconds reported for 1000 posts might be ~= the duration in milliseconds for 1 post .. roughly 14, is that bad?
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

// TOAppGroupURLProviding & TOAppGroupGlobalNotificationHandling protocols

- (NSURL *)groupURLForGroupIdentifier:(NSString *)identifier
{
    return [self.tempFolderURL URLByAppendingPathComponent:identifier];
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
