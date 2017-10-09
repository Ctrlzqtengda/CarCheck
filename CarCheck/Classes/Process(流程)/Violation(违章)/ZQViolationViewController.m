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
    [self setupViews];
}

-(void)setupViews {
    
    self.title = @"违章查询";
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
