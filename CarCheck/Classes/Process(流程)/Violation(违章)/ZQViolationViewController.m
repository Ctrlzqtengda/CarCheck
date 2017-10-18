//
//  ZQViolationViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQViolationViewController.h"
#import "ZQAreaView.h"
#import "ZQAreaModel.h"
#import "ZQLoadingView.h"

@interface ZQViolationViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeight;
@property (weak, nonatomic) IBOutlet UITextField *provinceTf;
@property (weak, nonatomic) IBOutlet UITextField *cityTf;
@property (weak, nonatomic) IBOutlet UITextField *carProvinceTf;
@property (weak, nonatomic) IBOutlet UITextField *carCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *carNextCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn1;
@property (weak, nonatomic) IBOutlet UITextField *cardCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *driveCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn2;
@property (weak, nonatomic) IBOutlet UIScrollView *scollView;

@property (nonatomic, strong) ZQAreaView *areaView;
@property (nonatomic, strong) ZQAreaModel *provinceModel;
@end

@implementation ZQViolationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

-(void)viewDidLayoutSubviews {
    self.scollView.contentSize = CGSizeMake(KWidth, 677);
}

-(void)setupViews {
    
    self.title = @"违章查询";
    self.carProvinceTf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.carProvinceTf.keyboardType = UIKeyboardTypeASCIICapable;

    [self setRightViewWithTextField:self.provinceTf imageName:@"downArrow"];
    [self setRightViewWithTextField:self.cityTf imageName:@"downArrow"];
    [self setRightViewWithTextField:self.carProvinceTf imageName:@"downArrow"];
    
}

-(void)setRightViewWithTextField:(UITextField *)textfield imageName:(NSString *)imageName {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeCenter;
    textfield.rightView = imageView;
    textfield.rightViewMode = UITextFieldViewModeAlways;
    
}

- (IBAction)seachAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) {
        
    }
    if (btn.tag == 102) {
        
    }
    
}
- (void)showPickViewWithTextField:(UITextField *)textField
{
    if (_areaView) {
        [_areaView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_areaView removeFromSuperview];
        self.areaView = nil;
    }
    [self.view endEditing:YES];
    NSString *pId = nil;
    if ([textField isEqual:self.carProvinceTf]) {
        pId = @"-1"; //展示省的简称
    }
    else
    {
        if (self.provinceModel&&[textField isEqual:self.cityTf]) {
            pId = self.provinceModel.areaId;
        }
    }
    __weak __typeof(self) weakSelf = self;
    __weak UITextField *wTextField = textField;
    _areaView = [[ZQAreaView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-230, __kWidth, 230) provinceId:pId];
    _areaView.handler = ^(ZQAreaModel *areaModel)
    {
        if (areaModel) {
            wTextField.text = areaModel.areaName;
            if ([wTextField isEqual:weakSelf.provinceTf]) {
                weakSelf.provinceModel = areaModel;
            }
        }
    };
    [self.view addSubview:_areaView];
}
#pragma mark -UITextFieldDelegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.provinceTf]) {
        [self showPickViewWithTextField:textField];
        return NO;
    }
    if ([textField isEqual:self.cityTf]) {
        if (self.provinceModel) {
            [self showPickViewWithTextField:textField];
        }
        else
        {
            [ZQLoadingView showAlertHUD:@"请选择省份" duration:SXLoadingTime];
            
        }
        return NO;
    }
    if ([textField isEqual:self.carProvinceTf]) {
        if (textField.text.length) {
            return YES;
        }
        [self showPickViewWithTextField:textField];
        return NO;
    }
    return YES;
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
