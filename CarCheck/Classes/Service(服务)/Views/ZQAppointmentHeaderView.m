//
//  ZQAppointmentHeaderView.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQAppointmentHeaderView.h"

@interface ZQAppointmentHeaderView(){
    
    CGRect _frame;
}
@end

@implementation ZQAppointmentHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    CGFloat imageWidth = 31/2;
    UIImageView *imageLead = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_frame.size.height - imageWidth)/2.0, imageWidth, imageWidth)];
    imageLead.image = [UIImage imageNamed:@"shouyeyuyue"];
    [self addSubview:imageLead];
    
    UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake((_frame.size.width - 6) - 10, CGRectGetMinY(imageLead.frame), 6, 23/2)];
    imageRight.image = [UIImage imageNamed:@"shouyejiantou"];
    [self addSubview:imageRight];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageLead.frame)+10, CGRectGetMinY(imageLead.frame), _frame.size.width - 10 * 4, imageWidth)];
    titleLabel.text = @"预约";
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
    
}

-(void)tapAction:(UIGestureRecognizer *)gesture {
    
    if (self.handler) {
        self.handler();
    }
    
}

@end
