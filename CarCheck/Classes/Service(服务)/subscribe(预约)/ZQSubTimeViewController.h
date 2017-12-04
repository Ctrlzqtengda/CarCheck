//
//  ZQSubTimeViewController.h
//  CarCheck
//
//  Created by zhangqiang on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

@interface ZQSubTimeViewController : BaseViewController

@property (nonatomic, copy) NSString *costMoney;
@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, strong) NSArray *uploadImageArr;
@property (nonatomic, assign) CGFloat serviceChargeMoney;
@end
