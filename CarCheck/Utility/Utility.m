//
//  Utility.m
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(BOOL )isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}
+ (NSString *)getUserName {
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    if (!str.length) {
        str = @"未登录";
    }
    return str;
}

+ (NSString *)getUserID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
}

+(NSInteger)getIs_vip
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"is_vip"];
}

+(NSString *)getUserPhone
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userPhone"];
}
//+(NSData *)getUserHeadData
//{
//    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userHeadData"];
//}
+(NSString *)getUserHeadUrl
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userHeadUrl"];
}
+(void)saveUserInfo:(NSDictionary *)dict
{
    if (dict) {
        [Utility setLoginStates:YES];
        [Utility storageObject:dict[@"user"] forKey:@"userName"];
        [Utility storageObject:dict[@"phone"] forKey:@"userPhone"];
        [Utility storageInteger:[dict[@"is_vip"] integerValue] forKey:@"is_vip"];
        [Utility storageObject:[NSString stringWithFormat:@"%@",dict[@"uid"]] forKey:@"userId"];
        NSString *headStr = dict[@"head"];
        if ([headStr isKindOfClass:[NSString class]]) {
            if (headStr.length) {
                [Utility storageObject:headStr forKey:@"userHeadUrl"];
            }
        }
    }
    else
    {
        [Utility storageObject:nil forKey:@"userName"];
        [Utility storageObject:nil forKey:@"userPhone"];
        [Utility storageInteger:0 forKey:@"is_vip"];
        [Utility storageObject:nil forKey:@"userId"];
        [Utility storageObject:nil forKey:@"userHeadUrl"];
    }
}
+(double)getLongitude
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"Longitude"];
}
+(double)getLatitude
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"Latitude"];
}
+(void)saveLongitude:(double)lon Latitude:(double)lat
{
    [Utility storageValue:lon forKey:@"Longitude"];
    [Utility storageValue:lat forKey:@"Latitude"];
}
+(void)storageValue:(double)value forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)storageObject:(id)object forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)storageBool:(BOOL)object forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setBool:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)storageInteger:(NSInteger)object forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setInteger:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLoginStates:(BOOL )isLogin {
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    if (!isLogin) {
        [Utility saveUserInfo:nil];
    }
}
+(id)getObjectforKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
//是否已同意预约须知协议
+(void)storageAgreeReservationNotice:(BOOL)agree forKey:(NSString*)key
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setBool:agree forKey:key];
    [ud synchronize];
}
+(BOOL)isAgreeReservationNoticeForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
//+(void)saveUserName:(NSString *)userName {
//    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(void)saveUserId:(NSString *)userId {
//    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userId"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//+(void)saveUserPhone:(NSString *)phone
//{
//
//}
//+(void)saveIs_vip:(NSInteger)is_vip
//{
//
//}

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

+(NSDictionary *)getUserInfoFromLocal
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    return dict;
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
+ (void)baiDuMapWithLongitude:(double)lon latitude:(double)lat {
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        
//        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&origin=我的位置&lat=%f&lon=%f&dev=0&style=2",lat,lon];
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&&lat=%f&lon=%f&mode=driving&coord_type=gcj02",lat,lon];

//        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=雍和宫&mode=driving&coord_type=gcj02"];
        
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
        //
        NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E7%99%BE%E5%BA%A6%E5%9C%B0%E5%9B%BE-%E5%85%AC%E4%BA%A4%E5%9C%B0%E9%93%81%E5%87%BA%E8%A1%8C%E5%BF%85%E5%A4%87%E7%9A%84%E6%99%BA%E8%83%BD%E5%AF%BC%E8%88%AA/id452186370?mt=8"]];
    }
}

//跳转到高德地图
+ (void)gaoDeMapWithLongitude:(double)lon latitude:(double)lat {
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        //地理编码器
//        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&backScheme=iosamap://&dev=0&style=2"];
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&origin=我的位置&lat=%f&lon=%f&dev=0&style=2",lat,lon];

//        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&origin=我的位置&destination=雍和宫&dev=0&style=2"];
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
//        NSLog(@"您的iPhone未安装高德地图，请进行安装！");
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E9%AB%98%E5%BE%B7%E5%9C%B0%E5%9B%BE-%E7%B2%BE%E5%87%86%E5%9C%B0%E5%9B%BE-%E5%AF%BC%E8%88%AA%E5%BF%85%E5%A4%87-%E9%A6%96%E5%8F%91%E9%80%82%E9%85%8Diphone-x/id461703208?mt=8"]];
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

//请求的url进行编码
+ (NSString *)percentEncodingWithUrl:(NSString *)url
{
//    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
//    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
//    return [url stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
     return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
}

//所有省份简称
+ (NSArray *)getProvinceShortNum
{
    return @[@"京",@"津",@"沪",@"渝",@"蒙",@"冀",@"新",@"辽",@"藏",@"宁",@"桂",@"黑",@"晋",@"青",@"鲁",@"港",@"澳",@"豫",@"苏",@"皖",@"闽",@"赣",@"湘",@"鄂",@"粤",@"琼",@"甘",@"陕",@"贵",@"云",@"川"];
}
/**
 *  获取上门服务费
 *
 */
+(NSString *)getDoorToDoorOutlay
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"DoorOutlay"];
}
/**
 *  获取新车免检服务费
 *
 */
+(NSString *)getNewCarServiceOutlay
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"NewCarOutlay"];
}

+(void)saveServiceMoneyWithArray:(NSArray*)array
{
    for (NSDictionary *dic in array) {
        NSString *str = dic[@"c_name"];
        if ([str isKindOfClass:[NSString class]]) {
            if ([str rangeOfString:@"新车"].location != NSNotFound) {
                [Utility storageObject:dic[@"c_cost"] forKey:@"NewCarOutlay"];
            }
            if ([str rangeOfString:@"上门"].location != NSNotFound) {
                [Utility storageObject:dic[@"c_cost"] forKey:@"DoorOutlay"];
            }
        }
    }
}
@end
