//
//  YSLoginViewController.m
//  shopsN
//
//  Created by imac on 2016/12/5.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "ZQLoginViewController.h"
#import "ZQRegisterViewController.h"
#import "YFoundPasswordViewController.h"
#import "ZQSmsLoginViewController.h"

#import "YshareChooseView.h"

#import "JPUSHService.h"

@interface  ZQLoginViewController()<UITextFieldDelegate,YshareChooseViewDelegate>

@property (strong,nonatomic) UIScrollView *backV;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *passWord;

@end

@implementation ZQLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _name = @"";
    _passWord = @"";
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
    cancelBtn.titleLabel.font = MFont(14);
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
//    [cancelBtn setTitleColor:LH_RGBCOLOR(153, 153, 153) forState:BtnNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:BtnNormal];
    [cancelBtn addTarget:self action:@selector(back) forControlEvents:BtnTouchUpInside];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake((__kWidth-150)/2, 32, 150, 20)];
    [NaviV addSubview:titleLb];
    titleLb.textAlignment =NSTextAlignmentCenter;
    titleLb.font = BFont(18);
    titleLb.textColor = __DTextColor;
//    titleLb.text = [NSString stringWithFormat:@"CarCheck账户登录"];
    titleLb.text = @"登陆";
}

- (void)initView{
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor whiteColor];
    [self.view sendSubviewToBack:_backV];
    _backV.contentSize = CGSizeMake(__kWidth, 606);
    
    //main
    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-221)/2, 75, 221, 28)];
    [_backV addSubview:loginIV];
    loginIV.image =MImage(@"CJWY");
//    loginIV.image = MImage(@"appIcon");
    loginIV.contentMode = UIViewContentModeScaleAspectFit;
    
    NSArray *imageArr = @[@"login_user",@"login_password"];
    for (int i=0; i<2; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, 30+CGRectYH(loginIV)+60*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor = MainBgColor;
        putV.layer.cornerRadius = 5;
        
        UIImageView *headIV = [[UIImageView alloc]init];
        [putV addSubview:headIV];
        headIV.image = MImage(imageArr[i]);
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, __kWidth-140, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i;
        inputTF.delegate = self;
        inputTF.textAlignment = NSTextAlignmentLeft;
        if (!i) {
            headIV.frame = CGRectMake(11, 11, 24, 24);
            inputTF.placeholder = @"手机号";
        }else{
            headIV.frame = CGRectMake(11, 11, 24, 24);
            inputTF.placeholder = @"请输入密码...";
            inputTF.secureTextEntry = YES;
        }
    }
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectYH(loginIV)+170, __kWidth-60, 56)];
    [_backV addSubview:loginBtn];
    loginBtn.backgroundColor = __DefaultColor;
    loginBtn.layer.cornerRadius = 28;
    loginBtn.titleLabel.font = MFont(18);
    [loginBtn setTitle:@"登录" forState:BtnNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [loginBtn addTarget:self action:@selector(Login) forControlEvents:BtnTouchUpInside];
    
    UIButton *cannotBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectYH(loginBtn)+10, (__kWidth-80)/2, 20)];
    [_backV addSubview:cannotBtn];
    cannotBtn.titleLabel.font = MFont(15);
    cannotBtn.backgroundColor = [UIColor clearColor];
    [cannotBtn setTitle:@"无法登录?" forState:BtnNormal];
    [cannotBtn setTitleColor:__TextColor forState:BtnNormal];
    [cannotBtn addTarget:self action:@selector(cannotLogin) forControlEvents:BtnTouchUpInside];
    
    UIImageView *lineIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-2)/2, CGRectYH(loginBtn)+15, 2, 14)];
    [_backV addSubview:lineIV];
    lineIV.backgroundColor = __BackColor;
    
    UIButton *logonBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth/2+20, CGRectYH(loginBtn), (__kWidth-80)/2, 40)];
    [_backV addSubview:logonBtn];
    logonBtn .titleLabel.font = MFont(15);
    logonBtn.backgroundColor =[UIColor clearColor];
    [logonBtn setTitle:@"现在注册 >" forState:BtnNormal];
    [logonBtn setTitleColor:__DefaultColor forState:BtnNormal];
    [logonBtn addTarget:self action:@selector(Logon) forControlEvents:BtnTouchUpInside];
    
    YshareChooseView *shareV = [[YshareChooseView alloc]initWithFrame:CGRectMake(0, CGRectYH(logonBtn)+60, __kWidth, 110)];
    shareV.hidden = YES;
    [_backV addSubview:shareV];
    shareV.delegate =self;
    
    
    
}

-(void)goBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ==登录==
-(void)Login{
    [self.view endEditing:YES];
    if (!_name.length) {
        [ZQLoadingView showAlertHUD:@"请输入您的手机号" duration:2.0];
        return;
    }
    if (!_passWord.length) {
        [ZQLoadingView showAlertHUD:@"请输入密码" duration:2.0];
        return;
    }
    //登录接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/my_Login/phone/%@/password/%@",_name,_passWord];
    
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [Utility saveUserInfo:jsonDic];
            }
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            //    给推送注册别名
//            [JPUSHService setAlias:@"" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//            } seq:5];
        }
    } failure:^(NSError *error) {

    } animated:YES];
}

