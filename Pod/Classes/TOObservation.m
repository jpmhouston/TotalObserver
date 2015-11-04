//
//  TOObservation.m
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//
//

#import "TOObservation.h"
#import "TOObservation-Private.h"
#import "NSObject+TotalObserver.h"
#import <objc/runtime.h>
#import <objc/message.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif


@interface TOObservation ()
@property (nonatomic, readwrite, weak, nullable) id observer;
@property (nonatomic, readwrite, weak, nullable) id object; // some overlap of term 'object' in here, consider naming this 'observee'

@property (nonatomic, readwrite, nullable) NSOperationQueue *queue;

@property (nonatomic, readwrite, copy, nullable) TOObservationBlock block; // code enforces one of these will be nonnull
@property (nonatomic, readwrite, copy, nullable) TOObjObservationBlock objectBlock;

@property (nonatomic, readwrite) BOOL registered;
@end

static const int TOObservationSetKeyVar;
static void *TOObservationSetKey = (void *)&TOObservationSetKeyVar;

static NSMutableSet *classesSwizzledSet;


#pragma mark -

@implementation TOObservation

- (instancetype)init
{
    self = [super init];
    [NSException raise:NSInternalInconsistencyException format:@"TOObservation base class must not be initialized"];
    self = nil;
    return nil;
}

- (instancetype)initWithObserver:(nullable id)observer object:(id)object queue:(nullable NSOperationQueue *)queue block:(TOObservationBlock)block
{
    if (!(self = [super init]))
        return nil;
    _observer = observer;
    _object = object;
    _queue = queue;
    _block = block;
    _removeAutomatically = YES;
    return self;
}

- (instancetype)initWithObserver:(nullable id)observer object:(id)object queue:(nullable NSOperationQueue *)queue objBlock:(TOObjObservationBlock)block
{
    if (!(self = [super init]))
        return nil;
    _observer = observer;
    _object = object;
    _queue = queue;
    _objectBlock = block;
    _removeAutomatically = YES;
    return self;
}

- (void)register
{
    if (self.registered)
        [NSException raise:NSGenericException format:@"Observation already registered, cannot register again"];
    
    [self registerInternal];
    [self storeAssociatedObservation];
    [self adoptAutomaticRemoval];
    self.registered = YES;
}

- (void)remove
{
    if (!self.registered)
        return;
    
    [self deregisterInternal];
    [self removeAssociatedObservation];
    self.registered = NO;
}

- (void)invoke
{
    if (self.block)
        self.block(self);
    else if (self.objectBlock)
        self.objectBlock(self.observer, self);
    else
        [NSException raise:NSInternalInconsistencyException format:@"Nil 'block' & 'objectBlock' properties when invoking observation %@", self];
}

- (void)registerInternal
{
    [NSException raise:NSInternalInconsistencyException format:@"TOObservation registerInternal should not be called"];
}

- (void)deregisterInternal
{
    [NSException raise:NSInternalInconsistencyException format:@"TOObservation registerInternal should not be called"];
}

- (NSString *)hashKey
{
    [NSException raise:NSInternalInconsistencyException format:@"TOObservation hashKey should not be called"];
    return nil;
}


#pragma mark -

- (void)storeAssociatedObservation
{
    NSAssert1(self.observer != nil || self.object != nil, @"Nil 'observer' & 'object' properties when storing observation %@", self);
    // store into *both* observer & observee, although that may not be obvious
    // of course we want to remove the observation if the observer goes away, but also if the observee does too
    //
    if (self.observer != nil)
        [[self class] storeAssociatedObservation:self intoObject:self.observer];
    if (self.object != nil)
        [[self class] storeAssociatedObservation:self intoObject:self.object];
}

- (void)removeAssociatedObservation
{
    NSAssert1(self.observer != nil || self.object != nil, @"Nil 'observer' & 'object' properties when removing observation %@", self);
    if (self.observer != nil)
        [[self class] removeAssociatedObservation:self fromObject:self.observer];
    if (self.object != nil)
        [[self class] removeAssociatedObservation:self fromObject:self.object];
}

