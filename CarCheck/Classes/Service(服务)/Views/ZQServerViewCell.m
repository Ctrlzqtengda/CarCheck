//
//  ZQServerViewCell.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQServerViewCell.h"

@interface ZQServerViewCell(){
    CGFloat _width;
    CGFloat _height;
}
@property(strong,nonatomic)UILabel *label;
@property(strong,nonatomic)UIImageView *imageView;

@end

@implementation ZQServerViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _width = frame.size.width;
        _height = frame.size.height;
//        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        
    }
    return self;
}

- (void)initViews {
    
    CGFloat inset = 20;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(inset, inset / 2.0, _width-inset*2, _width - inset * 2)];
//    _imageView.backgroundColor = [UIColor redColor];
    [self addSubview:_imageView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageView.frame), _width - 20, 20)];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

-(void)writeDataWithTitle:(NSString *)str imageStr:(NSString *)imgStr{
    _label.text = str;
    if (imgStr.length) {
        [_imageView setImage:[UIImage imageNamed:imgStr]];
    }
}

@end
