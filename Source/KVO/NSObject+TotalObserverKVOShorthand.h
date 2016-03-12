//
//  NSObject+TotalObserverKVOShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOKVOObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#endif

@interface NSObject (TotalObserverKVOShorthand)

- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingForChanges:(id)object toKeyPath:(NSString *)keyPath;
- (BOOL)stopObservingForChanges:(id)object toKeyPaths:(NSArray *)keyPaths;

- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOAnonymousObservationBlock)block;

- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingChangesToKeyPath:(NSString *)keyPath;
- (BOOL)stopObservingChangesToKeyPaths:(NSArray *)keyPaths;

- (BOOL)stopObservingOwnChangesToKeyPath:(NSString *)keyPath;
- (BOOL)stopObservingOwnChangesToKeyPaths:(NSArray *)keyPaths;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
