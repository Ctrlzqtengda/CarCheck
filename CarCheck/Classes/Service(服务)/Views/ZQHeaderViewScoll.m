//
//  ZQHeaderViewScoll.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQHeaderViewScoll.h"

@interface ZQHeaderViewScoll(){
    
    CGRect _frame;
    NSMutableArray *_imageArray;
}
@property (strong,nonatomic) ZQScrollPageView *adScrollV;
@end

@implementation ZQHeaderViewScoll

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.adScrollV];
    }
    return self;
}

-(void)setImageStrArray:(NSArray *)imageStrArray {
    _imageStrArray = imageStrArray;
    if (!_imageArray.count) {
        _imageArray = [NSMutableArray array];
        for (NSString *imgStr in _imageStrArray) {
//            UIImage *image = [UIImage imageNamed:imgStr];
            UIImage *image = [UIImage imageNamed:@"adp.png"];
            [_imageArray addObject:image];
        }
    }
}

-(void)startWithBlock:(ClickBlock)block {
    [_adScrollV playWithImageArray:_imageArray TimeInterval:5.0 clickImage:block];
}

-(ZQScrollPageView *)adScrollV {
    
    if (!_adScrollV) {
        _adScrollV = [[ZQScrollPageView alloc] initWithFrame:_frame];
    }
    return _adScrollV;
}

@end
