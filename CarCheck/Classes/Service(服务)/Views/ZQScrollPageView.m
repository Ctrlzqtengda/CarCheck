//
//  ZQScrollPageView.m
//  轮播图
//
//  Created by zhangqiang on 15/10/27.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "ZQScrollPageView.h"

@interface ZQScrollPageView()<UIScrollViewDelegate>{
    ClickBlock _clickBlock;
    NSArray *_imageArray;        //图片数组
    NSTimer *_timer;             //定时器
    NSInteger _currenIndex;      //轮播位置
    float _width;
    float _height;
}

@property(nonatomic,strong)UIImageView *frontImgView;
@property(nonatomic,strong)UIImageView *midImgView;
@property(nonatomic,strong)UIImageView *lastImgView;

@end

@implementation ZQScrollPageView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _width = self.frame.size.width;
        _height = self.frame.size.height;
        [self setupScrollPageView];
        
    }
    return self;
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _height * 0.8, _width * 0.2, _height * 0.1)];
        _pageControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _pageControl.center = CGPointMake(self.center.x, _pageControl.center.y);
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        _pageControl.hidesForSinglePage = NO;
        _pageControl.enabled = NO;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)playWithImageArray:(NSArray *)imageArray TimeInterval:(NSTimeInterval)displayTime clickImage:(ClickBlock )clickBlock {
    
    _imageArray = imageArray;
    _clickBlock = clickBlock;
    self.pageControl.numberOfPages = imageArray.count;
    _currenIndex = 0;
    [self.scrollView scrollRectToVisible:CGRectMake(_width * 1, 0, _width, _height) animated:YES];
    [self setImages];
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:displayTime target:self selector:@selector(doImageGoDisplay) userInfo:nil repeats:YES];
        
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }else {
        [_timer invalidate];
        _timer = nil;
    }

}

#pragma 私有方法 -UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self setScollViewMid];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > _width * 2) {
        [self setScollViewMid];
    }
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self setScollViewMid];
    
}


#pragma mark 私有方法 -

-(void)doImageGoDisplay {
    
    CGRect rect = CGRectMake(_width * 2, 0, _width, _height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    
}

- (void)setImages {
    if (_currenIndex == 0) {
        
        self.frontImgView.image = [_imageArray lastObject];
        self.lastImgView.image = _imageArray[_currenIndex + 1];
        
    }else if(_currenIndex == _imageArray.count - 1){
        
        self.frontImgView.image = _imageArray[_currenIndex - 1];
        self.lastImgView.image = [_imageArray firstObject];
        
    }else{
        
        self.frontImgView.image = _imageArray[_currenIndex - 1];
        self.lastImgView.image = _imageArray[_currenIndex + 1];
        
    }
    
    self.midImgView.image = _imageArray[_currenIndex];
}

- (void)setupScrollPageView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(_width * 3, _height);
    
    [self addSubview:self.scrollView];
    for (int i = 0; i < 3; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [self.scrollView addSubview:imageView];
        if (i == 0) {
            self.frontImgView = imageView;
        }else if(i == 1){
            self.midImgView = imageView;
        }else{
            self.lastImgView = imageView;
        }
    }
    
}

- (void)setScollViewMid {
    
    if (self.scrollView.contentOffset.x == 0) {
        _currenIndex --;
    }else if(self.scrollView.contentOffset.x >= _width * 2){
        _currenIndex ++;
    }else{
        return;
    }
    _currenIndex = (_currenIndex + _imageArray.count) % _imageArray.count;
    self.pageControl.currentPage = _currenIndex;
    self.scrollView.contentOffset = CGPointMake(_width, 0);
    [self setImages];
    
}

- (void)tapImageView:(UIGestureRecognizer *)gesture {
    _clickBlock(_currenIndex);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
