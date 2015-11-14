//
//  NSObject+TotalObserver.m
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import "NSObject+TotalObserver.h"
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

- (instancetype)initWithObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (instancetype)initWithObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block;
@end

@interface TOKVOObservation ()
@property (nonatomic, readwrite, copy) NSArray *keyPaths;
@property (nonatomic, readwrite) NSKeyValueObservingOptions options;

@property (nonatomic, readwrite) NSString *keyPath;
@property (nonatomic, readwrite) NSDictionary *changeDict;
@property (nonatomic, readwrite) NSUInteger kind;
@property (nonatomic, readwrite, getter=isPrior) BOOL prior;
@property (nonatomic, readwrite, nullable) id changedValue;
@property (nonatomic, readwrite, nullable) id oldValue;
@property (nonatomic, readwrite, nullable) NSIndexSet *indexes;

- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths options:(int)options onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths options:(int)options onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block;
@end

static const int TOKVOObservationContextVar;
static void *TOKVOObservationContext = (void *)&TOKVOObservationContextVar;


#pragma mark -

@implementation NSObject (TotalObserverNotifications)

- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:object name:name onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:object name:name onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:nil name:name onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:nil name:name onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:nil object:self name:name onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:nil object:self name:name onQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingForNotifications:(id)object named:(NSString *)name
{
    return [TONotificationObservation removeForObserver:self object:object name:name];
}

- (BOOL)to_stopObservingForAllNotificationsNamed:(NSString *)name
{
    return [TONotificationObservation removeForObserver:self object:nil name:name];
}

- (BOOL)to_stopObservingNotificationsNamed:(NSString *)name
{
    return [TONotificationObservation removeForObserver:nil object:self name:name];
}

@end


#pragma mark -

@implementation NSObject (TotalObserverKVO)

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObjObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:options onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObjObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:options onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObjObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:0 onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths withBlock:(TOObjObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:0 onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:options onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:options onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:0 onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:0 onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPaths:@[keyPath] options:options onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPaths:keyPaths options:options onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPaths:@[keyPath] options:0 onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPaths:keyPaths options:0 onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPaths:@[keyPath] options:options onQueue:queue withBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPaths:keyPaths options:options onQueue:queue withBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPaths:@[keyPath] options:0 onQueue:queue withBlock:block];
    [observation register];
    return observation;
}

- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPaths:keyPaths options:0 onQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingForChanges:(id)object toKeyPath:(NSString *)keyPath
{
    return [TOKVOObservation removeForObserver:self object:object keyPaths:@[keyPath]];
}

- (BOOL)to_stopObservingForChanges:(id)object toKeyPaths:(NSArray *)keyPaths
{
    return [TOKVOObservation removeForObserver:self object:object keyPaths:keyPaths];
}

- (BOOL)to_stopObservingChangesToKeyPath:(NSString *)keyPath
{
    return [TOKVOObservation removeForObserver:nil object:self keyPaths:@[keyPath]];
}

- (BOOL)to_stopObservingChangesToKeyPaths:(NSArray *)keyPaths
{
    return [TOKVOObservation removeForObserver:nil object:self keyPaths:keyPaths];
}

@end


#pragma mark -

@implementation TONotificationObservation

- (instancetype)initWithObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:object queue:queue block:block]))
        return nil;
    _name = name;
    return self;
}

- (instancetype)initWithObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:object queue:queue objBlock:block]))
        return nil;
    _name = name;
    return self;
}

//- (void)setName:(NSString *)name
//{
//    if (self.registered)
//        [NSException raise:NSGenericException format:@"NSNotificationCenter observation already registered, cannot change 'name' property"];
//
//    self.name = name;
//}

- (void)registerInternal
{
    NSAssert1(!self.registered, @"Attempted double-register of %@", self);
    NSAssert1(self.name != nil, @"Nil 'name' property when registering observation for %@", self);
    typeof(self) __weak welf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:self.name object:self.object queue:self.queue usingBlock:^(NSNotification *notification) {
        welf.notification = notification;
        welf.postedObject = notification.object;
        welf.userInfo = notification.userInfo;
        [welf invoke];
    }];
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
        return [((TONotificationObservation *)observation).name isEqualToString:name];
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


#pragma mark -

@implementation TOKVOObservation

- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths options:(int)options onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:object queue:queue block:block]))
        return nil;
    _keyPaths = keyPaths;
    _options = options;
    return self;
}

- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths options:(int)options onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:object queue:queue objBlock:block]))
        return nil;
    _keyPaths = keyPaths;
    _options = options;
    return self;
}

//- (void)setKeypath:(NSString *)keypath
//{
//    if (self.registered)
//        [NSException raise:NSGenericException format:@"KVO observation already registered, cannot change 'keypath' property"];
//
//    self.keypath = keypath;
//}

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
        if (self.queue)
            [self.queue addOperationWithBlock:^{
                [self invokeWithKeyPath:keyPath changeDict:change];
            }];
        else
            [self invokeWithKeyPath:keyPath changeDict:change];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)invokeWithKeyPath:(NSString *)keyPath changeDict:(NSDictionary *)changeDict
{
    self.keyPath = keyPath;
    self.changeDict = changeDict;
    self.kind = [(NSNumber *)changeDict[NSKeyValueChangeKindKey] unsignedIntegerValue];
    self.prior = [(NSNumber *)changeDict[NSKeyValueChangeNotificationIsPriorKey] unsignedIntegerValue];
    self.changedValue = changeDict[NSKeyValueChangeNewKey];
    self.oldValue = changeDict[NSKeyValueChangeOldKey];
    self.indexes = changeDict[NSKeyValueChangeIndexesKey];
    [self invoke];
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
        return [((TOKVOObservation *)observation).keyPaths isEqualToArray:keyPaths];
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
