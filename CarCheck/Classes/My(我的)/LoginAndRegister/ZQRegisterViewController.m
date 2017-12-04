//
//  ZQRegisterViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/11.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQRegisterViewController.h"
#import "ZQLoadingView.h"

@interface ZQRegisterViewController ()<UITextFieldDelegate>
{
    int  temp;
    BOOL rIsVerify;
}
@property (strong,nonatomic) UIScrollView *backV;

@property (strong,nonatomic) NSString *mobile;//手机

@property (strong,nonatomic) NSString *passWord;//密码

@property (strong,nonatomic) NSString *verify;//验证码

@property (strong,nonatomic) NSTimer *tempTimer;

@property (strong,nonatomic) UIButton *codeBtn;
@end

@implementation ZQRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    temp = 60;
    rIsVerify = NO;
    [self getNavis];
    [self initView];
}
-(void)getNavis{
    
    UIView *NaviV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 64)];
    [self.view addSubview:NaviV];
    NaviV.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:NaviV];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 29, 30, 25)];
    [NaviV addSubview:cancelBtn];
    cancelBtn.titleLabel.font = MFont(14);
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:BtnNormal];
    [cancelBtn addTarget:self action:@selector(back) forControlEvents:BtnTouchUpInside];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake((__kWidth-150)/2, 32, 150, 20)];
    [NaviV addSubview:titleLb];
    titleLb.textAlignment =NSTextAlignmentCenter;
    titleLb.font = BFont(16);
    titleLb.textColor = __DTextColor;
    titleLb.text = @"注册";
}
-(void)initView
{
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor whiteColor];
    [self.view sendSubviewToBack:_backV];
    _backV.contentSize = CGSizeMake(__kWidth, 667+70);
    
    //main
    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-173)/2, 74, 173, 28)];
    [_backV addSubview:loginIV];
    loginIV.image =MImage(@"CJWY");
    loginIV.contentMode = UIViewContentModeScaleAspectFit;
    
    NSArray *imageArr =@[@"login_user",@"login_phone",@"login_password"];
    for (int i=0; i<imageArr.count; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectYH(loginIV)+30+60*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor= MainBgColor;

        UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 24, 24)];
        headIV.contentMode = UIViewContentModeScaleAspectFit;
        [putV addSubview:headIV];
        headIV.image =MImage(imageArr[i]);
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 18, __kWidth-180, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i;
        inputTF.secureTextEntry = NO;
        inputTF.delegate = self;
        inputTF.textAlignment = NSTextAlignmentLeft;
        switch (i) {
            case 0:{
                inputTF.placeholder = @"请输入您的手机号";
            }
                break;
            case 1:{
                self.codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-148, 3, 85, 40)];
                _codeBtn.titleLabel.font = MFont(13);
                _codeBtn.backgroundColor = [UIColor whiteColor];
                [_codeBtn setTitle:@"获取验证码" forState:BtnNormal];
                [_codeBtn setTitleColor:__TextColor forState:BtnNormal];
                [_codeBtn addTarget:self action:@selector(getCode) forControlEvents:BtnTouchUpInside];
                [putV addSubview:_codeBtn];
                inputTF.placeholder = @"请输入验证码";
            }
                break;
            case 2:{
                inputTF.placeholder = @"请输入您的密码";
                break;
            }
            default:
                break;
        }
    }
    UIButton *registerBtn= [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectYH(loginIV)+230, __kWidth-60, 56)];
    [_backV addSubview:registerBtn];
    registerBtn.backgroundColor = __DefaultColor;
    registerBtn.layer.cornerRadius = 28;
    registerBtn.titleLabel.font = BFont(18);
    [registerBtn setTitle:@"注册" forState:BtnNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [registerBtn addTarget:self action:@selector(regiSter) forControlEvents:BtnTouchUpInside];
    
    UIButton *goLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake((__kWidth+80)/4, CGRectYH(registerBtn)+10, (__kWidth-80)/2, 20)];
    [_backV addSubview:goLoginBtn];
    goLoginBtn.backgroundColor = [UIColor clearColor];
    goLoginBtn.titleLabel.font = MFont(15);
    [goLoginBtn setTitle:@"已有账号 >" forState:BtnNormal];
    [goLoginBtn setTitleColor:__DefaultColor forState:BtnNormal];
    [goLoginBtn addTarget:self action:@selector(back) forControlEvents:BtnTouchUpInside];
    
}

#pragma mark ==注册==
-(void)regiSter{
    
    if (!_mobile) {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:1.5];
        return;
    }
//    if (!rIsVerify) {
//        [ZQLoadingView showAlertHUD:@"请输入正确的验证码" duration:1.5];
//        return;
//    }
    if (!_passWord) {
        [ZQLoadingView showAlertHUD:@"请输入密码" duration:1.5];
        return;
    }
    //注册接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/my_userInsert/phone/%@/password/%@",_mobile,_passWord];
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.navigationController popViewControllerAnimated:YES];
                //保存用户名
//                [UdStorage storageObject:strongSelf.mobile forKey:@"User_phone"];
            }
        }
    } failure:^(NSError *error) {

    } animated:YES];
    
}


#pragma mark ==获取验证码==
-(void)getCode{
    if (self.tempTimer) {
        [ZQLoadingView showAlertHUD:@"请稍后获取" duration:2];
        return;
    }
    if (_mobile.length) {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:2];
        return;
    }
     NSString *urlStr = [NSString stringWithFormat:@"http://qishou.sztd123.com/index.php/Api/User/Verificationcode?phone=%@",_mobile];
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.verify = jsonDic[@"msg"][@"code"];
                //            [strongSelf.codeBtn setBackgroundColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1.0]];
                strongSelf.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(numTiming:) userInfo:nil repeats:YES];
            }
        }
    } failure:^(NSError *error) {
        [ZQLoadingView showAlertHUD:@"请求失败" duration:2.0];

    } animated:YES];
}
- (void)numTiming:(NSTimer *)sTimer
{
    if (temp == 0) {
        [sTimer invalidate];
        self.tempTimer = nil;
        temp = 60;
        [_codeBtn setUserInteractionEnabled:YES];
//        [_codeBtn setBackgroundColor:[UIColor colorWithRed:0x41/255.0 green:0xc9/255.0 blue:0xdc/255.0 alpha:1.0]];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重发",temp--] forState:UIControlStateNormal];
    }
}
#pragma mark ==UITextFiledDelegate==
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
        {
            _mobile = textField.text;
            if (![self checkPhone]) {
                [ZQLoadingView showAlertHUD:@"手机号码格式不对，请重新输入" duration:1.5];
            }
            break;
        }
        case 1:
        {
            rIsVerify = [_verify isEqualToString:textField.text];
            if (!rIsVerify) {
                [ZQLoadingView showAlertHUD:@"验证码输入错误" duration:2.5];
            }
        }
            break;
        case 2:
        {
            _passWord = textField.text;

        }
            break;
        default:
            break;
    }
    return YES;
}

-(void)changeFrame:(CGFloat)height{
    _backV.transform = CGAffineTransformMakeTranslation(0, height);
}


- (BOOL)checkPhone {
    NSString *phoneTest = @"^1[0-9]{10}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneTest];
    if ([mobileTest evaluateWithObject:_mobile]) {
        return YES;
    }else{
        return NO;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.tempTimer) {
        [self.tempTimer invalidate];
        self.tempTimer = nil;
    }
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
