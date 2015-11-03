//
//  ModelObject.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-14.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const NameChangedNotification;

@interface ModelObject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL flag;

@end
