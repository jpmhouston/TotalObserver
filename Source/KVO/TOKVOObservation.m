//
//  TOKVOObservation.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TOKVOObservation.h"
#import "TOKVOObservation+Private.h"
#import "TOObservation+Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TOKVOObservation ()
@property (nonatomic, readwrite) NSArray *keyPaths;
@property (nonatomic, readwrite) NSKeyValueObservingOptions options;

@property (nonatomic, readwrite, copy) NSString *keyPath;
@property (nonatomic, readwrite) NSDictionary *changeDict;
@property (nonatomic, readwrite) NSUInteger kind;
@property (nonatomic, readwrite, getter=isPrior) BOOL prior;
@property (nonatomic, readwrite, nullable) id changedValue;
@property (nonatomic, readwrite, nullable) id oldValue;
@property (nonatomic, readwrite, nullable) NSIndexSet *indexes;
@end

static const int TOKVOObservationContextVar;
static void *TOKVOObservationContext = (void *)&TOKVOObservationContextVar;


@implementation TOKVOObservation

- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths options:(int)options queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:object queue:queue gcdQueue:gcdQueue block:block]))
        return nil;
    _keyPaths = keyPaths;
    _options = options;
    return self;
}

- (instancetype)initWithObject:(id)object keyPaths:(NSArray *)keyPaths options:(int)options queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOAnonymousObservationBlock)block
{
    if (!(self = [super initWithObject:object queue:queue gcdQueue:gcdQueue block:block]))
        return nil;
    _keyPaths = keyPaths;
    _options = options;
    return self;
}

- (void)registerInternal
{
    NSAssert1(!self.registered, @"Attempted double-register of %@", self);
    NSAssert1(self.keyPaths != nil, @"Nil 'keyPaths' property when registering observation for %@", self);
    NSAssert1(self.keyPaths.count > 0, @"Empty 'keyPaths' property when registering observation for %@", self);
    for (NSString *keyPath in self.keyPaths) {
        [self.object addObserver:self forKeyPath:keyPath options:self.options context:TOKVOObservationContext];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context
{
    if (context == TOKVOObservationContext) {
        NSAssert2([self.keyPaths containsObject:keyPath], @"Invoked with unexpected keypath '%@' %@", keyPath, self);
        [self invokeOnQueueAfter:^{
            self.keyPath = keyPath;
            self.changeDict = change;
            self.kind = [(NSNumber *)change[NSKeyValueChangeKindKey] unsignedIntegerValue];
            self.prior = [(NSNumber *)change[NSKeyValueChangeNotificationIsPriorKey] unsignedIntegerValue];
            self.changedValue = change[NSKeyValueChangeNewKey];
            self.oldValue = change[NSKeyValueChangeOldKey];
            self.indexes = change[NSKeyValueChangeIndexesKey];
        }];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)deregisterInternal
{
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.keyPaths != nil, @"Nil 'keyPaths' property when deregistering observation for %@", self);
    NSAssert1(self.keyPaths.count > 0, @"Empty 'keyPaths' property when deregistering observation for %@", self);
    for (NSString *keyPath in self.keyPaths) {
        [self.object removeObserver:self forKeyPath:keyPath context:NULL];
    }
}

+ (BOOL)removeForObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths
{
    TOObservation *observation = [self findObservationForObserver:observer object:object matchingTest:^BOOL(TOObservation *observation) {
        return [observation isKindOfClass:[TOKVOObservation class]] && [((TOKVOObservation *)observation).keyPaths isEqualToArray:keyPaths];
    }];
    if (observation != nil) {
        [observation remove];
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p: obs=%p, obj=%@ %p, kp=%@>", NSStringFromClass([self class]), self,
            self.observer, NSStringFromClass([self.object class]), self.object, [self.keyPaths componentsJoinedByString:@","]];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
