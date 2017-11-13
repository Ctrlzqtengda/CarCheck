//
//  ZQOrderTypeChooseView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQOrderTypeChooseView.h"

@interface ZQOrderTypeChooseView()
{
    UIImageView *arrowImageV;
    UIButton *targetBtn;
    UIScrollView *scrollView;
}
@end
@implementation ZQOrderTypeChooseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //self.backgroundColor = kHWFilterViewBackground;
        self.backgroundColor = LH_RGBCOLOR(249, 249, 249);
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
    }
    return self;
}
- (void)configViewWithArray:(NSArray *)titles;
{
    CGFloat width = CGRectGetWidth(self.frame)/titles.count;
    CGFloat height = CGRectGetHeight(self.frame);
    scrollView.contentSize = CGSizeMake(width*titles.count, 0);
    for (int i = 0; i<titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width*i, 0, width, height);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitleColor:__TextColor forState:UIControlStateNormal];
        [btn setTitleColor:LH_RGBCOLOR(17,149,232) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        btn.tag = i+808;
        if (i == 0) {
            [btn setSelected:YES];
            targetBtn = btn;
        }
        if (i!=titles.count-1) {
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(width-1, (height-20)/2, 0.5,20)];
            lineV.backgroundColor = LH_RGBCOLOR(207, 207, 207);
            [btn addSubview:lineV];
        }
    }
    //        UIImage *arrowImage = [UIImage imageNamed:@"select_blue"];
    arrowImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, height - 2, width-20, 2)];
    arrowImageV.contentMode = UIViewContentModeCenter;
    arrowImageV.clipsToBounds = YES;
    arrowImageV.backgroundColor = LH_RGBCOLOR(17,149,232);
    //arrowImageV.center = CGPointMake(width/2, height-arrowImage.size.height/2);
    //        arrowImageV.image = arrowImage;
    [scrollView addSubview:arrowImageV];
}
- (void)btnAction:(UIButton *)sender
{
    if (targetBtn) {
        targetBtn.selected = NO;
    }
    sender.selected = !sender.selected;
    targetBtn = sender;
    
    [UIView animateWithDuration:.25 animations:^{
        arrowImageV.center = CGPointMake(sender.center.x,sender.frame.size.height - 2);
    }];
    if (self.chooseOrderType) {
        self.chooseOrderType(sender.tag-808);
    }
    
//    if(sender.center.x > __kWidth/5*3){
//        [scrollView setContentOffset:CGPointMake(__kWidth/5, 0) animated:YES];
//    }else{
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
    
}
@end
