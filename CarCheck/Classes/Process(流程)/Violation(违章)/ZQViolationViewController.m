//
//  ZQViolationViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQViolationViewController.h"

@interface ZQViolationViewController ()

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

@end

@implementation ZQViolationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)seachAction:(id)sender {
    
    
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
