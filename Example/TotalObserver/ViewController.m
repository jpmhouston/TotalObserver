//
//  ViewController.m
//  TotalObserver
//
//  Created by Pierre Houston on 10/14/2015.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import "ViewController.h"
#import <libextobjc/EXTKeyPathCoding.h>
#import <TotalObserver/TotalObserverShorthand.h> // or @import TotalObserver;

@interface TOObservation (PrivateObservationMethods)
+ (NSMutableDictionary *)sharedObservations;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ViewController __weak *welf = self;
    
    __unused TOObservation *o1 = [self observeForChanges:self.modelObject toKeyPath:@keypath(self.modelObject, name) withBlock:^(ViewController *obj, TOObservation *obs) {
        [obj addLineToTextView:@"observed model.name property"];
    }];
    
    __unused TOObservation *o2 = [self observeForChanges:self.modelObject toKeyPath:@keypath(self.modelObject, flag) withBlock:^(typeof(self) obj, TOObservation *obs) {
        [obj addLineToTextView:@"observed model.flag property (1)"];
    }];
    
    __unused TOObservation *o3 = [self.modelObject observeChangesToKeyPath:@keypath(self.modelObject, flag) withBlock:^(TOObservation *obs) {
        [welf addLineToTextView:@"observed model.flag property (2)"];
    }];
    
    __unused TOObservation *o4 = [self.modelObject observeChangesToKeyPaths:@[@keypath(self.modelObject, name), @keypath(self.modelObject, flag)] withBlock:^(TOObservation *obs) {
        [welf addLineToTextView:@"observed model.name or flag property"];
    }];
    
    __unused TOObservation *o5 = [self observeForNotifications:self.modelObject named:NameChangedNotification withBlock:^(typeof(self) obj, TOObservation *obs) {
        [obj addLineToTextView:@"observed NameChangedNotification (1)"];
    }];
    
    __unused TOObservation *o6 = [self observeNotificationsNamed:NameChangedNotification withBlock:^(TOObservation *obs) {
        [welf addLineToTextView:@"observed NameChangedNotification (2)"];
    }];
    
    __unused TOObservation *o7 = [self observeControlForPress:self.button1 withBlock:^(typeof(self) obj, TOObservation *obs) {
        [obj addLineToTextView:@"observed Button 1, setting model.name"];
        obj.modelObject.name = @"x";
    }];
    
    __unused TOObservation *o8 = [self.button2 observePressWithBlock:^(TOObservation *obs) {
        [welf addLineToTextView:@"observed Button 2, setting model.flag"];
        welf.modelObject.flag = YES;
    }];
    
//    NSLog(@"%@", [TOObservation sharedObservations]);
}

- (void)addLineToTextView:(NSString *)string
{
    NSString *lineString = [string stringByAppendingString:@"\n"];
    NSAttributedString *lineAttributedString = [[NSAttributedString alloc] initWithString:lineString];
    [self.textView.textStorage appendAttributedString:lineAttributedString];
    
    NSUInteger length = self.textView.textStorage.length;
    if (length > 1)
        [self.textView scrollRangeToVisible:NSMakeRange(length - 2, 0)];
}

@end
