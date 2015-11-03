//
//  TotalObserverTests.m
//  TotalObserverTests
//
//  Created by Pierre Houston on 10/14/2015.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

@import XCTest;
#import <TotalObserver/TotalObserver.h>
#import "ModelObject.h"

@interface Tests : XCTestCase
@property (nonatomic, strong) ModelObject *modelObject;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, assign) BOOL observed;
@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.modelObject = [[ModelObject alloc] init];
    self.queue = [[NSOperationQueue alloc] init];
    self.observed = NO;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testObjectNotification
{
    typeof(self) __weak welf = self;
    id __block sameobj = nil;
    id __block sameobs = nil;
    TOObservation *observation = [self to_observeForNotifications:self.modelObject named:NameChangedNotification withBlock:^(id obj, TOObservation *obs) {
        welf.observed = YES;
        sameobj = obj;
        sameobs = obs;
    }];
    self.modelObject.name = @""; // should trigger notification, see -[ModelObject setName]
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobj, self);
    XCTAssertEqual(sameobs, observation);
}

- (void)testObjectNotificationOnQueue
{
    typeof(self) __weak welf = self;
    id __block sameobj = nil;
    id __block sameobs = nil;
    id __block samequeue = nil;
    TOObservation *observation = [self to_observeForNotifications:self.modelObject named:NameChangedNotification onQueue:self.queue withBlock:^(id obj, TOObservation *obs) {
        welf.observed = YES;
        sameobj = obj;
        sameobs = obs;
        samequeue = [NSOperationQueue currentQueue];
    }];
    self.modelObject.name = @""; // should trigger notification, see -[ModelObject setName]
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobj, self);
    XCTAssertEqual(sameobs, observation);
    XCTAssertEqual(samequeue, self.queue);
}

- (void)testObjectNotificationWithNoObserver
{
    typeof(self) __weak welf = self;
    id __block sameobs = nil;
    TOObservation *observation = [self.modelObject to_observeNotificationsNamed:NameChangedNotification withBlock:^(TOObservation *obs) {
        welf.observed = YES;
        sameobs = obs;
    }];
    self.modelObject.name = @""; // should trigger notification, see -[ModelObject setName]
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobs, observation);
}

- (void)testObjectNotificationWithNoObserverOnQueue
{
    typeof(self) __weak welf = self;
    id __block sameobs = nil;
    id __block samequeue = nil;
    TOObservation *observation = [self.modelObject to_observeNotificationsNamed:NameChangedNotification onQueue:self.queue withBlock:^(TOObservation *obs) {
        welf.observed = YES;
        sameobs = obs;
        samequeue = [NSOperationQueue currentQueue];
    }];
    self.modelObject.name = @""; // should trigger notification, see -[ModelObject setName]
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobs, observation);
    XCTAssertEqual(samequeue, self.queue);
}

- (void)testAnyNotification
{
    typeof(self) __weak welf = self;
    id __block sameobj = nil;
    id __block sameobs = nil;
    TOObservation *observation = [self to_observeAllNotificationsNamed:NameChangedNotification withBlock:^(id obj, TOObservation *obs) {
        welf.observed = YES;
        sameobj = obj;
        sameobs = obs;
    }];
    self.modelObject.name = @""; // should trigger notification, see -[ModelObject setName]
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobj, self);
    XCTAssertEqual(sameobs, observation);
}

- (void)testAnyNotificationOnQueue
{
    typeof(self) __weak welf = self;
    id __block sameobj = nil;
    id __block sameobs = nil;
    id __block samequeue = nil;
    TOObservation *observation = [self to_observeAllNotificationsNamed:NameChangedNotification onQueue:self.queue withBlock:^(id obj, TOObservation *obs) {
        welf.observed = YES;
        sameobj = obj;
        sameobs = obs;
        samequeue = [NSOperationQueue currentQueue];
    }];
    self.modelObject.name = @""; // should trigger notification, see -[ModelObject setName]
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobj, self);
    XCTAssertEqual(sameobs, observation);
    XCTAssertEqual(samequeue, self.queue);
}


#if 0 // these tests are disabled because addObserver:forKeyPath:.. seems to crash when run in a text case, no workaround found yet
- (void)testKVO
{
    typeof(self) __weak welf = self;
    id __block sameobj = nil;
    id __block sameobs = nil;
    TOObservation *observation = [self to_observeForChanges:self.modelObject toKeyPath:@"flag" withBlock:^(id obj, TOObservation *obs) {
        welf.observed = YES;
        sameobj = obj;
        sameobs = obs;
    }];
    self.modelObject.flag = YES;
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobj, self);
    XCTAssertEqual(sameobs, observation);
}

- (void)testKVOOnQueue
{
    typeof(self) __weak welf = self;
    id __block sameobj = nil;
    id __block sameobs = nil;
    id __block samequeue = nil;
    TOObservation *observation = [self to_observeForChanges:self.modelObject toKeyPath:@"flag" onQueue:self.queue withBlock:^(id obj, TOObservation *obs) {
        welf.observed = YES;
        sameobj = obj;
        sameobs = obs;
        samequeue = [NSOperationQueue currentQueue];
    }];
    self.modelObject.flag = YES;
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobj, self);
    XCTAssertEqual(sameobs, observation);
    XCTAssertEqual(samequeue, self.queue);
}

- (void)testKVOWithNoObserver
{
    typeof(self) __weak welf = self;
    id __block sameobs = nil;
    TOObservation *observation = [self.modelObject to_observeChangesToKeyPath:@"flag" withBlock:^(TOObservation *obs) {
        welf.observed = YES;
        sameobs = obs;
    }];
    self.modelObject.flag = YES;
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobs, observation);
}

- (void)testKVOWithNoObserverOnQueue
{
    typeof(self) __weak welf = self;
    id __block sameobs = nil;
    id __block samequeue = nil;
    TOObservation *observation = [self.modelObject to_observeChangesToKeyPath:@"flag" onQueue:self.queue withBlock:^(TOObservation *obs) {
        welf.observed = YES;
        sameobs = obs;
        samequeue = [NSOperationQueue currentQueue];
    }];
    self.modelObject.flag = YES;
    XCTAssertTrue(self.observed);
    XCTAssertEqual(sameobs, observation);
    XCTAssertEqual(samequeue, self.queue);
}
#endif // disabled because addObserver:forKeyPath:.. seems to crash when run in a text case

@end
