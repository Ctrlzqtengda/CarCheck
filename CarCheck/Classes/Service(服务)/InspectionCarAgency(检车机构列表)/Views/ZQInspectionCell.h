//
//  ZQInspectionCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQInspectionCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, strong) UIButton *navigationBtn;
@property (nonatomic, strong) UIButton *bookingBtn;

+ (CGFloat)inspectionCellHeight;
@end
