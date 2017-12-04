//
//  ZQMyOrderViewController.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
typedef enum
{
    ZQAllOrdersView = 0,        //全部
    ZQInProcessOrdersView,      //处理中
    ZQSucessOrdersView,         //已成功
    ZQRevocationOrdersView,     //已撤销
} ZQOrderViewType;

@interface ZQMyOrderViewController : BaseViewController

@property (nonatomic, assign) ZQOrderViewType currentViewType; 
@end
