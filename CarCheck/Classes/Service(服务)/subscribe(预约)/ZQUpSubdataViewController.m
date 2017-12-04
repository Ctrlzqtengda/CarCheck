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
#import "ZQHtmlViewController.h"
#import <Masonry.h>

@interface ZQUpSubdataViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextFieldDelegate>

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
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (strong,nonatomic) ZQChoosePickerView *pickView;

@property (strong,nonatomic) UIImageView *tempImgView;
@property (strong,nonatomic) NSArray *carTypeArray;
@end

@implementation ZQUpSubdataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传预约资料";
    [self setupViews];
    [self getCarTypeData];
}

- (void)getCarTypeData
{
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"daf/get_car_type" withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:0];
                        for (NSDictionary *dic in array) {
                            [muArray addObject:[NSString stringWithFormat:@"%@ %@元",dic[@"car_name"],dic[@"money"]]];
                        }
                        strongSelf.carTypeArray = muArray;
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    } animated:NO];
}
-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
}

-(void)viewWillLayoutSubviews {
    self.contentSizeHeight.constant = 647;
    self.contentSizeWidth.constant = KWidth;
    self.scollView.contentSize = CGSizeMake(KWidth, 647);
}

- (IBAction)sendAction:(id)sender {
    NSString *carOwner = [self.nameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!carOwner.length) {
        [ZQLoadingView showAlertHUD:@"请输入机动车所有人" duration:SXLoadingTime];
        return;
    }
    NSString *phoneStr = [self.phoneTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!phoneStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:SXLoadingTime];
        return;
    }
    NSString *carCodeStr = [self.carCodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!carCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入车牌号" duration:SXLoadingTime];
        return;
    }
    NSString *carShapeStr = self.carShapeTf.text;
    if (!carShapeStr.length) {
        [ZQLoadingView showAlertHUD:@"请选择车型" duration:SXLoadingTime];
        return;
    }
    UIImage *licenseImage = self.imageView.image;
    if ([licenseImage isEqual:[UIImage imageNamed:@"zhao"]]) {
        [ZQLoadingView showAlertHUD:@"请选择行驶本照片" duration:SXLoadingTime];
        return;
    }
    UIImage *frontImage = self.carFrontImg.image;
    if ([frontImage isEqual:[UIImage imageNamed:@"chooseImg2"]]) {
        [ZQLoadingView showAlertHUD:@"请选择身份证正面照片" duration:SXLoadingTime];
        return;
    }
    UIImage *backImage = self.carBackImg.image;
    if ([backImage isEqual:[UIImage imageNamed:@"chooseImg2"]]) {
        [ZQLoadingView showAlertHUD:@"请选择身份证反面照片" duration:SXLoadingTime];
        return;
    }
    UIImage *insuranceImg = self.insuranceImg.image;
    if ([insuranceImg isEqual:[UIImage imageNamed:@"chooseImg2"]]) {
        [ZQLoadingView showAlertHUD:@"请选择强制照片" duration:SXLoadingTime];
        return;
    }
    
    NSString *moneyStr = @"0";
    if (self.carShapeTf.text) {
        if (self.carShapeTf.text.length) {
            moneyStr = [[self.carShapeTf.text componentsSeparatedByString:@"车"] lastObject];
            moneyStr = [[moneyStr substringToIndex:moneyStr.length-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    //上传预约资料接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/file_upload/u_id/%@/u_name/%@/u_phone/%@/u_car_card/%@/u_car_type/%@/testing_id/%@/type/%ld/inspection_fee/%@/service_charge/%f",[Utility getUserID],carOwner,phoneStr,carCodeStr,carShapeStr,self.b_testing_id,(long)self.bookingType,moneyStr,_serviceCharge];
    NSArray *imageArr = @[UIImageJPEGRepresentation(licenseImage, 0.5),UIImageJPEGRepresentation(frontImage, 0.5),UIImageJPEGRepresentation(backImage, 0.5),UIImageJPEGRepresentation(insuranceImg, 0.5)];
    ZQSubTimeViewController *subVC = [[ZQSubTimeViewController alloc] initWithNibName:@"ZQSubTimeViewController" bundle:nil];
    subVC.requestUrl = urlStr;
    subVC.uploadImageArr = imageArr;
    subVC.uploadImageArr = @[UIImageJPEGRepresentation(licenseImage, 0.5),UIImageJPEGRepresentation(frontImage, 0.5),UIImageJPEGRepresentation(backImage, 0.5),UIImageJPEGRepresentation(insuranceImg, 0.5)];
    if (self.serviceCharge>0) {
        subVC.serviceChargeMoney = _serviceCharge;
    }
    subVC.costMoney = moneyStr;
    [self.navigationController pushViewController:subVC animated:YES];
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
    (void)(pickerVC.videoQuality = UIImagePickerControllerQualityTypeLow),           // 最低的质量,适合通过蜂窝网络传输
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//    NSLog(@"%@",info);
//    [_tempImgView setImage:info[UIImagePickerControllerOriginalImage]];
    [_tempImgView setImage:info[UIImagePickerControllerEditedImage]];
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
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    if (self.carTypeArray) {
        if (self.carTypeArray.count) {
            __weak typeof(self) weakSelf = self;
            [self.pickView showWithDataArray:self.carTypeArray inView:self.view chooseBackBlock:^(NSString *seletedStr) {
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    if (seletedStr) {
                        strongSelf.carShapeTf.text = seletedStr;
                    }
                }
            }];
        }
    }
    else
    {
        [self getCarTypeData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
    
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    for (UITouch *touch in touches) {
//        NSLog(@"--------%@",NSStringFromCGPoint([touch locationInView:self.scollView]));
//    }
//    NSLog(@"+++++++++%@",NSStringFromCGRect(self.ensureBtn.frame));
//
//}

//-(void)back{
//    UIViewController *htmlVc = self.navigationController.viewControllers[1];
//    if ([htmlVc isKindOfClass:[ZQHtmlViewController class]]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

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
