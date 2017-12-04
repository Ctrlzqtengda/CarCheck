//
//  RestAPI.h
//  美食厨房
//
//  Created by zhangqiang on 15/8/7.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#ifndef _____RestAPI_h
#define _____RestAPI_h
#import <UIKit/UIKit.h>

//#define BaseAPI                 @"http://192.168.16.147:8080/onepage/"  // 公司服务器

#define BaseAPI                 @"http://192.168.30.87/car/index.php/api/"    // 赵楠

#define kUpdateDataBaseToHost   @"vote3/test/update.do"

#define kHostUrlString          @"appinfo/list.do"

#define kProductListAPI         @"appinfo/plist"

#define kGoodsListAPI           @"appinfo/slist"       // 购物列表

#define kLoginAPI               @"appuser/login"       // 登录

#define SnsLoginUrlAPI          @"user_login2.action"  // 第三方登录

#define kRegisteAPI             @"appuser/reg"         //注册

#define kCollectAPI             @"appmyfavorite/save"  //收藏

#define kCollectionListAPI      @"appmyfavorite/findPersonalList"  //收藏列表


//   常量
/**************************************************************************************/

static NSString *const ZQdidLoginNotication = @"didLoginNotication";    // 登录成功

static NSString *const ZQdidLogoutNotication = @"didLogoutNotication"; // 退出登录

static NSString *const ZQReadStateDidChangeNotication = @"changeReadStatesNotication"; // 消息已读状态

static NSString *const ZQAddServeInfoNotication = @"addServeInfoNotication"; // 添加服务台消息

static NSString *const ZQAddOtherInfoNotication = @"addOtherInfoNotication"; // 添加其他消息

/**************************************************************************************/

//   storyboardId
/**************************************************************************************/

static NSString *const ZQLoginViewCotrollerId = @"loginViewCotrollerId";    // 登录控制器Id

static NSString *const ZQServeTabViewControllerId = @"serveTabViewControllerId";    // 服务台信息

static NSString *const ZQServeDetailViewControllerId = @"serveDetailViewControllerId"; // 服务台信息详情
static NSString *const ZQPublishInfoViewControllerId = @"publishInfoViewControllerId"; // 发布消息

/**************************************************************************************/

// 推送
//#define AppKey @"b4b8bd0f427af09839e23286"    // 测试

#define AppKey @"6816fee48fb77859f7a9011b"     // 发布

#endif
