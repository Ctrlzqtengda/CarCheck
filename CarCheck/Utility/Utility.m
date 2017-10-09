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

@end
