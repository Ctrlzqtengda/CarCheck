//
//  Utility.m
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "Utility.h"
#import <MJExtension.h>

@implementation Utility

+ (void)initStateForLeaddingView {
    
    if ([Utility isFirstLoadding]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@0 forKey:@"lead1"];
        [dict setObject:@0 forKey:@"lead2"];
        [dict setObject:@0 forKey:@"lead3"];
        [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"leadView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)isFirstLoadding {
    
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLoadding"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLoadding"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return !flag;
}

+(void)setLoginStates:(BOOL )isLogin {
    
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(BOOL )isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}

-(void)saveUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
}

+ (NSString *)getUserID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
}

+(NSDictionary *)getUserInfoFromLocal
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    return dict;
}

+(void)saveUserInfo:(NSDictionary *)dict
{
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL )shouldShowLeadViewStateWithKey:(NSString *)leadView {
    // 判断的同时改变状态
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"leadView"];
    BOOL flag = [dict[leadView] boolValue];

    return !flag;
    
}

+(void)updateStateForLeadView:(NSString *)leadView {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"leadView"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [tempDict setValue:@1 forKey:leadView];
    [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"leadView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)checkNewVersion:(void(^)(BOOL hasNewVersion))versionCheckBlock{
    
//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
////    NSLog(@"%@",[infoDict objectForKey:@"CFBundleShortVersionString"]);
//    __block double currentVersion = [[infoDict objectForKey:@"CFBundleShortVersionString"] doubleValue];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"IOS" forKey:@"clientType"];
//    [RequestManager startRequest:kCheckNewVersionAPI paramer:dict method:(RequestMethodPost) success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dict = [responseObject objectForKey:@"list"];
//        double newVersion = [[dict objectForKey:@"versionNum"] doubleValue];
//        BOOL flag = newVersion > currentVersion;
//        versionCheckBlock(flag);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        versionCheckBlock(NO);
//    }];
}

//跳转到百度地图
+ (void)baiDuMap:(id)sender {
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=雍和宫&mode=driving&coord_type=gcj02"];
        
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
        //
        NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        NSLog(@"您的iPhone未安装百度地图，请进行安装！");
    }
}

//跳转到高德地图
+ (void)gaoDeMap:(id)sender {
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        //地理编码器
//        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&backScheme=iosamap://&dev=0&style=2"];
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&origin=我的位置&destination=雍和宫&dev=0&style=2"];
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
        //
        NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        //我们假定一个终点坐标，上海嘉定伊宁路2000号报名大厅:121.229296,31.336956
//        [geocoder geocodeAddressString:@"天通苑" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            for (CLPlacemark *placemark in placemarks){
//                //坐标（经纬度)
//                CLLocationCoordinate2D coordinate = placemark.location.coordinate;
//
//                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"mapNavigation",@"iosamap://",coordinate.latitude, coordinate.longitude];
//
//                NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:urlString] invertedSet];
//
//                NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//            }
//        }];
    }else{
        NSLog(@"您的iPhone未安装高德地图，请进行安装！");
    }
}

// 底部弹窗Actionsheet
+(void)showActionSheetWithTitle:(NSString *)title
                   contentArray:(NSArray *)contentArray
                     controller:(UIViewController *)controller
                    chooseBlock:(void(^)(NSInteger index))block{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    for (int i = 0; i < contentArray.count; i ++ ) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:contentArray[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            block(i);
        }];
        [alertVC addAction:alertAction];
    }
    [controller presentViewController:alertVC animated:YES completion:nil];
}

@end
