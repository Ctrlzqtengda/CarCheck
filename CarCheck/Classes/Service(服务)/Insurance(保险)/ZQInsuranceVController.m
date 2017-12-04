//
//  ZQInsuranceVController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/15.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQInsuranceVController.h"
#import "ZQVioUpTableViewCell.h"
#import "ZQChoosePickerView.h"
//#import "ZQHtmlViewController.h"
//#import "YPayViewController.h"

@interface ZQInsuranceVController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZQVioUpTableViewCellDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *titleArray;
@property (strong,nonatomic) NSArray *placeArray;
@property (strong,nonatomic) ZQChoosePickerView *pickView;

@property (copy, nonatomic) NSString *shortNumStr;
@property (copy, nonatomic) NSString *i_name;
@property (copy, nonatomic) NSString *i_phone;
@property (copy, nonatomic) NSString *i_car_card;

@end

@implementation ZQInsuranceVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shortNumStr = @"冀";
    self.title = @"保险服务";
    [self setupData];
    [self initViews];
}
-(void)setupData {
    _titleArray = @[@"车主姓名",@"手机号码",@"车辆号码"];
    _placeArray = @[@"请输入车主姓名",@"请输入手机号码",@"请输入车辆号码"];
}
-(void)initViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height-50) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZQVioUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZQVioUpTableViewCell_id"];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 140)];
    self.tableView.tableFooterView = footView;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = __DTextColor;
//    label.textColor = [UIColor lightTextColor];
    label.text = @"*资料提交后工作人员将会及时电话回访";
//    self.tableView.tableFooterView = label;
    [footView addSubview:label];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, CGRectGetMaxY(label.frame)+10, 80, 30)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor darkTextColor];
    label.text = @"服务热线: ";
    [footView addSubview:label];
    
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),CGRectGetMinY(label.frame),120, 30)];
    phoneBtn.titleLabel.font = MFont(18);
    [phoneBtn setTitle:@"4008769838" forState:BtnNormal];
    [phoneBtn setTitleColor:LH_RGBCOLOR(17,149,232) forState:BtnNormal];
//    [phoneBtn setTitleColor:[UIColor blueColor] forState:BtnNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnAction) forControlEvents:BtnTouchUpInside];
    [footView addSubview:phoneBtn];
    
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.view.frame), 50)];
    _putBtn.backgroundColor = __DefaultColor;
    _putBtn.titleLabel.font = MFont(18);
    [_putBtn setTitle:@"提交资料" forState:BtnNormal];
    [_putBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [_putBtn addTarget:self action:@selector(commitInformation) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:_putBtn];
}
//提交订单
- (void)commitInformation
{
    NSString *nameStr = [self.i_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!nameStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入车主姓名" duration:SXLoadingTime];
        return;
    }
    NSString *phoneStr = [self.i_phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!phoneStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入手机号码" duration:SXLoadingTime];
        return;
    }
    NSString *carCardStr = [self.i_car_card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!carCardStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入车牌号码" duration:SXLoadingTime];
        return;
    }
    carCardStr = [NSString stringWithFormat:@"%@%@",self.shortNumStr,carCardStr];
    //保险服务接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/insurance_service/u_id/%@/i_name/%@/i_phone/%@/i_car_card/%@",[Utility getUserID],nameStr,phoneStr,carCardStr];
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
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)phoneBtnAction
{
    NSString *phoneStr = @"4008769838";
    NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
    UIApplication * app = [UIApplication sharedApplication];
    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
        [app openURL:[NSURL URLWithString:PhoneStr]];
    }
}
#pragma mark ZQVioUpTableViewCellDelegate
-(void)showChooseView {
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:[Utility getProvinceShortNum] inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                strongSelf.shortNumStr = selectedStr;
                [strongSelf.tableView reloadData];
            }
        }
    }];
    
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //    self.tableView.reloadData;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
        {
            self.i_name = textField.text;
            break;
        }
        case 1:
        {
            self.i_phone = textField.text;
        }
            break;
        case 2:
        {
            self.i_car_card = textField.text;
        }
            break;
        default:
            break;
    }
    return YES;
}
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
    ZqCellType type;
    if (indexPath.row==2) {
        type = ZQVioUpCellType1;
    }
    else
    {
        type = ZQVioUpCellType2;
    }
    cell.contentTf.delegate = self;
    cell.contentTf.tag = indexPath.row;
    //        cell.contentTf.text = _contentArray[indexPath.row];
    cell.delegate = self;
    NSString *title = _titleArray[indexPath.row];
    cell.contentTf.tag = indexPath.row;
    [cell setCellType:type title:title placeText:_placeArray[indexPath.row] provinceCode:self.shortNumStr];
    return cell;
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
