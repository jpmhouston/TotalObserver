//
//  TOAppGroupNotificationManager.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//
//  Reliable subscriptions mean the block is called with array of every posted notification,
//  in correct order, even if posted in rapid succession or while app is inactive.
//  Otherwise only delivers the most recent notification in those instances.
//
//  TODO: maybe change payload back to id<NSCoding> and use that instead of Plist encoding
//  TODO: move testing injection properties etc to a private-ish header

#import <Foundation/Foundation.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

typedef void (^TOAppGroupSubscriberBlock)(NSString *identifier, NSString *name, id payload, NSDate *postDate);
typedef void (^TOAppGroupReliableSubscriberBlock)(NSString *identifier, NSString *name, NSArray *postDatesAndPayloads);

@interface TOAppGroupNotificationManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)isValidGroupIdentifier:(NSString *)identifier;

- (void)addGroupIdentifier:(NSString *)identifier;
- (void)removeGroupIdentifier:(NSString *)identifier;

@property (nonatomic, readonly, nullable) NSString *defaultGroupIdentifier; // the last identifier added

- (BOOL)subscribeToNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name withBlock:(TOAppGroupSubscriberBlock)block;
- (BOOL)unsubscribeFromNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name;

- (BOOL)subscribeToReliableNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name withBlock:(TOAppGroupReliableSubscriberBlock)block;
- (BOOL)unsubscribeFromReliableNotificationsForGroupIdentifier:(NSString *)identifier named:(NSString *)name allowingReliableResumption:(BOOL)retainState;

- (BOOL)postNotificationForGroupIdentifier:(NSString *)identifier named:(NSString *)name payload:(TO_nullable id)payload;

@end

// these could go in a ..+Testing.h header, but this whole header is private anyway:

@protocol TOAppGroupURLProviding;
@protocol TOAppGroupGlobalNotificationHandling;
@protocol TOAppGroupBundleIdProviding;

@interface TOAppGroupNotificationManager (DependencyInjectionForTesting)
// leave helpers set to nil to keep default behavior  !!! perhaps rename urlProvider, notificationProvider
@property (nonatomic, TO_nullable) id<TOAppGroupURLProviding> urlHelper;
@property (nonatomic, TO_nullable) id<TOAppGroupGlobalNotificationHandling> notificationHelper;
@property (nonatomic, TO_nullable) id<TOAppGroupBundleIdProviding> bundleIdHelper; // not used if appIdentifier != nil
@property (nonatomic, TO_nullable) NSString *appIdentifier;   // main bundle's id, if override to nil, must also set bundleIdHelper
@property (nonatomic) BOOL permitPostsWhenNoSubscribers;      // default = NO
@property (nonatomic) u_int32_t cleanupFrequencyRandomFactor; // 0=don't cleanup, 1=on every post, larger means less frequent
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

// note that TOAppGroupNotificationManager doesn't implement this protocol, test code can choose to provide
@protocol TOAppGroupBundleIdProviding
- (NSString *)bundleIdForSubscribingToGroupIdentifier:(NSString *)identifier name:(NSString *)name;
- (NSString *)bundleIdForUnsubscribingFromGroupIdentifier:(NSString *)identifier name:(NSString *)name;
- (NSString *)bundleIdForRemovingGroupIdentifier:(NSString *)identifier;
- (NSString *)bundleIdForReceivingPostWithGroupIdentifier:(NSString *)identifier name:(NSString *)name;;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
