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

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

static NSMutableDictionary *sharedObservationDict;


@interface TOObservation ()
@property (nonatomic, readwrite, weak, nullable) id observer;
@property (nonatomic, readwrite, weak, nullable) id object;

@property (nonatomic, readwrite, nullable) NSOperationQueue *queue;

@property (nonatomic, readwrite, copy, nullable) TOObservationBlock block; // code enforces one of these will be nonnull
@property (nonatomic, readwrite, copy, nullable) TOObjObservationBlock objectBlock;

@property (nonatomic, readwrite) BOOL registered;
@end


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
    return self;
}

- (void)register
{
    if (self.registered)
        [NSException raise:NSGenericException format:@"Observation already registered, cannot register again"];
    
    [self registerInternal];
    [[self class] keepObservation:self];
    self.registered = YES;
}

- (void)remove
{
    if (!self.registered)
        return;
    
    [self removeInternal];
    [[self class] discardObservation:self];
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

- (void)removeInternal
{
    [NSException raise:NSInternalInconsistencyException format:@"TOObservation registerInternal should not be called"];
}

- (NSString *)hashKey
{
    [NSException raise:NSInternalInconsistencyException format:@"TOObservation hashKey should not be called"];
    return nil;
}

#pragma mark -

+ (NSMutableDictionary *)sharedObservations
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObservationDict = [NSMutableDictionary dictionary];
    });
    return sharedObservationDict;
}

+ (nullable TOObservation *)observationForHashKey:(NSString *)key withObserver:(id)observer
{
    NSMutableDictionary *observations = [self sharedObservations];
    
    NSMutableSet *observationsMatchingHash = [observations objectForKey:key];
    TOObservation *foundObservation = nil;
    if (observationsMatchingHash != nil) {
        @synchronized(observationsMatchingHash) {
            for (TOObservation *observation in observationsMatchingHash) {
                if (observation.observer == observer) {
                    foundObservation = observation;
                    break;
                }
            }
        }
        // is there any reason to do this to avoid iterating within the @synchronized block?
        // making the copy is O(n) anyway so it seems pointless
//        NSSet *observationsSet;
//        @synchronized(observationsMatchingHash) {
//            observationsSet = [observationsMatchingHash copy];
//        }
//        for (TOObservation *observation in observationsSet) {
//            if (observation.observer == observer) {
//                foundObservation = observation;
//                break;
//            }
//        }
    }
    return foundObservation;
}

+ (void)keepObservation:(TOObservation *)observation
{
    NSString *key = [observation hashKey];
    NSMutableDictionary *observations = [self sharedObservations];
    
    NSMutableSet *observationsMatchingHash = [observations objectForKey:key];
    if (observationsMatchingHash == nil) {
        @synchronized(observations) {
            observationsMatchingHash = [observations objectForKey:key];
            if (observationsMatchingHash == nil) {
                observationsMatchingHash = [NSMutableSet set];
                [observations setObject:observationsMatchingHash forKey:key];
            }
        }
    }
    @synchronized(observationsMatchingHash) {
        [observationsMatchingHash addObject:observation];
    }
}

+ (void)discardObservation:(TOObservation *)observation
{
    NSString *key = [observation hashKey];
    NSMutableDictionary *observations = [self sharedObservations];
    
    NSMutableSet *observationsMatchingHash = [observations objectForKey:key];
    if (observationsMatchingHash != nil) {
        @synchronized(observationsMatchingHash) {
            [observationsMatchingHash removeObject:observation];
        }
    }
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
