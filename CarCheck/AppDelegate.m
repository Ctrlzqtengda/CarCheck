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
//#import "ZQMyTureViewController.h"
#import "ZQNewMyViewController.h"
#import "ZQLoginViewController.h"

//极光推送
#import "JPUSHService.h"
#import "ZQJkPushTool.h"

// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


@interface AppDelegate ()<UITabBarControllerDelegate,JPUSHRegisterDelegate>

@property (nonatomic, assign) NSUInteger sTabBarIndex;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
//    BaseTabBarViewController *tabBarVC = [[BaseTabBarViewController alloc] init];
    self.window.rootViewController = [self setupViews];
    [self.window makeKeyAndVisible];
//    [NSThread sleepForTimeInterval:2];
    return YES;
}

- (BaseTabBarViewController *)setupViews {
    
     BaseTabBarViewController *tabBarVC = [[BaseTabBarViewController alloc] init];
    ZQNewMyViewController *myVC = [[ZQNewMyViewController alloc] init];
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
    self.sTabBarIndex = tabBarController.selectedIndex;
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    if (tabBarController.selectedIndex == 2)
//    {
//        if (![Utility isLogin]) {
//            ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
//             BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
//            [tabBarController presentViewController:loginNa animated:YES completion:^{
//
//            }];
//            tabBarController.selectedIndex = self.sTabBarIndex;
//        }
//    }
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
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHMethod-
-(void)initJPushService:(UIApplication *)application WithOption:(NSDictionary *)launchOptions{
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@""
                          channel:@"App Store"
                 apsForProduction:false
            advertisingIdentifier:advertisingId];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNoti:) name:YSNotificationChange object:nil];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if ([UdStorage isAgreeReservationNoticeForKey:@"NotiSound"]) {
        [[ZQJkPushTool sharedInstanceForSound] zQPlay];
    }
//    if (_isRound) {
//        YJkPushTool *single = [YJkPushTool sharedInstanceForSound];
//        [single play];
//    }
//    if (_isShake) {
//        YJkPushTool *shake = [YJkPushTool sharedInstanceForVibrate];
//        [shake play];
//    }
//    if (_isAlert) {
//        UIViewController *vc = [self getCurrentVC];
//        for (id obj in vc.view.subviews) {
//            if ([obj isKindOfClass:[YSBannerView class]]) {
//                [obj removeFromSuperview];
//            }
//        }
//        [self showNotiView:userInfo[@"aps"][@"alert"][@"body"] type:@"1"];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert);
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
}

@end
