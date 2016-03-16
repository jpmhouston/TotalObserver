//
//  TONotificationObservation.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TONotificationObservation.h"
#import "TONotificationObservation+Private.h"
#import "TOObservation+Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TONotificationObservation ()
@property (nonatomic, readwrite, copy) NSString *name;

@property (nonatomic, readwrite) NSNotification *notification;
@property (nonatomic, readwrite, nullable) id postedObject;
@property (nonatomic, readwrite, nullable) NSDictionary *userInfo;
@end


@implementation TONotificationObservation

- (instancetype)initWithObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOObservationBlock)block;
{
    if (!(self = [super initWithObserver:observer object:object queue:queue gcdQueue:gcdQueue block:block]))
        return nil;
    _name = name;
    return self;
}

- (instancetype)initWithObject:(nullable id)object name:(NSString *)name queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOAnonymousObservationBlock)block;
{
    if (!(self = [super initWithObject:object queue:queue gcdQueue:gcdQueue block:block]))
        return nil;
    _name = name;
    return self;
}

- (void)registerInternal
{
    NSAssert1(!self.registered, @"Attempted double-register of %@", self);
    NSAssert1(self.name != nil, @"Nil 'name' property when registering observation for %@", self);
    typeof(self) __weak welf = self;
    if (self.queue != nil) {
        [[NSNotificationCenter defaultCenter] addObserverForName:self.name object:self.object queue:self.queue usingBlock:^(NSNotification *notification) {
            welf.notification = notification;
            welf.postedObject = notification.object;
            welf.userInfo = notification.userInfo;
            [welf invoke];
        }];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserverForName:self.name object:self.object queue:nil usingBlock:^(NSNotification *notification) {
            [welf invokeOnQueueAfter:^{
                welf.notification = notification;
                welf.postedObject = notification.object;
                welf.userInfo = notification.userInfo;
            }];
        }];
    }
}

- (void)deregisterInternal
{
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.name != nil, @"Nil 'name' property when deregistering observation for %@", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.name object:self.object];
}

+ (BOOL)removeForObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name
{
    NSParameterAssert(observer != nil || object != nil);
    TOObservation *observation = [self findObservationForObserver:observer object:object matchingTest:^BOOL(TOObservation *observation) {
        return [observation isKindOfClass:[TONotificationObservation class]] && [((TONotificationObservation *)observation).name isEqualToString:name];
    }];
    if (observation != nil) {
        [observation remove];
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p: obs=%p, obj=%@ %p, n=%@>", NSStringFromClass([self class]), self, self.observer, NSStringFromClass([self.object class]), self.object, self.name];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
