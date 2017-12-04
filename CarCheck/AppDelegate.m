//
//  AppDelegate.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#define HXKey @"1183170116178800#youshengshops"
//QQ
#define QQID @"1105952274"
#define QQKEY @"kl3qSJiZvpcmWCDT"
//微信
#define WXID @"wx8836bea9c40b21ce"
#define WXSecret @"a0a15e02a15068886a5637e15ddee70c"

//微博
#define WbID @"3311610802"
#define WbSecret @"99e2a78d92b237bfcbb20dee9f3ea9a0"
//极光
#define JPKey @"527dae4e9bf59947e7e77304"
#define JPSecret @"f7c189dc704d83cdb042add9"

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

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件<
#import "WeiboSDK.h"
//支付
#import "Pingpp.h"

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
    
//    @param activePlatforms
//    使用的分享平台集合
//    @param importHandler (onImport)
//    导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
//    @param configurationHandler (onConfiguration)
//    配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
    onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
    onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
////             http://www.sharesdk.cn“
//             authType:SSDKAuthTypeBoth
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:WbID appSecret:WbSecret redirectUri:@"http://www.sharesdk.cn" authType:SSDKAuthTypeBoth];
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@""
//                                           appSecret:@""
//                                         redirectUri:@""];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WXID
                                       appSecret:WXSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQID
                                      appKey:QQKEY
                                    authType:SSDKAuthTypeBoth];
                 break;
            default:
                   break;
                   }
                   }];
//     */
    
    // ping++支付
//    [Pingpp setDebugMode:NO];
    
    [self getServiceMoney];
    return YES;
}

//获取费用接口
- (void)getServiceMoney
{
    //费用接口
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"daf/get_service_money" withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        [Utility saveServiceMoneyWithArray:array];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
    } animated:NO];
}
- (BaseTabBarViewController *)setupViews {
    
     BaseTabBarViewController *tabBarVC = [[BaseTabBarViewController alloc] init];
    ZQNewMyViewController *myVC = [[ZQNewMyViewController alloc] init];
    myVC.tabBarItem.image = [[UIImage imageNamed:@"333"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"my_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.title = @"我的";
    BaseNavigationController *naviMy = [[BaseNavigationController alloc] initWithRootViewController:myVC];
    
    ZQCarServerViewController *serverVC = [[ZQCarServerViewController alloc] init];
    serverVC.title = @"车辆服务";
    serverVC.tabBarItem.image = [[UIImage imageNamed:@"222"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    serverVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"222sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationController *naviServer = [[BaseNavigationController alloc] initWithRootViewController:serverVC];
    
    ZQCarProcessViewController *progressVC = [[ZQCarProcessViewController alloc] init];
    progressVC.title = @"检车流程";
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
    if ([Utility isAgreeReservationNoticeForKey:@"NotiSound"]) {
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
//支付Pingpp
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}
@end
