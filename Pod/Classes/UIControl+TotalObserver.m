//
//  UIControl+TotalObserver.m
//  Pods
//
//  Created by Pierre Houston on 2015-10-30.
//
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

- (TOObservation *)to_observeControlForPress:(UIControl *)control withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOObservation *)to_observeControlForValue:(UIControl *)control withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:events onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:self control:control events:events onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}

@end


#pragma mark -

@implementation UIControl (TotalObserver)

- (TOObservation *)to_observePressWithBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:UIControlEventTouchUpInside onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:UIControlEventTouchUpInside onQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (TOObservation *)to_observeValueWithBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:UIControlEventValueChanged onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:UIControlEventValueChanged onQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (TOObservation *)to_observeEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:events onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOControlObservation alloc] initWithObserver:nil control:self events:events onQueue:queue withBlock:block];
    [observation register];
    return observation;
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

- (void)removeInternal
{
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.object != nil, @"Nil 'object' property when removing observation for %@", self);
    [(UIControl *)self.object removeTarget:self action:@selector(action:) forControlEvents:self.events];
}

- (NSString *)hashKey
{
    NSAssert1(self.object != nil, @"Nil 'object' property when generating key-hash for %@", self);
    return [[self class] hashKeyForControl:self.object events:self.events];
}

+ (NSString *)hashKeyForControl:(UIControl *)control events:(UIControlEvents)events
{
    return [NSString stringWithFormat:@"C_%@_%uX", NSStringFromClass([control class]), (unsigned)events];
}

+ (BOOL)removeForObserver:(id)observer control:(UIControl *)control events:(UIControlEvents)events
{
    NSString *key = [self hashKeyForControl:control events:events];
    TOObservation *observation = [self observationForHashKey:key withObserver:observer];
    if (observation != nil) {
        [observation remove];
        return YES;
    }
    return NO;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@ %p: obs=%p, obj=%@ %p, e=%ud>", NSStringFromClass([self class]), self, self.observer, NSStringFromClass([self.object class]), self.object, (unsigned int)self.events];
}

@end


#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