-(void)getUserinfo {
    
//    NSMutableDictionary *tepDict = [NSMutableDictionary dictionary];
//    [tepDict setObject:_name forKey:@"username"];
//    NSString *dict = [YSParseTool jsonDict:tepDict];
//    NSString *controller = @"User";
//    NSString *method = @"getUserInfoByUsername";
//    NSString *common_param = dict;
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:controller forKey:@"controller"];
//    [param setObject:method forKey:@"method"];
//    [param setObject:common_param forKey:@"common_param"];
//
//    [JKHttpRequestService POST:@"?" withParameters:param success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        NSDictionary *dic = jsonDic[@"data"][@"niu_reponse"];
//        if ([jsonDic[@"message"] isEqualToString:@"success"]) {
//
//            [UdStorage storageObject:dic[@"user_name"] forKey:UserName];
//            [UdStorage storageObject:dic[@"app_user_type"] forKey:UserType];
//            [UdStorage storageObject:[NSString stringWithFormat:@"%@",dic[@"uid"]] forKey:Userid];
//            //            [SXLoadingView showAlertHUD:message duration:SXLoadingTime];
//        }else{
//            [SXLoadingView showAlertHUD:[jsonDic[@"data"] valueForKey:@"message"] duration:SXLoadingTime];
//        }
//    } failure:^(NSError *error) {
//
//    } animated:NO];
    
}

#pragma mark ==无法登录==
-(void)cannotLogin{
    NSLog(@"无法登录？");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"短信验证登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"短信登录");
        ZQSmsLoginViewController *vc = [[ZQSmsLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"找回密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"找回密码");
        YFoundPasswordViewController *vc = [[YFoundPasswordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ==注册==
-(void)Logon{
    ZQRegisterViewController *vc = [[ZQRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==YshareChooseViewDelegate==
-(void)chooseShare:(NSInteger)sender{
//    switch (sender) {
//        case 0:
//        {
//            [ShareSDK getUserInfo:SSDKPlatformTypeQQ
//                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//             {
//                 if (state == SSDKResponseStateSuccess)
//                 {
//
//                     NSLog(@"uid=%@",user.uid);
//                     NSLog(@"%@",user.credential);
//                     NSLog(@"token=%@",user.credential.token);
//                     NSLog(@"nickname=%@",user.nickname);
//                     [self threeLogin:@{@"type":@"1",@"accout":user.uid}];
//                 }
//
//                 else
//                 {
//                     NSLog(@"%@",error);
//                 }
//
//             }];
//        }
//            break;
//        case 1:
//        {
//            [ShareSDK getUserInfo:SSDKPlatformTypeWechat
//                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//             {
//                 if (state == SSDKResponseStateSuccess)
//                 {
//
//                     NSLog(@"uid=%@",user.uid);
//                     NSLog(@"%@",user.credential);
//                     NSLog(@"token=%@",user.credential.token);
//                     NSLog(@"nickname=%@",user.nickname);
//                     [self threeLogin:@{@"type":@"2",@"accout":user.uid}];
//                 }
//
//                 else
//                 {
//                     NSLog(@"%@",error);
//                 }
//
//             }];
//        }
//            break;
//            //        case 2:
//            //        {
//            //            [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
//            //                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//            //             {
//            //                 if (state == SSDKResponseStateSuccess)
//            //                 {
//            //
//            //                     NSLog(@"uid=%@",user.uid);
//            //                     NSLog(@"%@",user.credential);
//            //                     NSLog(@"token=%@",user.credential.token);
//            //                     NSLog(@"nickname=%@",user.nickname);
//            //                     #pragma mark ==该处新浪微博登录需要后台根据API重写接口==
//            //                     [self threeLogin:@{@"type":@"3",@"accout":@""}];
//            //                 }
//            //
//            //                 else
//            //                 {
//            //                     NSLog(@"%@",error);
//            //                 }
//            //
//            //             }];
//            //        }
//            //            break;
//        default:
//            break;
//    }
}


#pragma mark ==UITextFiledDelegate==
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag) {
        _passWord = textField.text;
    }else{
        _name = textField.text;
    }
    return YES;
}

#pragma mark ==跳转第三方==
- (void)threeLogin:(NSDictionary*)paramas{
//    [JKHttpRequestService POST:@"Register/otherLogin" withParameters:paramas success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        if (succe) {
//            NSDictionary *dic =jsonDic[@"data"];
//            EMError *error = nil;
//            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:dic[@"mobile"] password:dic[@"mobile"] completion:^(NSDictionary *loginInfo, EMError *error) {
//                if (!error.errorCode) {
//                    NSLog(@"登录成功");
//                    [UdStorage storageObject:dic[@"mobile"] forKey:UserName];
//                    [UdStorage storageObject:dic[@"app_user_id"] forKey:Userid];
//                    [UdStorage storageObject:dic[@"app_user_type"] forKey:UserType];
//                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }else{
//                    NSLog(@"%@%ld",error.description,(long)error.errorCode);
//                }
//                
//            } onQueue:nil];
//        }else{
//            YSThreePinlessViewController *vc = [[YSThreePinlessViewController alloc]init];
//            vc.type =paramas[@"type"];
//            vc.accout = paramas[@"accout"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    } failure:^(NSError *error) {
//        
//    } animated:NO];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleDefault;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

