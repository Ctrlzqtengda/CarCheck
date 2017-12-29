//
//  YFoundPasswordViewController.m
//  shopsN
//
//  Created by imac on 2016/12/6.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "YFoundPasswordViewController.h"
//#import "YFoundEmailViewController.h"
#import "YResetPassViewController.h"
#import "ZQLoadingView.h"

#import "NSString+Validation.h"

@interface YFoundPasswordViewController ()<UITextFieldDelegate>
{
    BOOL isRight;
    NSInteger temp;
}
@property (strong, nonatomic) UIView *backV;

@property (strong, nonatomic) NSString *mobile;

@property (strong, nonatomic) NSString *code;

@property (strong, nonatomic) NSString *picCode;

@property (strong, nonatomic) UIImageView *numIV;

@property (strong, nonatomic) NSTimer *temTimer;

@property (strong, nonatomic) UIButton *codeBtn;
@end

@implementation YFoundPasswordViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.temTimer) {
        [self.temTimer invalidate];
        self.temTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mobile = [Utility getUserPhone];
    temp = 60;
    [self initView];
    [self getNavis];
}

-(void)getNavis{
    UIView *NaviV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 64)];
    [self.view addSubview:NaviV];
    NaviV.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:NaviV];

    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 29, 30, 25)];
    [NaviV addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"返回" forState:BtnNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:BtnNormal];
    [cancelBtn addTarget:self action:@selector(back) forControlEvents:BtnTouchUpInside];

    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake((__kWidth-120)/2, 32, 120, 20)];
    [NaviV addSubview:titleLb];
    titleLb.textAlignment =NSTextAlignmentCenter;
    titleLb.font = BFont(16);
    titleLb.textColor = __DTextColor;
    titleLb.text = @"找回密码";
}


-(void)initView{
//    UIImageView *lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, 1)];
//    [self.view addSubview:lineIV];
//    lineIV.backgroundColor = HEXCOLOR(0xcbcbcb);

    _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 65, __kWidth, __kHeight-65)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor whiteColor];

    NSArray *imageArr = @[@"login_user",@"login_phone",@"login_password"];
    for (int i=0; i<3; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, 20+70*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor = MainBgColor;
        putV.layer.cornerRadius = 5;

        UIImageView *headIV = [[UIImageView alloc]init];
        headIV.contentMode = UIViewContentModeScaleAspectFit;
        [putV addSubview:headIV];
        headIV.image= MImage(imageArr[i]);

        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 13, __kWidth-210, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i+33;
        inputTF.delegate = self;
        inputTF.textAlignment = NSTextAlignmentLeft;

        switch (i) {
            case 0:
            {
                headIV.frame = CGRectMake(11, 11, 24, 24);
                inputTF.placeholder = @"已验证手机";
                inputTF.text = self.mobile;
            }
                break;
            case 1:
            {
                headIV.frame = CGRectMake(11,11, 24, 24);
                UIButton *codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-153, 3, 90, 40)];
                [putV addSubview:codeBtn];
                codeBtn.titleLabel.font = MFont(15);
                codeBtn.layer.cornerRadius =5;
                codeBtn.backgroundColor = [UIColor whiteColor];
                [codeBtn setTitle:@"获取验证码" forState:BtnNormal];
                [codeBtn setTitleColor:__TextColor forState:BtnNormal];
                [codeBtn addTarget:self action:@selector(getCode) forControlEvents:BtnTouchUpInside];
                self.codeBtn = codeBtn;
                inputTF.placeholder = @"短信验证码";
            }
                break;
            case 2:
            {
//                putV.frame = CGRectMake(30, 20+70*i, __kWidth-190, 46);
                headIV.frame = CGRectMake(11, 11, 24, 24);
//                inputTF.frame = CGRectMake(50, 13, __kWidth-250, 20);
//                inputTF.placeholder = @"图片验证码";
                inputTF.placeholder = @"请输入新密码";
                inputTF.secureTextEntry = YES;

//                _numIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(putV)+5, 172, 81, 32)];
//                [_backV addSubview:_numIV];
//                _numIV.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.yisu.cn/Home/Register/verify"]]];
//
//                UIButton *changeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectXW(_numIV), 172, 50, 32)];
//                [_backV addSubview:changeBtn];
//                changeBtn.titleLabel.font = MFont(14);
//                [changeBtn setTitle:@"换一张" forState:BtnNormal];
//                [changeBtn setTitleColor:LH_RGBCOLOR(153, 153, 153) forState:BtnNormal];
//                [changeBtn addTarget:self action:@selector(change) forControlEvents:BtnTouchUpInside];
            }
                break;

            default:
                break;
        }
    }
    UIButton *foundBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 249, __kWidth-60, 56)];
    [_backV addSubview:foundBtn];
    foundBtn.layer.cornerRadius =28;
    foundBtn.backgroundColor = __DefaultColor;
    foundBtn.titleLabel.font = BFont(18);
    [foundBtn setTitle:@"找回密码" forState:BtnNormal];
    [foundBtn addTarget:self action:@selector(found) forControlEvents:BtnTouchUpInside];


}

