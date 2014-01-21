//
//  DIAppDelegate.h
//  mutThreadDemo
//
//  Created by 夏至 on 14-1-21.
//  Copyright (c) 2014年 dooioo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIMainViewController.h"

@interface DIAppDelegate : UIResponder <UIApplicationDelegate>
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DIMainViewController *mainVC;
@end
