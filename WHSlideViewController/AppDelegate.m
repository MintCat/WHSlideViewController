//
//  AppDelegate.m
//  WHSlideViewController
//
//  Created by ios on 2017/3/3.
//  Copyright © 2017年 c. All rights reserved.
//

#import "AppDelegate.h"
#import "CenterViewController.h"
#import "LeftViewController.h"
#import "WHSlideViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    CenterViewController *centerVC = [[CenterViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:centerVC];
    nav.tabBarItem.title = @"first";
    
    SecondViewController *secondVC = [[SecondViewController alloc]init];
    UINavigationController *secondNav = [[UINavigationController alloc]initWithRootViewController:secondVC];
    secondNav.tabBarItem.title = @"second";
    
    ThirdViewController *thirdVC = [[ThirdViewController alloc]init];
    UINavigationController *thirdNav = [[UINavigationController alloc]initWithRootViewController:thirdVC];
    thirdNav.tabBarItem.title = @"third";
    
    UITabBarController *tabbarVC = [[UITabBarController alloc]init];
    tabbarVC.view.backgroundColor = [UIColor whiteColor];//防止返回时导航栏出现阴影
    [tabbarVC addChildViewController:nav];
    [tabbarVC addChildViewController:secondNav];
    [tabbarVC addChildViewController:thirdNav];

    
#if 0
    CenterViewController *vc = [[CenterViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
#endif
    
    LeftViewController *leftVC   = [[LeftViewController alloc]init];
    
    WHSlideViewController *mainVC = [WHSlideViewController shareManager];
    mainVC.leftVC = leftVC;
    mainVC.centerVC = tabbarVC;
    //mainVC.isCanSlide = NO;
    
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