#pragma mark ==获取验证码==
-(void)getCode{
    [self.view endEditing:YES];
    if (_mobile.length) {
        if (![_mobile isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:SXLoadingTime];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_phone_code/phone/%@",_mobile];
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSInteger code = [jsonDic[@"code"] integerValue];
            if (code != 400) {
                strongSelf.code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
                //            [strongSelf.codeBtn setBackgroundColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1.0]];
                strongSelf.temTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:strongSelf selector:@selector(numTiming:) userInfo:nil repeats:YES];
            }
            else
            {
                [ZQLoadingView showAlertHUD:jsonDic[@"statusmsg"] duration:SXLoadingTime];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];

}
- (void)numTiming:(NSTimer *)sTimer
{
    if (temp == 0) {
        [sTimer invalidate];
        self.temTimer = nil;
        temp = 60;
        [_codeBtn setUserInteractionEnabled:YES];
        //        [_codeBtn setBackgroundColor:[UIColor colorWithRed:0x41/255.0 green:0xc9/255.0 blue:0xdc/255.0 alpha:1.0]];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)temp--] forState:UIControlStateNormal];
    }
}
#pragma mark ==换一张==
-(void)change{
   _numIV.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.yisu.cn/Home/Register/verify"]]];
}
#pragma mark ==找回密码==
-(void)found{

    if (_mobile) {
        if (![_mobile isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:1.5];
        return;
    }
    if (!isRight) {
        [ZQLoadingView showAlertHUD:@"请输入正确的验证码" duration:1.5];
        return;
    }
    if (!_picCode) {
        [ZQLoadingView showAlertHUD:@"请输入新密码" duration:1.5];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"daf/password_recovery/phone/%@/password/%@",_mobile,_picCode];

    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
//            [UdStorage storageObject:jsonDic[@"data"] forKey:Userid];
//            YResetPassViewController *vc =[[YResetPassViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf performSelector:@selector(backAction) withObject:strongSelf afterDelay:2.6];
            }
        }
    } failure:^(NSError *error) {

    } animated:YES];

}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//#pragma mark ==邮箱找回密码==
//-(void)chooseEmail{
//    NSLog(@"邮箱找回");
//    YFoundEmailViewController *vc = [[YFoundEmailViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ==UITextFiledDelegate==
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    switch (textField.tag-33) {
        case 0:
        {
            _mobile = textField.text;
        }
            break;
        case 1:
        {
            isRight = [_code isEqualToString:textField.text];
            if (!isRight) {
                [ZQLoadingView showAlertHUD:@"验证码错误" duration:SXLoadingTime];
            }
        }
            break;
        case 2:
        {
            _picCode = textField.text;
        }
            break;
        default:
            break;
    }
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleDefault;
}

- (void)dealloc {
    _numIV =nil;
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
