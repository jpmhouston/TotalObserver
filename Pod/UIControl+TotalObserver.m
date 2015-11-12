//
//  UIControl+TotalObserver.m
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-30.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import "UIControl+TotalObserver.h"
#import "TOObservation-Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TOControlObservation ()
@property (nonatomic, readwrite) UIControlEvents events;

- (instancetype)initWithObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (instancetype)initWithObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block;
@end


#pragma mark -

@implementation NSObject (TotalObserverUIControl)

- (TOControlObservation *)to_observeControlForPress:(UIControl *)control withBlock:(TOObjObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOControlObservation *)to_observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOControlObservation *)to_observeControlForValue:(UIControl *)control withBlock:(TOObjObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOControlObservation *)to_observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObjObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:events onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:events onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingControlForPress:(UIControl *)control
{
    return [TOControlObservation removeForObserver:self control:control events:UIControlEventTouchUpInside];
}

- (BOOL)to_stopObservingControlForValue:(UIControl *)control
{
    return [TOControlObservation removeForObserver:self control:control events:UIControlEventValueChanged];
}

- (BOOL)to_stopObservingControl:(UIControl *)control forEvents:(UIControlEvents)events
{
    return [TOControlObservation removeForObserver:self control:control events:events];
}

@end


#pragma mark -

@implementation UIControl (TotalObserver)

- (TOControlObservation *)to_observePressWithBlock:(TOObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:UIControlEventTouchUpInside onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOControlObservation *)to_observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:UIControlEventTouchUpInside onQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (TOControlObservation *)to_observeValueWithBlock:(TOObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:UIControlEventValueChanged onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOControlObservation *)to_observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:UIControlEventValueChanged onQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (TOControlObservation *)to_observeEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:events onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOControlObservation *)to_observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOControlObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:events onQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingForPress
{
    return [TOControlObservation removeForObserver:nil control:self events:UIControlEventTouchUpInside];
}

- (BOOL)to_stopObservingForValue
{
    return [TOControlObservation removeForObserver:nil control:self events:UIControlEventValueChanged];
}

- (BOOL)to_stopObservingForEvents:(UIControlEvents)events
{
    return [TOControlObservation removeForObserver:nil control:self events:events];
}

@end


#pragma mark -

@implementation TOControlObservation

@dynamic control;

- (instancetype)initWithObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:control queue:queue block:block]))
        return nil;
    _events = events;
    return self;
}

- (instancetype)initWithObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block;
{
    if (!(self = [super initWithObserver:observer object:control queue:queue objBlock:block]))
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
    [(UIControl *)self.object addTarget:self action:@selector(action:) forControlEvents:self.events];
}

- (void)action:(id)sender
{
    NSAssert3(sender == self.object, @"Action called with sender %@ doesn't match control %@ for %@", sender, self.object, self);
    [self invoke];
}

- (void)deregisterInternal
{
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.object != nil, @"Nil 'object' property when deregistering observation for %@", self);
    [(UIControl *)self.object removeTarget:self action:@selector(action:) forControlEvents:self.events];
}

+ (BOOL)removeForObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events
{
    TOObservation *observation = [self findObservationForObserver:observer object:control matchingTest:^BOOL(TOObservation *observation) {
        return ((TOControlObservation *)observation).events == events;
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
