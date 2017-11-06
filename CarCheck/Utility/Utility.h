//
//  Utility.h
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

/**
 *  初始化是否显示引导图信息
 *
 */
+ (void)initStateForLeaddingView;

/**
 *  是否显示过
 *
 *  @return flag
 */
+ (BOOL )shouldShowLeadViewStateWithKey:(NSString *)leadView;

/**
 *  更新状态
 *
 */
+(void)updateStateForLeadView:(NSString *)leadView;
/**
 *  获取用户信息
 *
 *  @return 用户信息
 */
+(NSDictionary *)getUserInfoFromLocal;

/**
 *  存储用户信息
 *
 *  @param dict 用户信息
 */
+(void)saveUserInfo:(NSDictionary *)dict;

/**
 *  设置登录状态
 *
 *  @param isLogin 是否登录
 */
+(void)setLoginStates:(BOOL )isLogin;

/**
 *  登录状态
 *
 *  @return 是否登录
 */
+(BOOL )isLogin;

/**
 *  获取用户ID
 */
+ (NSString *)getUserID;

/**
 *  获取用户名
 *
 */
+ (NSString *)getUserName;

/**
 *  保存用户Id
 *
 */
-(void)saveUserId:(NSString *)userId;

/**
 *  保存用户名
 *
 */
-(void)saveUserName:(NSString *)userName;

/**
 *  版本检测
 *
 *  @param versionCheckBlock 是否有新版本
 */
+(void)checkNewVersion:(void(^)(BOOL hasNewVersion))versionCheckBlock;

/**
 *  打开百度地图
 *
 *  @param sender 默认为nil
 */
+ (void)baiDuMap:(id)sender;

/**
 *  打开高德地图
 *
 *  @param sender 默认为nil
 */
+ (void)gaoDeMap:(id)sender;

/**
 *  弹窗
 *
 *  @param title 标题
 *  @param contentArray 内容项
 *  @param controller 显示的控制器
 *  @param block 选中回调
 */
+(void)showActionSheetWithTitle:(NSString *)title
                   contentArray:(NSArray *)contentArray
                     controller:(UIViewController *)controller
                    chooseBlock:(void(^)(NSInteger index))block;

@end
