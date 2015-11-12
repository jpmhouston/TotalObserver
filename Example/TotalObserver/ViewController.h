//
//  ViewController.h
//  TotalObserver
//
//  Created by Pierre Houston on 10/14/2015.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import "ModelObject.h"

@import UIKit;

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet ModelObject *modelObject;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;

- (void)addLineToTextView:(NSString *)string;

@end
