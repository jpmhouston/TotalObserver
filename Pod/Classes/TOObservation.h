//
//  TOObservation.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//
//

#import <Foundation/Foundation.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@class TOObservation;

typedef void (^TOObservationBlock)(TOObservation *);
typedef void (^TOObjObservationBlock)(id obj, TOObservation *);


@interface TOObservation : NSObject

@property (nonatomic, readonly, weak) id observer;
@property (nonatomic, readonly, weak, nullable) id object; // aka observee

@property (nonatomic, readonly, nullable) NSOperationQueue *queue;

@property (nonatomic, readonly, copy, nullable) TOObservationBlock block; // one of these will be non-null
@property (nonatomic, readonly, copy, nullable) TOObjObservationBlock objectBlock;

@property (nonatomic, readonly) BOOL registered;
@property (nonatomic) BOOL removeAutomatically; // ie. when either observer or observee is dealloc'd, default = YES

- (void)remove;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#define nullable
#endif
