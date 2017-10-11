//
//  ZQRechargeViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/11.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQRechargeViewController.h"

//#import "YPayCardCell.h"
#import "YPayThreeCell.h"

#import "YOrderSuccessView.h"
#import <Pingpp.h>

@interface ZQRechargeViewController ()<UITableViewDelegate,UITableViewDataSource,YOrderSuccessViewDelegate,UITextFieldDelegate>
{
    BOOL _isPaySuccess;
}
/**金额*/
@property (strong,nonatomic) NSString *payMoney;

@property (strong,nonatomic) UITableView *tableV;

@property (nonatomic) NSInteger chooseIndex;

@property (strong,nonatomic) YOrderSuccessView *successV;

@property (strong,nonatomic) NSArray *imageArr;

@property (strong,nonatomic) NSArray *titleArr;

@property (strong,nonatomic) NSArray *detailArr;
@end

@implementation ZQRechargeViewController

-(void)getData{
    _imageArr = @[@"Payment_zfb",@"Payment_wx"];
    _titleArr = @[@"支付宝支付",@"微信支付"];
    _detailArr = @[@"支付宝安全支付",@"微信安全支付"];
    //    if (IsNilString(_payMoney)||_payMoney.floatValue ==0) {
    //        _payMoney = @"0.00";
    //         [self getSuceessView];
    //         return;
    //    }
    [_tableV reloadData];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayStatus:) name:YSOrderPayStatus object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    _chooseIndex = 1;
    [self initView];
    [self getData];
}

- (void)initView{
    //    _tableV = [[UITableView alloc] initWithFrame];
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-64) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableV];
    _tableV.backgroundColor =  [UIColor whiteColor];
    _tableV.separatorColor = [UIColor clearColor];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 86)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    label.text = @"填写充值金额:";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    [headView addSubview:label];
    
    UITextField *_contactView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 10, CGRectGetWidth(self.view.frame)-CGRectGetMaxX(label.frame)-20, 30)];
    _contactView.backgroundColor = [UIColor whiteColor];
    _contactView.borderStyle = UITextBorderStyleRoundedRect;
    _contactView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contactView.returnKeyType = UIReturnKeyDone;
    _contactView.keyboardType = UIKeyboardTypeNumberPad;
    _contactView.delegate = self;
//    _contactView.placeholder = @"";
    _contactView.font = [UIFont systemFontOfSize:14];
    _contactView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [headView addSubview:_contactView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+20, 150, 20)];
    label.text = @"选择充值方式:";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    [headView addSubview:label];
    
    self.tableV.tableHeaderView = headView;
}

- (void)chooseRight{
    //    YAllOrderViewController *vc = [[YAllOrderViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ==UITableViewDelegate==
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YPayThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YPayThreeCell"];
    if (!cell) {
        cell = [[YPayThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YPayThreeCell"];
    }
    cell.title = _titleArr[indexPath.row];
    cell.detail = _detailArr[indexPath.row];
    cell.imageName = _imageArr[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_payMoney.floatValue>0) {
        if (indexPath.row==0) {
            
            //            [SXLoadingView showAlertHUD:@"暂不支持支付宝支付" duration:SXLoadingTime];
            return;
            [Pingpp createPayment:nil appURLScheme:nil withCompletion:^(NSString *result, PingppError *error) {
                
            }];
        }else if(indexPath.row==1){
            [Pingpp createPayment:nil appURLScheme:nil withCompletion:^(NSString *result, PingppError *error) {
                
            }];
            //            [JKPayTool payOrderWxOrderId:_orderId title:_orderName price:_payMoney complete:^{
            //                 NSLog(@"微信");
            //            }];
            //            [JKPayTool payOrderWxOrderId:_orderId title:_orderName price:_payMoney complete:^{
            //                NSLog(@"微信");
            //            } controller:self];
        }
    }else{
        //        [SXLoadingView showAlertHUD:@"已支付成功" duration:SXLoadingTime];
    }
}



-(void)getSuceessView{
//    _isPaySuccess = YES;
    [self.view addSubview:self.successV];
    [self.view bringSubviewToFront:self.successV];
    
}

-(void)choosePay {
    
}

#pragma mark ==YOrderSuccessViewDelegate==
-(void)makelookOrder{
    [_successV removeFromSuperview];
    //    YOrdersDetailViewController *vc = [[YOrdersDetailViewController alloc]init];
    //    vc.status = @"待处理";
    //    vc.orderId = _orderId;
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ==懒加载==
-(YOrderSuccessView *)successV{
    if (!_successV) {
        _successV = [[YOrderSuccessView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-64)];
        //        _successV.name = _addressModel.name;
        //        _successV.address = [NSString stringWithFormat:@"%@%@%@%@",_addressModel.province,_addressModel.city,_addressModel.area,_addressModel.Address];
        //        _successV.address = _addressModel.address_info;
        _successV.money = _payMoney;
        _successV.delegate = self;
    }
    return _successV;
}

- (void)getPayStatus:(NSNotification *)info {
    [self getSuceessView];
}

-(void)back{
    
    if (_isPaySuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
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
