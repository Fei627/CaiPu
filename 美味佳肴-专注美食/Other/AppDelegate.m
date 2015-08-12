//
//  AppDelegate.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"


//                  ----RootViewController---
#import "OneRootVC.h"
#import "TwoRootVC.h"
#import "ThreeRootVC.h"
#import "FourRootVC.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma mark ***********窗口的配置*************
    
    [NSThread sleepForTimeInterval:2.0f]; // 设置启动页面的持续时间
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
#pragma mark ***********导航控制器*************
    OneRootVC *oneVC = [[OneRootVC alloc] init];
    UINavigationController *oneNavigaC = [[UINavigationController alloc] initWithRootViewController:oneVC];
    [oneNavigaC.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviga"] forBarMetrics:UIBarMetricsDefault];
    oneVC.tabBarItem.image = [UIImage imageNamed:@"caipu"];
    oneVC.tabBarItem.title = @"菜谱";
    
    TwoRootVC *twoVC = [[TwoRootVC alloc] init];
    UINavigationController *twoNavigaC = [[UINavigationController alloc] initWithRootViewController:twoVC];
    [twoNavigaC.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviga"] forBarMetrics:UIBarMetricsDefault];
    twoVC.tabBarItem.image = [UIImage imageNamed:@"jingpin"];
    twoVC.tabBarItem.title = @"精品汇";
    
    ThreeRootVC *threeVC = [[ThreeRootVC alloc] init];
    UINavigationController *threeNavigaC = [[UINavigationController alloc] initWithRootViewController:threeVC];
    [threeNavigaC.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviga"] forBarMetrics:UIBarMetricsDefault];
    threeVC.tabBarItem.image = [UIImage imageNamed:@"tang"];
    threeVC.tabBarItem.title = @"群汤荟萃";
    
    FourRootVC *fourVC = [[FourRootVC alloc] init];
    UINavigationController *fourNavigaC = [[UINavigationController alloc] initWithRootViewController:fourVC];
    [fourNavigaC.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviga"] forBarMetrics:UIBarMetricsDefault];
    fourVC.tabBarItem.image = [UIImage imageNamed:@"wode"];
    fourVC.tabBarItem.title = @"我的";
#pragma mark ***********标签控制器的配置*************
    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    tabBarC.viewControllers = nil;
    tabBarC.viewControllers = @[oneNavigaC,twoNavigaC,threeNavigaC,fourNavigaC];
    tabBarC.tabBar.backgroundImage = [UIImage imageNamed:@"tab"];
#pragma mark ***********主窗口的配置*****************
    self.window.rootViewController = tabBarC;
    
#pragma mark *********** 分享 ***********
    [UMSocialData setAppKey:@"55b0624de0f55ab97a005aa8"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
