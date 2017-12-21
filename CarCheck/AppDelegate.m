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
#define WXID @"wx856faae7831229da"
#define WXSecret @"c463ec4cb749ef0ab56b3c3615790877"

//微博
#define WbID @"3311610802"
#define WbSecret @"36b4142ac5d137f32d51cd7d"
//极光
#define JPKey @"8f0ab8de2397697351bec55b"
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
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<UITabBarControllerDelegate,JPUSHRegisterDelegate>

@property (nonatomic, assign) NSUInteger sTabBarIndex;

@property (assign,nonatomic) BOOL isAlert;

@property (assign,nonatomic) BOOL isShake;

@property (assign,nonatomic) BOOL isRound;
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
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline),
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
    
    //极光推送
    _isAlert = YES;
    _isRound =YES;
    _isShake = YES;
    [self initJPushService:application WithOption:launchOptions];
    
    [self getServiceMoney];

    return YES;
}

//获取费用接口
- (void)getServiceMoney
{
    //费用接口
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_service_money/u_id/%@",[Utility getUserID]];
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        [Utility saveServiceMoneyWithArray:array];
                        [Utility storageObject:jsonDic[@"phone"] forKey:@"ServerPhone"];
                        [Utility storageObject:jsonDic[@"is_vip"] forKey:@"is_vip"];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [Utility storageObject:@"4008769838" forKey:@"ServerPhone"];
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
    NSLog(@"DeviceTokenDeviceToken:%@",deviceToken);
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
    [JPUSHService setupWithOption:launchOptions appKey:JPKey
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

//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//
//    [[UPPaymentControl defaultControl]
//     handlePaymentResult:url
//     completeBlock:^(NSString *code, NSDictionary *data) {
//         //结果code为成功时，先校验签名，校验成功后做后续处理
//         if([code isEqualToString:@"success"]) {
//             //判断签名数据是否存在
//             if(data == nil){
//                 //如果没有签名数据，建议商户app后台查询交易结果
//                 return;
//             }
//             //数据从NSDictionary转换为NSString
//             NSData *signData = [NSJSONSerialization dataWithJSONObject:data
//                                                                options:0
//                                                                  error:nil];
//             NSString *sign = [[NSString alloc]
//                               initWithData:signData
//                               encoding:NSUTF8StringEncoding];
//             NSLog(@"Sign: %@", sign);
//             //验签证书同后台验签证书
//             //此处的verify，商户需送去商户后台做验签
//             //支付成功且验签成功，展示支付成功提示
//             //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//         } else if([code isEqualToString:@"fail"]) {
//             //交易失败
//         } else if([code isEqualToString:@"cancel"]) {
//             //交易取消
//         }
//     }];        //调用其他SDK，例如支付宝SDK等
    //    if ([sourceApplication isEqualToString:@"com.tencent.xin"]||[sourceApplication isEqualToString:@"pay"]) {
    //            //微信支付回调
    //            return [WXApi handleOpenURL:url delegate:self];
    //    }
    
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        NSLog(@"Appdelegate-Pingpp支付结果%@",result);
        if (error) {
            switch (error.code) {
                case PingppErrCancelled:
                    [ZQLoadingView showAlertHUD:@"支付取消" duration:SXLoadingTime];
                    break;
                    
                default:
                    [ZQLoadingView showAlertHUD:@"支付失败" duration:SXLoadingTime];
                    break;
            }
            //            [self checkPay];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"enterSuccessView" object:nil];
        }
        else
        {
            [ZQLoadingView showAlertHUD:@"支付成功" duration:SXLoadingTime];
        }
    }];
    
    if ([sourceApplication isEqualToString:@"CarCheckSchemes"]) {
        
        [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
            NSLog(@"Appdelegate-Pingpp支付结果%@",result);
            if (error) {
                switch (error.code) {
                    case PingppErrCancelled:
                        [ZQLoadingView showAlertHUD:@"支付取消" duration:SXLoadingTime];
                        break;
                        
                    default:
                        [ZQLoadingView showAlertHUD:@"支付失败" duration:SXLoadingTime];
                        break;
                }
                //            [self checkPay];
                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"enterSuccessView" object:nil];
            }
            else
            {
                [ZQLoadingView showAlertHUD:@"支付成功" duration:SXLoadingTime];
            }
        }];
        
        return YES;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *status = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if ([status isEqualToString:@"9000"]) {
//                [self checkPay];
            }
        }];
    }
    
    return YES;
    
}
//支付Pingpp
//9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        NSLog(@"Appdelegate-Pingpp支付结果%@",result);
        if (error) {
            switch (error.code) {
                case PingppErrCancelled:
                    [ZQLoadingView showAlertHUD:@"支付取消" duration:SXLoadingTime];
                    break;
                    
                default:
                       [ZQLoadingView showAlertHUD:@"支付失败" duration:SXLoadingTime];
                    break;
            }
            //            [self checkPay];
        }
        else
        {
          [ZQLoadingView showAlertHUD:@"支付成功" duration:SXLoadingTime];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"enterSuccessView" object:nil];
        }
    }];
    
//    [[UPPaymentControl defaultControl]
//     handlePaymentResult:url
//     completeBlock:^(NSString *code, NSDictionary *data) {
//         //结果code为成功时，先校验签名，校验成功后做后续处理
//         if([code isEqualToString:@"success"]) {
//             //判断签名数据是否存在
//             if(data == nil){
//                 //如果没有签名数据，建议商户app后台查询交易结果
//                 return;
//             }
//             //数据从NSDictionary转换为NSString
//             NSData *signData = [NSJSONSerialization dataWithJSONObject:data
//                                                                options:0
//                                                                  error:nil];
//             NSString *sign = [[NSString alloc]
//                               initWithData:signData
//                               encoding:NSUTF8StringEncoding];
//             NSLog(@"Sign: %@", sign);
//             //验签证书同后台验签证书
//             //此处的verify，商户需送去商户后台做验签
//             //支付成功且验签成功，展示支付成功提示
//             //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//         } else if([code isEqualToString:@"fail"]) {
//             //交易失败
//         } else if([code isEqualToString:@"cancel"]) {
//             //交易取消
//         }
//     }];
    //    //调用其他SDK，例如支付宝SDK等
    //    if ([url.host isEqualToString:@"com.tencent.xin"]||[url.host isEqualToString:@"pay"]) {
    //        //微信支付回调
    //        return [WXApi handleOpenURL:url delegate:self];
    //    }
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *status = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if ([status isEqualToString:@"9000"]) {
//                [self checkPay];
            }
        }];
    }
    return YES;
}


//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
//    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        switch (resp.errCode) {
//            case 0:
//                payResoult = @"支付结果：成功！";
////                [self checkPay];
//                break;
//            case -1:
//                payResoult = @"支付结果：失败！";
//                break;
//            case -2:
//                payResoult = @"用户已经退出支付！";
//                break;
//            default:
//                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                break;
//        }
//    }
}
@end
