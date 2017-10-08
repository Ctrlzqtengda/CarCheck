//
//  ZQAlerInputView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQAlerInputView.h"

@interface ZQAlerInputView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIButton *bgViewBtn;
@end

@implementation ZQAlerInputView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgViewBtn];
        [self addSubview:self.alertView];
        NSArray *contenArr = @[@"检车机构",@"选  择  省",@"选  择  市"];
        CGFloat width = CGRectGetWidth(_alertView.frame);
        CGFloat cellMargin = 20;
        CGFloat yMargin = 5.0;
        CGFloat labelWidth = 70;
        CGFloat labelHeight = 30;
        CGFloat textFieldWidth = width-labelWidth-cellMargin*2;
        CGFloat currentHeight = 20;
        for (int i = 0; i<contenArr.count; i++) {
            currentHeight+=yMargin;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cellMargin,currentHeight, labelWidth, labelHeight)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor darkGrayColor];
            label.text = contenArr[i];
            [_alertView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(cellMargin+labelWidth, currentHeight+1, textFieldWidth, labelHeight)];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.delegate = self;
            textField.font = [UIFont systemFontOfSize:15];
            textField.textColor = [UIColor darkGrayColor];
            textField.returnKeyType = UIReturnKeyDone;
            textField.tag = i;
            [_alertView addSubview:textField];
            currentHeight += (labelHeight+yMargin);
            if (i) {
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(textFieldWidth-13-10, 10, 13, 10)];
                imageV.image = [UIImage imageNamed:@"downArrow"];
                [textField addSubview:imageV];
            }
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0,0,100, 30)];
        [button setCenter:CGPointMake(CGRectGetWidth(_alertView.frame)/2, currentHeight+30)];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blueColor]];
        [button setTitle:@"提  交" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 4;
        [_alertView addSubview:button];
    }
    return self;
}
- (void)commitBtnAction
{
    [self close];
}

- (void)show
{
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    self.alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.alertView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.bgViewBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                         self.alertView.alpha = 1.0f;
                         
                     }
                     completion:nil
     ];
}

- (void)close
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.bgViewBtn.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.alertView.alpha = 0.0f;
                         self.bgViewBtn.alpha = 0;
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (UIButton *)bgViewBtn
{
    if (!_bgViewBtn) {
        _bgViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgViewBtn.frame = self.bounds;
        _bgViewBtn.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        [_bgViewBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgViewBtn;
}
- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
        _alertView.center = self.center;
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 10;
    }
    return _alertView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
