//
//  ZQViolationViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQViolationViewController.h"
#import "ZQAreaView.h"
#import "ZQAreaModel.h"
#import "ZQLoadingView.h"
#import "ZQChoosePickerView.h"

@interface ZQViolationViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityCode;
@property (weak, nonatomic) IBOutlet UITextField *carCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *carTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *engineCodeTf;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn1;
@property (weak, nonatomic) IBOutlet UITextField *cardCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *driveCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn2;
@property (weak, nonatomic) IBOutlet UIScrollView *scollView;

@property (nonatomic, strong) ZQAreaView *areaView;
@property (nonatomic, strong) ZQAreaModel *provinceModel;

@property(strong,nonatomic) ZQChoosePickerView *pickView;
@end

@implementation ZQViolationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

-(void)viewDidLayoutSubviews {
    self.scollView.contentSize = CGSizeMake(KWidth, 677);
}

-(void)setupViews {
    
    self.title = @"违章查询";
    self.searchBtn1.layer.cornerRadius = 5;
    self.searchBtn2.layer.cornerRadius = 5;
    
    UIImage *image = [UIImage imageNamed:@"downArrow"];
    [self.provinceBtn setImage:image forState:UIControlStateNormal];
    self.provinceBtn.layer.borderWidth = 1;
    self.provinceBtn.layer.cornerRadius = 4;
    [self.provinceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [self.provinceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    
    [self.cityCode setImage:image forState:UIControlStateNormal];
    self.cityCode.layer.borderWidth = 1;
    self.cityCode.layer.cornerRadius = 4;
    [self.cityCode setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [self.cityCode setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    
    self.carTypeBtn.layer.borderWidth = 1;
    self.carTypeBtn.layer.cornerRadius = 4;
    [self.carTypeBtn setImage:image forState:UIControlStateNormal];
    [self.carTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [self.carTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, -65)];
}
//机动车违法信息查询
- (IBAction)vehicleAgainstTheLow:(id)sender {
    [self.view endEditing:YES];
    NSString *carCodeStr = [self.carCodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!carCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入车牌号码" duration:SXLoadingTime];
        return;
    }
    carCodeStr = [NSString stringWithFormat:@"%@%@%@",self.provinceBtn.titleLabel.text,self.cityCode.titleLabel.text,carCodeStr];
    NSInteger carType = 1;
    if ([self.carTypeBtn.titleLabel.text rangeOfString:@"大"].location != NSNotFound) {
        carType = 3;
    }
    if ([self.carTypeBtn.titleLabel.text rangeOfString:@"中"].location != NSNotFound) {
        carType = 2;
    }
    NSString *engineCodeStr = [self.engineCodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!engineCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入识别码后4位" duration:SXLoadingTime];
        return;
    }
    //机动车违法信息查询接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/Violation_inquiry/u_id/%@/car_number/%@/type/%ld/last_number/%@",[Utility getUserID],carCodeStr,(long)carType,engineCodeStr];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf performSelector:@selector(backAction) withObject:nil afterDelay:3.0];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];

}
//驾驶证违法信息查询
- (IBAction)licenseAgainstTheLow:(id)sender {
    [self.view endEditing:YES];
    NSString *cardCodeStr = [self.cardCodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!cardCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入身份证号" duration:SXLoadingTime];
        return;
    }
    NSString *driveCodeStr = [self.driveCodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!driveCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入驾驶证档案编号" duration:SXLoadingTime];
        return;
    }
    //驾驶证违法信息查询
    NSString *urlStr = [NSString stringWithFormat:@"daf/li_inquiry/u_id/%@/license_number/%@/id_number/%@",[Utility getUserID],cardCodeStr,driveCodeStr];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf performSelector:@selector(backAction) withObject:nil afterDelay:3.0];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];

}

- (IBAction)shortNumBtnAction:(id)sender {
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
        [self.view endEditing:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:[Utility getProvinceShortNum] inView:self.view chooseBackBlock:^(NSString *seletedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (seletedStr) {
                [strongSelf.provinceBtn setTitle:seletedStr forState:UIControlStateNormal];
            }
        }
    }];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)characterBtnAction:(id)sender {
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
        [self.view endEditing:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"] inView:self.view chooseBackBlock:^(NSString *seletedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (seletedStr) {
                 [strongSelf.cityCode setTitle:seletedStr forState:UIControlStateNormal];
            }
        }
    }];
}
- (IBAction)carTypeBtnAction:(id)sender {
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
        [self.view endEditing:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:@[@"小型汽车",@"中型汽车",@"大型汽车"] inView:self.view chooseBackBlock:^(NSString *seletedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (seletedStr) {
                [strongSelf.carTypeBtn setTitle:seletedStr forState:UIControlStateNormal];
            }
        }
    }];
}


- (void)showPickViewWithTextField:(UITextField *)textField
{
    if (_areaView) {
        [_areaView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_areaView removeFromSuperview];
        self.areaView = nil;
    }
    [self.view endEditing:YES];
    NSString *pId = nil;
    if ([textField isEqual:self.carCodeTf]) {
        pId = @"-1"; //展示省的简称
    }
    else
    {
//        if (self.provinceModel&&[textField isEqual:self.cityTf]) {
//            pId = self.provinceModel.areaId;
//        }
    }
//    __weak __typeof(self) weakSelf = self;
    __weak UITextField *wTextField = textField;
    _areaView = [[ZQAreaView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-230, __kWidth, 230) provinceId:pId];
    _areaView.handler = ^(ZQAreaModel *areaModel)
    {
        if (areaModel) {
            wTextField.text = areaModel.areaName;
//            if ([wTextField isEqual:weakSelf.provinceTf]) {
//                weakSelf.provinceModel = areaModel;
//            }
        }
    };
    [self.view addSubview:_areaView];
}
#pragma mark -UITextFieldDelegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
//    if ([textField isEqual:self.provinceTf]) {
//        [self showPickViewWithTextField:textField];
//        return NO;
//    }
//    if ([textField isEqual:self.cityTf]) {
//        if (self.provinceModel) {
//            [self showPickViewWithTextField:textField];
//        }
//        else
//        {
//            [ZQLoadingView showAlertHUD:@"请选择省份" duration:SXLoadingTime];
//            
//        }
//        return NO;
//    }
//    if ([textField isEqual:self.carProvinceTf]) {
//        if (textField.text.length) {
//            return YES;
//        }
//        [self showPickViewWithTextField:textField];
//        return NO;
//    }
    return YES;
}

-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
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
