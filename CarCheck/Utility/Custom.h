//
//  Custom.h
//  shopSN
//
//  Created by imac on 15/12/1.
//  Copyright © 2015年 imac. All rights reserved.
//

#ifndef Custom_h
#define Custom_h


#endif /* Custom_h */


//block
#define WK(weakSelf) \
__block __weak __typeof(&*self)weakSelf = self;

//页面布局
#define __kWidth [[UIScreen mainScreen]bounds].size.width
#define __kHeight [[UIScreen mainScreen]bounds].size.height
#define CGRectOrigin(v)    v.frame.origin
#define CGRectSize(v)      v.frame.size
#define CGRectX(v)         CGRectOrigin(v).x
#define CGRectY(v)         CGRectOrigin(v).y
#define CGRectW(v)         CGRectSize(v).width
#define CGRectH(v)         CGRectSize(v).height
#define CGRectXW(v)         (CGRectSize(v).width+CGRectOrigin(v).x)
#define CGRectYH(v)         (CGRectSize(v).height+CGRectOrigin(v).y)

#define GAP_SPACE                       0.0 //滚动视图 图片间隔
#define Cell_SPACE                      10.0 //collectinView 间隔
#define Cell_MINISPACE                  5.0  //collectinView 最小间隔
#define Cell_MAXSPACE                   15.0  //最大间隔

//屏幕高度类型
#define __k4Height         480
#define __k5Height         568
#define __k6Height         667
#define __k6pHeigt         736


//手机型号

// 取系统版本，e.g.  4.0 5.0
#define kSystemVersion [[[UIDevice currentDevice] systemVersion]  floatValue]
#define IOS7 kSystemVersion>7.0
#define MyAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]



//文字设置
#define MFont(font)  (NSFoundationVersionNumber>NSFoundationVersionNumber_iOS_9_x_Max)?[UIFont systemFontOfSize:(font*17/17.5)]:[UIFont systemFontOfSize:(font)]
#define BFont(font)  (NSFoundationVersionNumber>NSFoundationVersionNumber_iOS_9_x_Max)?[UIFont boldSystemFontOfSize:(font*17/17.5)]:[UIFont boldSystemFontOfSize:(font)]



//空值判断
#define IsNilString(__String) (__String==nil || [__String isEqualToString:@""]|| [__String isEqualToString:@"null"])
#define IsNull(__Text) [__Text isKindOfClass:[NSNull class]]

#define IsEquallString(_Str1,_Str2)  [_Str1 isEqualToString:_Str2]


//颜色和图片
#define MImage(image)  [UIImage imageNamed:(image)]
#define OMImage(image)  [[UIImage imageNamed:(image)]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]//使用原生图片

//主颜色
#define __DefaultColor    HEXCOLOR(0x05c2f8)//
//金额颜色
#define __MoneyColor      LH_RGBCOLOR(224, 40, 40)
//账户背景色
#define __AccountBGColor  HEXCOLOR(0xeff0f1)//参考值(239 240 241) (0xeff0f1)
//布局测试颜色
#define __TestGColor    [UIColor greenColor]
#define __TestOColor    [UIColor orangeColor]

#define __BackColor LH_RGBCOLOR(240, 240, 240)
#define __TextColor LH_RGBCOLOR(85, 85, 85)
#define __DTextColor LH_RGBCOLOR(51, 51, 51)
#define __LightTextColor LH_RGBCOLOR(150, 150, 150)

//16进制color 使用方法：HEXCOLOR(0xffffff)
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LH_RGBCOLOR(R, G, B)    [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#define LH_RandomColor          LH_RGBCOLOR(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))





//button
# define BtnNormal            UIControlStateNormal
# define BtnTouchUpInside     UIControlEventTouchUpInside
# define BtnStateSelected     UIControlStateSelected
# define BtnHighlighted       UIControlStateHighlighted

//项目名称
#define  ZQPROJECTNAME @"新概念检车"


//提示信息显示 时间
#define  SXLoadingTime 2.0
#define DidLoadFailure @"加载失败"
#define DidLoadSuccess @"加载成功"
#define LoadComplete @"已经加载完了"
#define IsLoading @"正在加载数据,请稍后..."


//NSLog
#ifdef DEBUG        //调试状态打开LOG功能
#define NSLog(...) NSLog(__VA_ARGS__)
#else               //发布状态关闭LOG功能
#define NSLog(...)
#endif


