//
//  ZQScrollPageView.h
//  轮播图
//
//  Created by zhangqiang on 15/10/27.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickBlock)(NSInteger index);

@interface ZQScrollPageView : UIView

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;

// 开始播放动画
- (void)playWithImageArray:(NSArray *)imageArray TimeInterval:(NSTimeInterval)displayTime clickImage:(ClickBlock )clickBlock;

@end