+ (void)storeAssociatedObservation:(TOObservation *)observation intoObject:(id)associationTarget
{
    NSMutableSet *observationSet = nil;
    @synchronized(associationTarget) {
        
        observationSet = objc_getAssociatedObject(associationTarget, &TOObservationSetKey);
        if (observationSet == nil) {
            observationSet = [NSMutableSet set];
            objc_setAssociatedObject(associationTarget, &TOObservationSetKey, observationSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
    }
    @synchronized(observationSet) {
        
        [observationSet addObject:observation];
        
    }
}

+ (void)removeAssociatedObservation:(TOObservation *)observation fromObject:(id)associationTarget
{
    NSMutableSet *observationSet = nil;
    @synchronized(associationTarget) {
        
        observationSet = objc_getAssociatedObject(associationTarget, &TOObservationSetKey);
        
    }
    if (observationSet != nil) {
        @synchronized(observationSet) {
            
            [observationSet removeObject:observation];
            // don't bother removing the set when its empty, would have to use another @synchronized(associationTarget) block
            
        }
    }
}

+ (NSSet *)associatedObservationsForObserver:(id)observer
{
    return [self associatedObservationsForObject:observer];
}

+ (NSSet *)associatedObservationsForObservee:(id)object
{
    return [self associatedObservationsForObject:object];
}

+ (NSSet *)associatedObservationsForObserver:(nullable id)observer object:(nullable id)object
{
    NSParameterAssert(observer != nil || object != nil);
    return [self associatedObservationsForObject:observer != nil ? observer : object]; // observer if its not nil, otherwise object
}

+ (NSSet *)associatedObservationsForObject:(id)associationTarget
{
    NSMutableSet *observationSet = nil;
    @synchronized(associationTarget) {
        
        observationSet = objc_getAssociatedObject(associationTarget, &TOObservationSetKey);
        
    }
    if (observationSet != nil) {
        @synchronized(observationSet) {
            
            observationSet = [observationSet copy];
            
        }
    }
    return observationSet;
}

+ (TOObservation *)findObservationForObserver:(nullable id)observer object:(nullable id)object matchingTest:(BOOL(^)(TOObservation *observation))testBlock
{
    TOObservation *foundObservation = nil;
    NSSet *observationSet = [self associatedObservationsForObserver:observer object:object];
    
    for (TOObservation *observation in observationSet) {
        // note, self here is class of subclass whose class method called this superclass class method
        // eg. if TONotificationObservation class method called this, then self is TONotificationObservation instead of TOObservation
        if ([observation isKindOfClass:self] && observer == observation.observer && object == observation.object && testBlock(observation)) {
            foundObservation = observation;
            break;
        }
    }
    return foundObservation;
}


#pragma mark -

- (void)adoptAutomaticRemoval
{
    NSAssert1(self.observer != nil || self.object != nil, @"Nil 'observer' & 'object' properties when adopting auto-removal for observation %@", self);
    if (self.observer != nil)
        [[self class] swizzleDeallocIfNeededForClass:[self.observer class]];
    if (self.object != nil)
        [[self class] swizzleDeallocIfNeededForClass:[self.object class]];
}

+ (void)swizzleDeallocIfNeededForClass:(Class)class
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classesSwizzledSet = [NSMutableSet set];
    });
    
    // taken directly from _swizzleObjectClassIfNeeded in https://github.com/mikeash/MAKVONotificationCenter/blob/master/MAKVONotificationCenter.m
    
    @synchronized(classesSwizzledSet) {
        
        if (![classesSwizzledSet containsObject:class]) {
            // here be dragons
            SEL deallocSel = NSSelectorFromString(@"dealloc");
            Method dealloc = class_getInstanceMethod(class, deallocSel);
            IMP origImpl = method_getImplementation(dealloc);
            IMP newImpl = imp_implementationWithBlock(^(void *obj) { // MAKVONotificationCenter casts its block to (__bridge void *), but that's giving error here :(
                @autoreleasepool {
                    [TOObservation performAutomaticRemovalForObject:(__bridge id)obj];
                }
                ((void (*)(void *, SEL))origImpl)(obj, deallocSel);
            });
            
            class_replaceMethod(class, deallocSel, newImpl, method_getTypeEncoding(dealloc));
            
            [classesSwizzledSet addObject:class];
        }
        
    }
}

+ (void)performAutomaticRemovalForObject:(id)objectBeingDeallocated
{
    NSSet *observationSet = [self associatedObservationsForObject:objectBeingDeallocated]; // observations both by the object & on the object
    for (TOObservation *observation in observationSet) {
        if (observation.removeAutomatically)
            [observation remove];
    }
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
