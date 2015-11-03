//
//  NSObject+TotalObserver.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//
//

#import <Foundation/Foundation.h>
#import <TotalObserver/TOObservation.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

// usually don't need to know that TOObservation returned from methods below are either a
// TONotificationObservation or TOKVOObservation, for brevity usually write like:
//   TOObservation *obs = [x to_observeChangesToKeyPath:@"a" withBlock:^(id) {}];
// or just:
//   [x to_observeChangesToKeyPath:@"a" withBlock:^(id) {}]; // and rely on automatic removal

@interface TONotificationObservation : TOObservation
@property (nonatomic, readonly, copy) NSString *name;

@property (nonatomic, readonly) NSNotification *notification;
@property (nonatomic, readonly) NSDictionary *userInfo;

+ (BOOL)removeForObserver:(id)observer object:(nullable id)object name:(NSString *)name;
@end


@interface TOKVOObservation : TOObservation
@property (nonatomic, readonly, copy) NSString *keypath;
@property (nonatomic, readonly) NSKeyValueObservingOptions options;

@property (nonatomic, readonly) NSDictionary *changeDict;
@property (nonatomic, readonly) NSUInteger kind;
@property (nonatomic, readonly, getter=isPrior) BOOL prior;
@property (nonatomic, readonly) id changedValue;
@property (nonatomic, readonly) id oldValue;
@property (nonatomic, readonly) NSIndexSet *indexes;

+ (BOOL)removeForObserver:(id)observer object:(id)object keyPath:(NSString *)keyPath;
@end


@interface NSObject (TotalObserverNotifications)

// receiver is observer, object parameter is observee
- (TONotificationObservation *)to_observeForNotifications:(nullable id)object named:(NSString *)name withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block;

// same but with queue parameter
- (TONotificationObservation *)to_observeForNotifications:(nullable id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

// receiver is observee, no observer specified (not removed automatically, so must call [observer remove] explicitly)
- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;

// same but with queue parameter
- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

@end


@interface NSObject (TotalObserverKVO)

// receiver is observer, object parameter is observee
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObjObservationBlock)block;

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObjObservationBlock)block;

// same but with queue parameter
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

// receiver is observee, no observer specified (so to remove, must call [observer remove])
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;

// same but with queue parameter
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

@end



#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
