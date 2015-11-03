//
//  ViewController.m
//  TotalObserver
//
//  Created by Pierre Houston on 10/14/2015.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import "ViewController.h"
#import <TotalObserver/TotalObserver.h>
#import <libextobjc/EXTKeyPathCoding.h>

@interface TOObservation (PrivateObservationMethods)
+ (NSMutableDictionary *)sharedObservations;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ViewController __weak *welf = self;
    
    __unused TOObservation *o1 = [self to_observeForChanges:self.modelObject toKeyPath:@keypath(self.modelObject, name) withBlock:^(typeof(self) obj, TOObservation *obs) {
        [obj addLine:@"observed model.name property"];
    }];
    
    __unused TOObservation *o2 = [self to_observeForChanges:self.modelObject toKeyPath:@keypath(self.modelObject, flag) withBlock:^(typeof(self) obj, TOObservation *obs) {
        [obj addLine:@"observed model.flag property (1)"];
    }];
    
    __unused TOObservation *o3 = [self.modelObject to_observeChangesToKeyPath:@keypath(self.modelObject, flag) withBlock:^(TOObservation *obs) {
        [welf addLine:@"observed model.flag property (2)"];
    }];
    
    __unused TOObservation *o4 = [self to_observeForNotifications:self.modelObject named:NameChangedNotification withBlock:^(typeof(self) obj, TOObservation *obs) {
        [obj addLine:@"observed NameChangedNotification (1)"];
    }];
    
    __unused TOObservation *o5 = [self to_observeNotificationsNamed:NameChangedNotification withBlock:^(TOObservation *obs) {
        [welf addLine:@"observed NameChangedNotification (2)"];
    }];
    
    __unused TOObservation *o6 = [self to_observeControlForPress:self.button1 withBlock:^(typeof(self) obj, TOObservation *obs) {
        [obj addLine:@"observed Button 1, setting model.name"];
        obj.modelObject.name = @"x";
    }];
    
    __unused TOObservation *o7 = [self.button2 to_observePressWithBlock:^(TOObservation *obs) {
        [welf addLine:@"observed Button 2, setting model.flag"];
        welf.modelObject.flag = YES;
    }];
    
//    NSLog(@"%@", [TOObservation sharedObservations]);
}

- (void)addLine:(NSString *)string
{
    NSString *lineString = [string stringByAppendingString:@"\n"];
    NSAttributedString *lineAttributedString = [[NSAttributedString alloc] initWithString:lineString];
    [self.textView.textStorage appendAttributedString:lineAttributedString];
    
    NSUInteger length = self.textView.textStorage.length;
    if (length > 1)
        [self.textView scrollRangeToVisible:NSMakeRange(length - 2, 0)];
}

@end
