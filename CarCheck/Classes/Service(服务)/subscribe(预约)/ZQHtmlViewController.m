//
//  ZQHtmlViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQHtmlViewController.h"
#import <WebKit/WebKit.h>

@interface ZQHtmlViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, copy) NSString *urlString;
@property (strong,nonatomic) UIProgressView *progressV;
@property (strong,nonatomic) WKWebView *webView;
@property (assign,nonatomic) BOOL isShow;
@end

@implementation ZQHtmlViewController

- (id)initWithUrlString:(NSString *)urlString andShowBottom:(BOOL)isShow
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.isShow = isShow;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self.view.bounds;
    
    //展示底部
    if (_isShow) {
        rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds)-44);
        [self addBottomBtn];
    }
    [self.webView setFrame:rect];
    [self.view addSubview:self.webView];
    if ([_urlString hasPrefix:@"https://"])
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    }
    else
    {
        NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
        NSString *path = [mainBundleDirectory  stringByAppendingPathComponent:_urlString];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    [self.progressV setFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 5)];
    [self.view addSubview:self.progressV];
    [self.view bringSubviewToFront:_progressV];
}
- (void)addBottomBtn
{
    CGFloat width = CGRectGetWidth(self.view.bounds)/2;
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(width*i,  CGRectGetHeight(self.view.bounds)-44,width, 44)];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        if (i) {
            [button setBackgroundColor:LH_RGBCOLOR(12,189,49)];
            [button setTitle:@"立即预约" forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundColor:LH_RGBCOLOR(17,149,232)];
            [button setImage:[UIImage imageNamed:@"naviIcon"] forState:UIControlStateNormal];
            [button setTitle:@"导航到点" forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)bottomBtnAction:(UIButton *)sender
{
    if (sender.tag) {
//        立即预约
    }
    else
    {
//        导航到店
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载");
    self.progressV.hidden = NO;
    self.progressV.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"返回加载");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成");
    self.progressV.hidden = YES;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载失败");
}

//**WKNavigationDelegate*
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //获取请求的url路径.
    NSString *requestString = navigationResponse.response.URL.absoluteString;
    NSLog(@"requestString:%@",requestString);
    // 遇到要做出改变的字符串
    NSString *subStr = @"www.baidu.com";
    if ([requestString rangeOfString:subStr].location != NSNotFound) {
        NSLog(@"这个字符串中有subStr");
        //回调的URL中如果含有百度，就直接返回，也就是关闭了webView界面
//        [self.navigationController  popViewControllerAnimated:YES];
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.webView) {
        self.progressV.progress = self.webView.estimatedProgress;
        if (self.progressV.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressV.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressV.hidden = YES;
                [weakSelf.progressV removeFromSuperview];
                weakSelf.progressV = nil;
            }];
        }        }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return _webView;
}
- (UIProgressView *)progressV {
    if (!_progressV) {
        _progressV = [[UIProgressView alloc] init];
        _progressV.backgroundColor = [UIColor blueColor];
    }
    return _progressV;
}
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
