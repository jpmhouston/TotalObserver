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
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface NSObject (TotalObserverKVOShorthand)

- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingForChanges:(id)object toKeyPath:(NSString *)keyPath;

- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingForChanges:(id)object toKeyPaths:(NSArray *)keyPaths;

- (TO_nullable TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (BOOL)stopObservingChangesToKeyPath:(NSString *)keyPath;

- (TO_nullable TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (BOOL)stopObservingChangesToKeyPaths:(NSArray *)keyPaths;

- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingOwnChangesToKeyPath:(NSString *)keyPath;

- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingOwnChangesToKeyPaths:(NSArray *)keyPaths;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
