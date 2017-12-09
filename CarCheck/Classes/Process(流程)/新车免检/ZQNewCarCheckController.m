//
//  ZQNewCarCheckController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNewCarCheckController.h"
#import "ZQVioUpTableViewCell.h"
#import "ZQChoosePickerView.h"
#import "ZQHtmlViewController.h"
#import "YPayViewController.h"

@interface ZQNewCarCheckController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZQVioUpTableViewCellDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *titleArray;
@property (strong,nonatomic) NSArray *placeArray;
@property (strong,nonatomic) NSMutableArray *contentArray;

@property (strong,nonatomic) ZQChoosePickerView *pickView;

@property (copy, nonatomic) NSString *shortNumStr;
@end

@implementation ZQNewCarCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shortNumStr = @"冀";
    self.title = @"新车免检预约";
    [self setupData];
    [self initViews];
}
-(void)setupData {
    _titleArray = @[@"车主姓名",@"手机号码",@"车辆号码",@"收货地址"];
    _placeArray = @[@"请输入车主姓名",@"请输入手机号码",@"请输入车辆号码",@"请输入详细的收货地址"];
    _contentArray = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
}
-(void)initViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height-50) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZQVioUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZQVioUpTableViewCell_id"];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 180)];
    self.tableView.tableFooterView = footView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.frame)-40, 120)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = __TextColor;
//    label.textColor = [UIColor lightTextColor];
    label.text = @"*将办理免检所需资料邮寄至\n邢台市桥西区中兴西大街\n居然空间写字楼617室\n*我们将在收到资料后2-3个工作日\n办理完成并寄出";
//    服务热线：4008769838
//    self.tableView.tableFooterView = label;
    [footView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, CGRectGetMaxY(label.frame)+10, 80, 30)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor darkTextColor];
    label.text = @"服务热线: ";
    [footView addSubview:label];
    
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),CGRectGetMinY(label.frame),120, 30)];
    phoneBtn.titleLabel.font = MFont(18);
    [phoneBtn setTitle:[Utility getServerPhone] forState:BtnNormal];
    [phoneBtn setTitleColor:__DefaultColor forState:BtnNormal];
//    [phoneBtn setTitleColor:[UIColor blueColor] forState:BtnNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnAction) forControlEvents:BtnTouchUpInside];
    [footView addSubview:phoneBtn];

    
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.view.frame), 50)];
    _putBtn.backgroundColor = __DefaultColor;
    _putBtn.titleLabel.font = MFont(18);
    
    if ([Utility getIs_vip]) {
        NSString *title = [NSString stringWithFormat:@"提交订单 (服务费: %@元)",[Utility getNewCarServiceOutlay_VIP]];
        UIImage * image=[UIImage imageNamed:@"VIP_logo"];
        [_putBtn setImage:image forState:UIControlStateNormal];
        [_putBtn setTitle:title forState:BtnNormal];
    }
    else
    {
        [_putBtn setTitle:[NSString stringWithFormat:@"提交订单 (服务费: %@元)",[Utility getNewCarServiceOutlay]] forState:BtnNormal];
    }
    [_putBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [_putBtn addTarget:self action:@selector(commitInformation) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:_putBtn];
}
//提交订单
- (void)commitInformation
{
    NSString *nameStr = [self.contentArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!nameStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入车主姓名" duration:SXLoadingTime];
        return;
    }
    NSString *phoneStr = [self.contentArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!phoneStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入手机号码" duration:SXLoadingTime];
        return;
    }
    NSString *carCardStr = [self.contentArray[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!carCardStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入车牌号码" duration:SXLoadingTime];
        return;
    }
    carCardStr = [NSString stringWithFormat:@"%@%@",self.shortNumStr,carCardStr];
    NSString *addressStr = [self.contentArray[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!addressStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入收货地址" duration:SXLoadingTime];
        return;
    }
    //新车免检预约接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/new_car_reservation/u_id/%@/u_name/%@/u_phone/%@/u_car_card/%@/address/%@",[Utility getUserID],nameStr,phoneStr,carCardStr,addressStr];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                YPayViewController *payVC = [[YPayViewController alloc] init];
//                payVC.payMoney = [Utility getNewCarServiceOutlay];
                payVC.payMoney = jsonDic[@"money"];
                payVC.orderNo = jsonDic[@"order_no"];
                payVC.aPayType = ZQPayNewCarView;
                [strongSelf.navigationController pushViewController:payVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}
- (void)phoneBtnAction
{
    NSString *phoneStr = [Utility getServerPhone];
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
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.contentArray[textField.tag] = textField.text;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
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

-(void)back{
    UIViewController *htmlVc = self.navigationController.viewControllers[1];
    if ([htmlVc isKindOfClass:[ZQHtmlViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
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
