//
//  ZQMyMoneyViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/10.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyMoneyViewController.h"
#import "UIButton+UIButtonExt.h"
#import "ZQRechargeViewController.h"
#import "ZQWalletDetailController.h"

@interface ZQMyMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *totalMoneyL;
@property (strong, nonatomic) UILabel *usableL;
@property (strong, nonatomic) UILabel *pendingReturnL;
@property (copy, nonatomic) NSString *integral;
@end

@implementation ZQMyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.integral = @"0";
    [self.view addSubview:self.tableView];
    [self configTableHeadView];
    [self cofigTableHeadBottomView];
    
    [self getMyMoney];
}
- (void)getMyMoney
{
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_uid_money/u_id/%@",[Utility getUserID]];
    
    //我的消息接口
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        NSDictionary *dic = array[0];
                        [strongSelf.totalMoneyL setText:dic[@"total_assets"]];
                        [strongSelf.usableL setText:dic[@"balance"]];
                        [strongSelf.pendingReturnL setText:dic[@"wait_balance"]];
                        NSString *integral = dic[@"integral"];
                        if (integral.integerValue>0) {
                            strongSelf.integral = integral;
                        }
                    }
                }
            }
        }
    } failure:^(NSError *error) {
       
    } animated:YES];
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [self.totalMoneyL setText:@"0"];
//    [self.usableL setText:@"0"];
//    [self.pendingReturnL setText:@"0"];
//}

//钱包充值
- (void)walletRechargeBtnAction
{
    ZQRechargeViewController *Vc = [[ZQRechargeViewController alloc] init];
    [self.navigationController pushViewController:Vc animated:YES];

}
//钱包明细
- (void)walletDetailsBtnAction
{
    ZQWalletDetailController *Vc = [[ZQWalletDetailController alloc] init];
    [self.navigationController pushViewController:Vc animated:YES];
}
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletMoney"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"walletMone"];
//        cell.textLabel.textColor = [UIColor darkTextColor];
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
//        cell.detailTextLabel.textColor = [UIColor brownColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    cell.imageView.image = [UIImage imageNamed:@"icon29"];
//    cell.textLabel.text = @"套餐充值";
//    cell.detailTextLabel.text = @"低至88折，更有高频返现";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletMoney"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"walletMone"];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor brownColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image = [UIImage imageNamed:@"icon29"];
    cell.textLabel.text = @"我的积分";
    cell.detailTextLabel.text = self.integral;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 286-50)];
        headView.backgroundColor = [UIColor whiteColor];
        [_tableView setTableHeaderView:headView];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
        footView.backgroundColor = [UIColor whiteColor];
        [_tableView setTableFooterView:footView];
    }
    return _tableView;
}

- (void)configTableHeadView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 216)];
    bgView.backgroundColor = LH_RGBCOLOR(17,149,232);
    [self.tableView.tableHeaderView addSubview:bgView];
    
    [bgView addSubview:self.totalMoneyL];
    UILabel *label = [self creatLabel];
    [label setFrame:CGRectMake(CGRectGetMinX(_totalMoneyL.frame), CGRectGetMaxY(_totalMoneyL.frame), CGRectGetWidth(_totalMoneyL.frame), 20)];
    [label setText:@"总资产(元)"];
    [bgView addSubview:label];
    
    [bgView addSubview:self.usableL];
    label = [self creatLabel];
    [label setFrame:CGRectMake(CGRectGetMinX(_usableL.frame), CGRectGetMaxY(_usableL.frame), CGRectGetWidth(_usableL.frame), 20)];
    [label setText:@"可用余额"];
    [bgView addSubview:label];
    
    [bgView addSubview:self.pendingReturnL];
    label = [self creatLabel];
    [label setFrame:CGRectMake(CGRectGetMinX(_pendingReturnL.frame), CGRectGetMaxY(_pendingReturnL.frame), CGRectGetWidth(_pendingReturnL.frame), 20)];
    [label setText:@"待返还金额"];
    [bgView addSubview:label];
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_usableL.frame)-1, CGRectGetMinY(_usableL.frame)+8, 1, 20)];
    [vLine setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:vLine];
}
- (UILabel *)creatLabel
{
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    return label;
}

- (void)cofigTableHeadBottomView
{
    CGFloat height = 82;
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(16, 162, CGRectGetWidth(self.view.frame)-32, height)];
    bottomV.layer.cornerRadius = 6;
//    bottomV.layer.masksToBounds = YES;
    [bottomV setBackgroundColor:LH_RGBCOLOR(238,247,255)];
    [self.tableView.tableHeaderView addSubview:bottomV];
    
    CGFloat width = CGRectGetWidth(bottomV.frame)/2;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, width, height)];
    [button setImage:[UIImage imageNamed:@"walletRecharge"] forState:UIControlStateNormal];
    [button setTitle:@"钱包充值" forState:UIControlStateNormal];
    [button setTitleColor:__TextColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button centerImageAndTitle];
    [button addTarget:self action:@selector(walletRechargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(width, 0, width, height)];
    [button setImage:[UIImage imageNamed:@"walletDetails"] forState:UIControlStateNormal];
    [button setTitle:@"钱包明细" forState:UIControlStateNormal];
    [button setTitleColor:__TextColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button centerImageAndTitle];
    [button addTarget:self action:@selector(walletDetailsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:button];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(bottomV.frame)+10, CGRectGetWidth(bottomV.frame), 20)];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setTextColor:[UIColor darkTextColor]];
//    [label setFont:[UIFont systemFontOfSize:15]];
//    label.text = @"热门活动";
//    [self.tableView.tableHeaderView addSubview:label];
//
//    label = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(label.frame), CGRectGetWidth(label.frame), 20)];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setTextColor:__TextColor];
//    [label setFont:[UIFont systemFontOfSize:13]];
//    label.text = @"您感兴趣的活动";
//    [self.tableView.tableHeaderView addSubview:label];
}

- (UILabel *)totalMoneyL
{
    if (!_totalMoneyL) {
        _totalMoneyL = [[UILabel alloc] initWithFrame:CGRectMake((__kWidth-100)/2, 30, 100, 30)];
        [_totalMoneyL setFont:[UIFont boldSystemFontOfSize:28]];
        [_totalMoneyL setTextColor:[UIColor whiteColor]];
        [_totalMoneyL setTextAlignment:NSTextAlignmentCenter];
    }
    return _totalMoneyL;
}
- (UILabel *)usableL
{
    if (!_usableL) {
        _usableL = [[UILabel alloc] initWithFrame:CGRectMake(0, 106, CGRectGetWidth(self.view.frame)/2, 20)];
        [_usableL setFont:[UIFont boldSystemFontOfSize:18]];
        [_usableL setTextColor:[UIColor whiteColor]];
        [_usableL setTextAlignment:NSTextAlignmentCenter];
    }
    return _usableL;
}
- (UILabel *)pendingReturnL
{
    if (!_pendingReturnL) {
        _pendingReturnL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetMinY(_usableL.frame), CGRectGetWidth(_usableL.frame), 20)];
        [_pendingReturnL setFont:[UIFont boldSystemFontOfSize:18]];
        [_pendingReturnL setTextColor:[UIColor whiteColor]];
        [_pendingReturnL setTextAlignment:NSTextAlignmentCenter];
    }
    return _pendingReturnL;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
