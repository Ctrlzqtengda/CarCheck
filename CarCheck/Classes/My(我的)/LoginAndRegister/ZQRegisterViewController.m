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

@property (strong,nonatomic) UIScrollView *backV;

@property (strong,nonatomic) NSString *mobile;//手机

@property (strong,nonatomic) NSString *passWord;//密码

@property (strong,nonatomic) NSString *verify;//验证码

@end

@implementation ZQRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
                UIButton *codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-148, 3, 85, 40)];
                [putV addSubview:codeBtn];
                codeBtn.titleLabel.font = MFont(15);
                codeBtn.backgroundColor = [UIColor whiteColor];
                [codeBtn setTitle:@"获取验证码" forState:BtnNormal];
                [codeBtn setTitleColor:__TextColor forState:BtnNormal];
                [codeBtn addTarget:self action:@selector(getCode) forControlEvents:BtnTouchUpInside];
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
    NSLog(@"注册");
    [self.navigationController popViewControllerAnimated:YES];
//    [self.view endEditing:YES];
//    WK(weakSelf)
//    __typeof(&*weakSelf) strongSelf = weakSelf;
//
//    NSString *user_name = _name;
//    NSString *password = _passWord;
//    NSString *email = _email;
//    NSString *mobile = _mobile;
//    NSString *verify = _verify;
//    NSString *re_password = _re_password;
//    NSString *recommend_tel = _referralCode;
//
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:user_name forKey:@"user_name"];
//    [dict setObject:password forKey:@"password"];
//    [dict setObject:email forKey:@"email"];
//    [dict setObject:mobile forKey:@"mobile"];
//    [dict setObject:verify forKey:@"verify"];
//    [dict setObject:re_password forKey:@"re_password"];
//    [dict setObject:recommend_tel forKey:@"recommend_tel"];
//
//    NSString *common_param = [YSParseTool jsonDict:dict];
//    NSString *method = @"registerMember";
//    NSString *controller = @"Member";
//
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:common_param forKey:@"common_param"];
//    [param setObject:method forKey:@"method"];
//    [param setObject:controller forKey:@"controller"];
//
//    [JKHttpRequestService POST:@"?" withParameters:param success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        if (succe) {
//            EMError *error = nil;
//            [[EaseMob sharedInstance].chatManager registerNewAccount:weakSelf.mobile password:weakSelf.mobile error:&error];
//            if (!error.errorCode) {
//                NSLog(@"注册成功");
//                [strongSelf.navigationController popViewControllerAnimated:YES];
//            }else{
//                NSLog(@"%@%ld",error.description,(long)error.errorCode);
//            }
//        }
//    } failure:^(NSError *error) {
//
//    } animated:YES];
    
}


#pragma mark ==获取验证码==
-(void)getCode{
    NSLog(@"获取验证码");
//    [self.view endEditing:YES];
//    if (IsNilString(_name)||IsNilString(_mobile)) {
//        return;
//    }
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
//
//
//    NSString *urlStr = @"http://api.shopsn.net/Register/re_send_msg";
//    [manager POST:urlStr parameters:@{@"user_name":_name,@"mobile":_mobile} progress:^(NSProgress * _Nonnull uploadProgress) {
//        //
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
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
            _verify = textField.text;

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
