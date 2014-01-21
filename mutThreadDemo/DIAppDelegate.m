//
//  DIAppDelegate.m
//  mutThreadDemo
//
//  Created by 夏至 on 14-1-21.
//  Copyright (c) 2014年 dooioo. All rights reserved.
//

#import "DIAppDelegate.h"

@implementation DIAppDelegate

@synthesize mainVC,backgroundUpdateTask,worldStr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    worldStr = @"hello world";
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.mainVC = [[DIMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self beingBackgroundUpdateTask];
    // 在这里加上你需要长久运行的代码

    NSLog(@"后台线程运行");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"后台线程运行");
        for (long i = 0; i < 1000000000; i++) {
            NSLog(@"后台计算-->>%ld",i);
        }
    });
    
    [self endBackgroundUpdateTask];
}

- (void)beingBackgroundUpdateTask
{
    NSLog(@"beingBackgroundUpdateTask");
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    NSLog(@"endBackgroundUpdateTask");
//    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
//    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
