//
//  ModelModelObject.m
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-14.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

#import "ModelObject.h"

NSString * const NameChangedNotification = @"NameChanged";

@implementation ModelObject

- (void)setName:(NSString *)newName
{
    _name = newName;
    [[NSNotificationCenter defaultCenter] postNotificationName:NameChangedNotification object:self];
}

@end
