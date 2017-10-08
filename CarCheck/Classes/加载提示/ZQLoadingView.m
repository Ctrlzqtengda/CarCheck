//
//  ZQLoadingView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

UIWindow *_mainWindow() {
    return [UIApplication sharedApplication].keyWindow;
}

#import "ZQLoadingView.h"
#import "MBProgressHUD.h"

static MBProgressHUD  *s_progressHUD = nil;

@implementation ZQLoadingView

+ (void)showProgressHUD:(NSString *)aString duration:(CGFloat)duration {
    [self hideProgressHUD];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:_mainWindow()];
    for (id obj in _mainWindow().subviews) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [obj removeFromSuperview];
        }
    }
    [_mainWindow() addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.labelText = aString;
    
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.opacity = 0.7;
    [progressHUD show:NO];
    [progressHUD hide:YES afterDelay:duration];
}

+ (void)showProgressHUD:(NSString *)aString {
    if (!s_progressHUD) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            s_progressHUD = [[MBProgressHUD alloc] initWithView:_mainWindow()];
        });
    }else{
        [s_progressHUD hide:NO];
    }
    for (id obj in _mainWindow().subviews) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [obj removeFromSuperview];
        }
    }
    [_mainWindow() addSubview:s_progressHUD];
    s_progressHUD.removeFromSuperViewOnHide = YES;
    s_progressHUD.animationType = MBProgressHUDAnimationZoom;
    if ([aString length]>0) {
        s_progressHUD.labelText = aString;
    }
    else s_progressHUD.labelText = nil;
    
    s_progressHUD.opacity = 0.7;
    [s_progressHUD show:YES];
    
}

+ (void)showAlertHUD:(NSString *)aString duration:(CGFloat)duration {
    [self hideProgressHUD];
    for (id obj in _mainWindow().subviews) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [obj removeFromSuperview];
        }
    }
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:_mainWindow()];
    [_mainWindow() addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.labelText =aString;
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.opacity = 0.7;
    progressHUD.mode = MBProgressHUDModeText;
    [progressHUD show:NO];
    [progressHUD hide:YES afterDelay:duration];
}

+ (void)hideProgressHUD {
    if (s_progressHUD) {
        [s_progressHUD hide:YES];
    }
}

+ (void)updateProgressHUD:(NSString*)progress {
    if (s_progressHUD) {
        s_progressHUD.labelText = progress;
    }
}
@end
