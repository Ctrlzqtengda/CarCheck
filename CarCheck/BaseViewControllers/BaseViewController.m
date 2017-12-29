//
//  BaseViewController.m
//  shopSN
//
//  Created by imac on 15/12/1.
//  Copyright © 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"
#import "ZQLoginViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController
/**
 *  注册通知
 */
-(void)registerNotification{
    
    
    
}


#pragma mark - ==== 页面设置 =====
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addNavigationBar];

}


-(void)addNavigationBar{
//    //返回按钮
//    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
//    [backBtn setBackgroundImage:MImage(@"back") forState:BtnNormal];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:BtnTouchUpInside];
//
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    if (self.navigationController.childViewControllers.count && [self.navigationController.childViewControllers[0] isEqual:self])
    {
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }

    
}

// 检测登录
-(void)checkLogin {
    
    if ([Utility isLogin]) {
        
    }else {
        
        ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
        [self.navigationController presentViewController:loginVC animated:YES completion:^{
            
        }];
        
    }
    
}

/**
 *  返回  调用
 */
-(void)back{
//    NSLog(@"返回前页面");
    
    if (self.navigationController.viewControllers.count>1) {
         [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 *  更多  调用
 */
//-(void)more{
//    
//}
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return  UIStatusBarStyleLightContent;
//}

/**
 *  结束编辑
 */
-(void)allResignFirstResponder{
//    NSLog(@"allResignFirstResponder====");
    
    [self.view endEditing:YES];
}
-(void)dealloc{
//    NSLog(@"界面销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
