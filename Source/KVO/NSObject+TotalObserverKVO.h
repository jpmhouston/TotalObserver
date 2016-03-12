//
//  NSObject+TotalObserverKVO.h
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

@interface NSObject (TotalObserverKVO)

// receiver is observer, object parameter is observee, automatically removed at time of observer's dealloc
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;

// same but with operation queue parameter
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

// same but with dispatch queue parameter
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)to_stopObservingForChanges:(id)object toKeyPath:(NSString *)keyPath;
- (BOOL)to_stopObservingForChanges:(id)object toKeyPaths:(NSArray *)keyPaths;

// receiver is observee, no observer, automatically removed at time of receiver's dealloc
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOAnonymousObservationBlock)block;

- (TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;

// same but with operation queue parameter
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

- (TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

// same but with dispatch queue parameter
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)to_stopObservingChangesToKeyPath:(NSString *)keyPath;
- (BOOL)to_stopObservingChangesToKeyPaths:(NSArray *)keyPaths;

- (BOOL)to_stopObservingOwnChangesToKeyPath:(NSString *)keyPath;
- (BOOL)to_stopObservingOwnChangesToKeyPaths:(NSArray *)keyPaths;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
