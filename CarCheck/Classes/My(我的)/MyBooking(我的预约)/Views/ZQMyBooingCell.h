//
//  ZQMyBooingCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZQOrderModel.h"

@interface ZQMyBooingCell : UITableViewCell

@property (nonatomic, strong) ZQOrderModel *orderModel;

@property (nonatomic, strong) UIButton *agencyDetailBtn;
@property (nonatomic, strong) UIButton *evaluationBtn;
@property (nonatomic, strong) UIButton *endorseBtn;
+(CGFloat)myBooingCellHeight;
@end
