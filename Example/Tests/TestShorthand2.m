//
//  TestShorthand2.m
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-07.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

/*
@import XCTest;
@import TotalObserver; // getting "Could not build module 'TotalObserver'" error here :( i hope its only in the Example project
#import "ModelObject.h"

@interface TestShorthand2 : XCTestCase
@end

@implementation TestShorthand2

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [TOObservation setupShorthandMethods];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShorthandMethodsWithModuleImport {
    ModelObject *modelObject = [[ModelObject alloc] init];
    BOOL __block observed = NO;
    [self observeForNotifications:modelObject named:NameChangedNotification withBlock:^(typeof(self) obj, TOObservation *obs) {
        observed = YES;
    }];
    modelObject.name = @""; // should trigger notification, see -[ModelObject setName]
    XCTAssertTrue(observed);
}

@end
*/