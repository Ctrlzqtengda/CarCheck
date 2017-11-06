//
//  ZQUpSubdataViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQUpSubdataViewController.h"
#import "ZQSubTimeViewController.h"
#import "UITextField+ZQTextField.h"
#import "ZQChoosePickerView.h"

@interface ZQUpSubdataViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextFieldDelegate> {
    
    UIImageView *_tempImgView;
    NSArray *_pickerDataArray;
    
}
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
@property (weak, nonatomic) IBOutlet UIScrollView *scollView;
@property(strong,nonatomic) ZQChoosePickerView *pickView;

@end

@implementation ZQUpSubdataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传预约资料";
    [self setupData];
    [self setupViews];
    
    // Do any additional setup after loading the view from its nib.
}

-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
}

-(void)viewDidLayoutSubviews {
    self.scollView.contentSize = CGSizeMake(KWidth, 677);
}

- (IBAction)sendAction:(id)sender {
    
    ZQSubTimeViewController *subVC = [[ZQSubTimeViewController alloc] initWithNibName:@"ZQSubTimeViewController" bundle:nil];
    [self.navigationController pushViewController:subVC animated:YES];
    
}

-(void)setupData {
    
    _pickerDataArray = @[@"大型车 300元",@"中型车 200元",@"小型车 100元"];
    
}

-(void)setupViews {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView.image = [UIImage imageNamed:@"down2"];
    self.carShapeTf.rightView = imageView;
    self.carShapeTf.rightViewMode = UITextFieldViewModeAlways;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    [self.imageView addGestureRecognizer:tap1];
    [self.carFrontImg addGestureRecognizer:tap2];
    [self.carBackImg addGestureRecognizer:tap3];
    [self.insuranceImg addGestureRecognizer:tap4];
    
    self.imageView.userInteractionEnabled = YES;
    self.carFrontImg.userInteractionEnabled = YES;
    self.carBackImg.userInteractionEnabled = YES;
    self.insuranceImg.userInteractionEnabled = YES;
    
}

#pragma mark 私有方法

-(void)chooseImageAction:(UITapGestureRecognizer *)sender {
    
    _tempImgView = (UIImageView *)sender.view;
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    //想要知道选择的图片
    pickerVC.delegate = self;
    //开启编辑状态
    pickerVC.allowsEditing = YES;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSLog(@"%@",info);
    [_tempImgView setImage:info[UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.carShapeTf) {
        [self showChooseCarshapeView];
        return NO;
    }else{
        return YES;
    }
    
}

-(void)showChooseCarshapeView {
    
    [self.pickView showWithDataArray:_pickerDataArray inView:self.view chooseBackBlock:^(NSInteger index) {
        self.carShapeTf.text = _pickerDataArray[index];
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
    
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
