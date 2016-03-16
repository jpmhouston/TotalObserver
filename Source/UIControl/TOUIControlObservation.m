//
//  TOUIControlObservation.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TOUIControlObservation.h"
#import "TOUIControlObservation+Private.h"
#import "TOObservation+Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TOUIControlObservation ()
@property (nonatomic, readwrite) UIControlEvents events;
@property (nonatomic, readwrite) id sender;
@property (nonatomic, readwrite) UIEvent *event;
@end


@implementation TOUIControlObservation

@dynamic control;

- (instancetype)initWithObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOObservationBlock)block;
{
    if (!(self = [super initWithObserver:observer object:control queue:queue gcdQueue:gcdQueue block:block]))
        return nil;
    _events = events;
    return self;
}

- (instancetype)initWithControl:(UIControl *)control events:(UIControlEvents)events queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOAnonymousObservationBlock)block
{
    if (!(self = [super initWithObject:control queue:queue gcdQueue:gcdQueue block:block]))
        return nil;
    _events = events;
    return self;
}

- (UIControl *)control
{
    return (UIControl *)self.object;
}

- (void)registerInternal
{
    NSAssert1(!self.registered, @"Attempted double-register of %@", self);
    NSAssert1(self.object != nil, @"Nil 'object' property when registering observation for %@", self);
    [(UIControl *)self.object addTarget:self action:@selector(action:forEvent:) forControlEvents:self.events];
}

- (void)action:(id)sender forEvent:(UIEvent *)event
{
    //NSAssert3(sender == self.object, @"Action called with sender %@ doesn't match control %@ for %@", sender, self.object, self); -- maybe this happens, and if not, probably can remove the sender property
    [self invokeOnQueueAfter:^{
        self.sender = sender;
        self.event = event;
    }];
}

- (void)deregisterInternal
{
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.object != nil, @"Nil 'object' property when deregistering observation for %@", self);
    [(UIControl *)self.object removeTarget:self action:@selector(action:forEvent:) forControlEvents:self.events];
}

+ (BOOL)removeForObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events
{
    TOObservation *observation = [self findObservationForObserver:observer object:control matchingTest:^BOOL(TOObservation *observation) {
        return [observation isKindOfClass:[TOUIControlObservation class]] && ((TOUIControlObservation *)observation).events == events;
    }];
    if (observation != nil) {
        [observation remove];
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p: obs=%p, obj=%@ %p, e=%ud>", NSStringFromClass([self class]), self, self.observer, NSStringFromClass([self.object class]), self.object, (unsigned int)self.events];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
