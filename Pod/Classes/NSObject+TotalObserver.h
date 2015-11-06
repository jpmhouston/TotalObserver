//
//  NSObject+TotalObserver.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOObservation.h"

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
@property (nonatomic, readonly, nullable) id postedObject;
@property (nonatomic, readonly, nullable) NSDictionary *userInfo;

// can use this class method to match a prior observation and remove it, although usually more convenient to
// use the 'stopObserving' methods below, or save the observation object and call 'remove' on it
// don't call with both observer & object nil
+ (BOOL)removeForObserver:(nullable id)observer object:(nullable id)object name:(NSString *)name;
@end


@interface TOKVOObservation : TOObservation
@property (nonatomic, readonly, copy) NSString *keypath;
@property (nonatomic, readonly) NSKeyValueObservingOptions options;

@property (nonatomic, readonly) NSString *keyPath;
@property (nonatomic, readonly) NSDictionary *changeDict;
@property (nonatomic, readonly) NSUInteger kind;
@property (nonatomic, readonly, getter=isPrior) BOOL prior;
@property (nonatomic, readonly, nullable) id changedValue;
@property (nonatomic, readonly, nullable) id oldValue;
@property (nonatomic, readonly, nullable) NSIndexSet *indexes;

// can use this class method to match a prior observation and remove it, although usually more convenient to
// use the 'stopObserving' methods below, or save the observation object and call 'remove' on it
+ (BOOL)removeForObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths;
@end


@interface NSObject (TotalObserverNotifications)

// receiver is observer, object parameter is observee, automatically removed at time of observer's dealloc
- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name withBlock:(TOObjObservationBlock)block;
- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block;

// same but with queue parameter
- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)to_stopObservingForNotifications:(id)object named:(NSString *)name;
- (BOOL)to_stopObservingForAllNotificationsNamed:(NSString *)name;

// receiver is observee, no observer, automatically removed at time of receiver's dealloc
- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;

// same but with queue parameter
- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (BOOL)to_stopObservingNotificationsNamed:(NSString *)name;

@end


@interface NSObject (TotalObserverKVO)

// receiver is observer, object parameter is observee, automatically removed at time of observer's dealloc
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObjObservationBlock)block;

// same but with queue parameter
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)to_stopObservingForChanges:(id)object toKeyPath:(NSString *)keyPath;
- (BOOL)to_stopObservingForChanges:(id)object toKeyPaths:(NSArray *)keyPaths;

// receiver is observee, no observer, automatically removed at time of receiver's dealloc
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;

// same but with queue parameter
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (BOOL)to_stopObservingChangesToKeyPath:(NSString *)keyPath;
- (BOOL)to_stopObservingChangesToKeyPaths:(NSArray *)keyPaths;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
