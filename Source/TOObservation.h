//
//  TOObservation.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@class TOObservation;

typedef void (^TOObservationBlock)(TOObservation *);
typedef void (^TOObjObservationBlock)(id obj, TOObservation *);


@interface TOObservation : NSObject

@property (nonatomic, readonly, weak) id observer;
@property (nonatomic, readonly, weak, TO_nullable) id object; // aka observee

@property (nonatomic, readonly, TO_nullable) NSOperationQueue *queue;
@property (nonatomic, readonly, TO_nullable) dispatch_queue_t gcdQueue;

@property (nonatomic, readonly, copy, TO_nullable) TOObservationBlock block; // one of these will be non-null
@property (nonatomic, readonly, copy, TO_nullable) TOObjObservationBlock objectBlock;

@property (nonatomic, readonly) BOOL registered;
@property (nonatomic) BOOL removeAutomatically; // ie. when either observer or observee is dealloc'd, default = YES

- (void)remove;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
