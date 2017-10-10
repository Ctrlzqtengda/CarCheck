//
//  AppDelegate.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "BaseTabBarViewController.h"

#import "ZQMyViewController.h"
#import "ZQCarServerViewController.h"
#import "ZQCarProcessViewController.h"

#import "ZQLoginViewController.h"
@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSUInteger sTabBarIndex;
@end

@implementation AppDelegate

//tttttttest
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
//    BaseTabBarViewController *tabBarVC = [[BaseTabBarViewController alloc] init];
    self.window.rootViewController = [self setupViews];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BaseTabBarViewController *)setupViews {
    
     BaseTabBarViewController *tabBarVC = [[BaseTabBarViewController alloc] init];
    ZQMyViewController *myVC = [[ZQMyViewController alloc] init];
    myVC.tabBarItem.image = [[UIImage imageNamed:@"333"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"my_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.title = @"我的";
    BaseNavigationController *naviMy = [[BaseNavigationController alloc] initWithRootViewController:myVC];
    
    ZQCarServerViewController *serverVC = [[ZQCarServerViewController alloc] init];
    serverVC.title = @"车检服务";
    serverVC.tabBarItem.image = [[UIImage imageNamed:@"222"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    serverVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"222sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationController *naviServer = [[BaseNavigationController alloc] initWithRootViewController:serverVC];
    
    ZQCarProcessViewController *progressVC = [[ZQCarProcessViewController alloc] init];
    progressVC.title = @"车检流程";
    progressVC.tabBarItem.image = [[UIImage imageNamed:@"111"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    progressVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"111sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationController *naviProgress = [[BaseNavigationController alloc] initWithRootViewController:progressVC];
    tabBarVC.delegate = self;

    tabBarVC.viewControllers = @[naviProgress,naviServer,naviMy];
    tabBarVC.selectIndex = 0;
    return tabBarVC;
}

#pragma mark -tabBarDelegate-
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    self.sTabBarIndex = tabBarController.selectedIndex;
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    /*
    if (tabBarController.selectedIndex == 2)
    {
        if (![Utility isLogin]) {
            ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
            [tabBarController presentViewController:loginVC animated:YES completion:^{
                
            }];
            tabBarController.selectedIndex = self.sTabBarIndex;
        }
    }
*/
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
