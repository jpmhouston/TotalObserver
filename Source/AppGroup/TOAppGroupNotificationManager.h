//
//  TOAppGroupNotificationManager.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//
//  Subscriptions with queued=YES mean the block is called for every posted notification,
//  in correct order, even if posted in rapid succession or while app is inactive,
//  vs NO which only delivers the most recent notification in those instances.
//
//  TODO: rename queued parameter

#import <Foundation/Foundation.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

typedef void (^TOAppGroupSubscriberBlock)(NSString *identifier, NSString *name, id<NSCoding> payload, NSDate *postDate);

@protocol TOAppGroupURLProviding;
@protocol TOAppGroupGlobalNotificationHandling;

@interface TOAppGroupNotificationManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)isValidGroupIdentifier:(NSString *)identifier;

- (void)addGroupIdentifier:(NSString *)identifier;
- (void)removeGroupIdentifier:(NSString *)identifier;

@property (nonatomic, readonly, nullable) NSString *defaultGroupIdentifier; // the last identifier added

- (BOOL)subscribeToNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name queued:(BOOL)queued withBlock:(TOAppGroupSubscriberBlock)block;
- (BOOL)unsubscribeToNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name;

- (BOOL)postNotificationForGroupIdentifier:(NSString *)identifier named:(NSString *)name payload:(TO_nullable id<NSCoding>)payload;

// for dependency injection
// leave set to nil to use defaults: (perhaps name these urlProvider, notificationProvider)
@property (nonatomic, TO_nullable) id<TOAppGroupURLProviding> urlHelper;
@property (nonatomic, TO_nullable) id<TOAppGroupGlobalNotificationHandling> notificationHelper;
@property (nonatomic, TO_nullable) NSString *appIdentifier; // used within callback below, unsubscribe.., remove..
// the notification helper calls this to deliver notification:
- (void)globalNotificationCallbackForGroupIdentifier:(NSString *)identifer;

@end

@protocol TOAppGroupURLProviding
- (NSURL *)groupURLForGroupIdentifier:(NSString *)identifier;
@end

@protocol TOAppGroupGlobalNotificationHandling
- (void)subscribeAppGroupNotificationManager:(TOAppGroupNotificationManager *)manager toGlobalMessagesWithGroupIdentifier:(NSString *)identifier;
- (void)unsubscribeAppGroupNotificationManager:(TOAppGroupNotificationManager *)manager fromGlobalMessagesWithGroupIdentifier:(NSString *)identifier;
- (void)postGlobalMessageWithGroupIdentifier:(NSString *)identifier;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
