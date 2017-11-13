//
//  ZQOrderTypeChooseView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQOrderTypeChooseView : UIView

@property (nonatomic,copy) void(^chooseOrderType)(NSInteger);
- (void)configViewWithArray:(NSArray *)titles;
//- (void)jumpToFirstBtnWith:(NSInteger)tag;
@end
