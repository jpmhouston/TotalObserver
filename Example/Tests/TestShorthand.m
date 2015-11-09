//
//  TestShorthand.m
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-07.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

@import XCTest;
#import <TotalObserver/TotalObserverShorthand.h>
#import "ModelObject.h"

@interface TestShorthand : XCTestCase
@end

@implementation TestShorthand

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [TOObservation setupShorthandMethods];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShorthandMethods {
    ModelObject *modelObject = [[ModelObject alloc] init];
    BOOL __block observed = NO;
    [self observeForNotifications:modelObject named:NameChangedNotification withBlock:^(typeof(self) obj, TOObservation *obs) {
        observed = YES;
    }];
    modelObject.name = @""; // should trigger notification, see -[ModelObject setName]
    XCTAssertTrue(observed);
}

@end
