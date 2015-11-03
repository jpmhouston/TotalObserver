//
//  NSObject+TotalObserver.m
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//
//

#import "NSObject+TotalObserver.h"
#import "TOObservation-Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TONotificationObservation ()
@property (nonatomic, readwrite, copy) NSString *name;

@property (nonatomic, readwrite) NSNotification *notification;
@property (nonatomic, readwrite) NSDictionary *userInfo;

- (instancetype)initWithObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (instancetype)initWithObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block;
@end

@interface TOKVOObservation ()
@property (nonatomic, readwrite, copy) NSString *keypath;
@property (nonatomic, readwrite) NSKeyValueObservingOptions options;

@property (nonatomic, readwrite) NSDictionary *changeDict;
@property (nonatomic, readwrite) NSUInteger kind;
@property (nonatomic, readwrite, getter=isPrior) BOOL prior;
@property (nonatomic, readwrite) id changedValue;
@property (nonatomic, readwrite) id oldValue;
@property (nonatomic, readwrite) NSIndexSet *indexes;

- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPath:(NSString *)keyPath options:(int)options onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPath:(NSString *)keyPath options:(int)options onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block;
@end

static const int TOKVOObservationContextVar;
static void *TOKVOObservationContext = (void *)&TOKVOObservationContextVar;


#pragma mark -

@implementation NSObject (TotalObserverNotifications)

- (TOObservation *)to_observeForNotifications:(nullable id)object named:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:object name:name onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeForNotifications:(nullable id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:object name:name onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOObservation *)to_observeAllNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:nil name:name onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:nil name:name onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOObservation *)to_observeNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TONotificationObservation alloc] initWithObserver:nil object:self name:name onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TONotificationObservation alloc] initWithObserver:nil object:self name:name onQueue:queue withBlock:block];
    [observation register];
    return observation;
}

@end


#pragma mark -

@implementation NSObject (TotalObserverKVO)

- (TOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPath:keyPath options:options onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPath:keyPath options:0 onQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPath:keyPath options:options onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}
- (TOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPath:keyPath options:0 onQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPath:keyPath options:options onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPath:keyPath options:0 onQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPath:keyPath options:options onQueue:queue withBlock:block];
    [observation register];
    return observation;
}

- (TOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOObservation *observation = [[TOKVOObservation alloc] initWithObserver:nil object:self keyPath:keyPath options:0 onQueue:queue withBlock:block];
    [observation register];
    return observation;
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
    [[NSNotificationCenter defaultCenter] addObserverForName:self.name object:self.object queue:self.queue usingBlock:^(NSNotification *notification) {
        self.notification = notification;
        self.userInfo = notification.userInfo;
        [self invoke];
    }];
}

- (void)removeInternal
{
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.name != nil, @"Nil 'name' property when removing observation for %@", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.name object:self.object];
}

- (NSString *)hashKey
{
    NSAssert1(self.name != nil, @"Nil 'name' property when generating key-hash for %@", self);
    return [[self class] hashKeyForObject:self.object name:self.name];
}

+ (NSString *)hashKeyForObject:(nullable id)object name:(NSString *)name
{
    return [NSString stringWithFormat:@"N_%@_%@", object ? NSStringFromClass([object class]) : @"any", name];
}

+ (BOOL)removeForObserver:(id)observer object:(nullable id)object name:(NSString *)name
{
    NSString *key = [self hashKeyForObject:object name:name];
    TOObservation *observation = [self observationForHashKey:key withObserver:observer];
    if (observation != nil) {
        [observation remove];
        return YES;
    }
    return NO;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@ %p: obs=%p, obj=%@ %p, n=%@>", NSStringFromClass([self class]), self, self.observer, NSStringFromClass([self.object class]), self.object, self.name];
}

@end


#pragma mark -

@implementation TOKVOObservation

- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPath:(NSString *)keyPath options:(int)options onQueue:(nullable NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:object queue:queue block:block]))
        return nil;
    _keypath = keyPath;
    _options = options;
    return self;
}

- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPath:(NSString *)keyPath options:(int)options onQueue:(nullable NSOperationQueue *)queue withObjBlock:(TOObjObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:object queue:queue objBlock:block]))
        return nil;
    _keypath = keyPath;
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
    NSAssert1(self.keypath != nil, @"Nil 'keypath' property when registering observation for %@", self);
    [self.object addObserver:self forKeyPath:self.keypath options:self.options context:TOKVOObservationContext];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString *,id> *)change context:(nullable void *)context
{
    if (context == TOKVOObservationContext) {
        NSAssert2([keyPath isEqualToString:self.keypath], @"Invoked with unexpected keypath '%@' %@", keyPath, self);
        if (self.queue)
            [self.queue addOperationWithBlock:^{
                [self invokeWithChangeDict:change];
            }];
        else
            [self invokeWithChangeDict:change];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)invokeWithChangeDict:(NSDictionary *)changeDict
{
    self.changeDict = changeDict;
    self.kind = [(NSNumber *)changeDict[NSKeyValueChangeKindKey] unsignedIntegerValue];
    self.prior = [(NSNumber *)changeDict[NSKeyValueChangeNotificationIsPriorKey] unsignedIntegerValue];
    self.changedValue = changeDict[NSKeyValueChangeNewKey];
    self.oldValue = changeDict[NSKeyValueChangeOldKey];
    self.indexes = changeDict[NSKeyValueChangeIndexesKey];
    [self invoke];
}

- (void)removeInternal
{
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.keypath != nil, @"Nil 'keypath' property when removing observation for %@", self);
    [self.object removeObserver:self forKeyPath:self.keypath context:NULL];
}

- (NSString *)hashKey
{
    NSAssert1(self.object != nil, @"Nil 'object' property when generating key-hash for %@", self);
    NSAssert1(self.keypath != nil, @"Nil 'keypath' property when generating key-hash for %@", self);
    return [[self class] hashKeyForObject:self.object keypath:self.keypath];
}

+ (NSString *)hashKeyForObject:(id)object keypath:(NSString *)keypath
{
    return [NSString stringWithFormat:@"K_%@_%@", NSStringFromClass([object class]), keypath];
}

+ (BOOL)removeForObserver:(id)observer object:(id)object keyPath:(NSString *)keypath
{
    NSString *key = [self hashKeyForObject:object keypath:keypath];
    TOObservation *observation = [self observationForHashKey:key withObserver:observer];
    if (observation != nil) {
        [observation remove];
        return YES;
    }
    return NO;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@ %p: obs=%p, obj=%@ %p, kp=%@>", NSStringFromClass([self class]), self, self.observer, NSStringFromClass([self.object class]), self.object, self.keypath];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
