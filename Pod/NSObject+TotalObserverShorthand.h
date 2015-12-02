//
//  NSObject+TotalObserverShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-06.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

@interface NSObject (TotalObserverNotificationsShorthand)

- (TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name withBlock:(TOObjObservationBlock)block;
- (TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)stopObservingForNotifications:(id)object named:(NSString *)name;
- (BOOL)stopObservingAllNotificationsNamed:(NSString *)name;

- (TONotificationObservation *)observeNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)observeNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)stopObservingNotificationsNamed:(NSString *)name;
- (BOOL)stopObservingOwnNotificationsNamed:(NSString *)name;

@end

@interface NSObject (TotalObserverKVOShorthand)

- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObjObservationBlock)block;

- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)stopObservingForChanges:(id)object toKeyPath:(NSString *)keyPath;
- (BOOL)stopObservingForChanges:(id)object toKeyPaths:(NSArray *)keyPaths;

- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObjObservationBlock)block;

- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOKVOObservation *)observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOKVOObservation *)observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)stopObservingChangesToKeyPath:(NSString *)keyPath;
- (BOOL)stopObservingChangesToKeyPaths:(NSArray *)keyPaths;

- (BOOL)stopObservingOwnChangesToKeyPath:(NSString *)keyPath;
- (BOOL)stopObservingOwnChangesToKeyPaths:(NSArray *)keyPaths;

@end
