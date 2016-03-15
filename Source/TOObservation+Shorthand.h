//
//  TOObservation+Shorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-04.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import "TOObservation.h"

@interface TOObservation (Shorthand)

/**
 *  Call this method early in your app's lifetime to generate shorthand instance and class category methods
 *  which mirror those with the "to_" prefix.
 *
 *  Its ok to call this multiple times redundantly.
 */
+ (void)setupShorthandMethods;

/**
 *  Whether `setupShorthandMethods` has been called already to generate shorthand instance and class category
 *  methods.
 *
 *  In general, it shouldn't be necessary to use this, as it's not necessary to know whether or not to call
 *  `setupShorthandMethods` - one should just call that redundantly and it will do nothing after the first time.
 *
 *  @return `YES` if `setupShorthandMethods` has been called already.
 */
+ (BOOL)shorthandMethodsAreSetup;

@end
