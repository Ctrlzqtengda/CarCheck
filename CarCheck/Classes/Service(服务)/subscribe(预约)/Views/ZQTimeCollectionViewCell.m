//
//  ZQTimeCollectionViewCell.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQTimeCollectionViewCell.h"

@implementation ZQTimeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:231/255.0 blue:245/255.0 alpha:1];
    self.timeLabel.layer.cornerRadius = 5;
    self.timeLabel.clipsToBounds = YES;
    // Initialization code
}

@end
