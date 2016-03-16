//
//  TOUIControlObservation+Private.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-03-16.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TOUIControlObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface TOUIControlObservation (Private)

- (instancetype)initWithObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOObservationBlock)block;
- (instancetype)initWithControl:(UIControl *)control events:(UIControlEvents)events queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOAnonymousObservationBlock)block;

// TODO: consider making this private too
//+ (BOOL)removeForObserver:(TO_nullable id)observer control:(UIControl *)control events:(UIControlEvents)events;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
