//
//  ZQUpSubdataViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQUpSubdataViewController.h"

@interface ZQUpSubdataViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeight;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *carCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *carShapeTf;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *carFrontImg;
@property (weak, nonatomic) IBOutlet UIImageView *carBackImg;
@property (weak, nonatomic) IBOutlet UIImageView *insuranceImg;

@end

@implementation ZQUpSubdataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传预约资料";
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)sendAction:(id)sender {
    
    
    
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
