//
//  ZQMyOrderViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyOrderViewController.h"
#import "ZQNoDataView.h"
#import "ZQOrderCell.h"
#import "ZQOrderTypeChooseView.h"

@interface ZQMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ZQOrderTypeChooseView *orderHeadView;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSMutableArray *allOrdersList;
@property (strong, nonatomic) NSMutableArray *inProcessList;
@property (strong, nonatomic) NSMutableArray *successList;
@property (strong, nonatomic) NSMutableArray *revocationList;

@property (strong, nonatomic) ZQNoDataView *noDataView;
@property (assign, nonatomic) NSInteger  page;//页面
@property (strong, nonatomic) NSString *status;//订单类型

@end

@implementation ZQMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    _status =@"";
    _page = 1;
    [self.view addSubview:self.tableView];
    [self addSegment];
    [self segmentAction:ZQInProcessOrdersView];
}
- (void)requestOrdersDataWithTableViewType
{
    orderHeadView.userInteractionEnabled = YES;
    switch (_currentViewType) {
        case ZQInProcessOrdersView:
        {
            self.inProcessList = [NSMutableArray arrayWithCapacity:0];
            if (self.inProcessList.count) {
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"您无正在处理的订单";
            }
        }
        break;
        case ZQSucessOrdersView:
        {
            self.successList = [NSMutableArray arrayWithCapacity:0];
            if (self.successList.count) {
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"您暂时还无已完成订单";
            }
        }
            break;
        case ZQRevocationOrdersView:
        {
            self.revocationList = [NSMutableArray arrayWithCapacity:0];
            if (self.revocationList.count) {
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"您无撤销订单";
            }
        }
            break;
        case ZQAllOrdersView:
        {
            self.allOrdersList = [NSMutableArray arrayWithCapacity:0];
            if (self.allOrdersList.count) {
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"您无订单记录";
            }
        }
            break;
        default:
            break;
    }
}
- (void)addSegment
{
    if (!orderHeadView) {
        orderHeadView = [[ZQOrderTypeChooseView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 40)];
        [orderHeadView configViewWithArray:@[@"处理中",@"已成功",@"已撤销",@"全部"]];
        [self.view addSubview:orderHeadView];
        
        __weak __typeof(self)weakSelf = self;
        orderHeadView.chooseOrderType = ^(NSInteger orderType){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf segmentAction:orderType];
            }
        };
    }
}
#pragma mark -segmentMethod-
- (void)segmentAction:(NSInteger)orderType
{
    _currentViewType = (ZQOrderViewType)orderType;
    switch (orderType) {
        case 0:
        {
            //待处理中
            if (self.inProcessList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                self.dataArr = _inProcessList;
                [self.tableView reloadData];
            }
        }
            break;
        case 1:
        {
            //已成功
            if (self.successList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                self.dataArr = _successList;
                [self.tableView reloadData];
            }
        }
            break;
        case 2:
        {
            //已撤销
            if (self.revocationList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                self.dataArr = _revocationList;
                [self.tableView reloadData];
            }
        }
            break;
        case 3:
        {
            //全部
            if (self.allOrdersList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                self.dataArr = _allOrdersList;
                [self.tableView reloadData];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark ==UITableViewDelegate==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _dataArr.count;
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZQOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQOrderCell"];
    if (!cell) {
        cell = [[ZQOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZQOrderCell"];
    }
    ZQOrderModel *model = _dataArr[indexPath.row];
    cell.orderModel = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KWidth, self.view.bounds.size.height-40) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
    }
    return _tableView;
}
- (ZQNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[ZQNoDataView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, 200)];
        _noDataView.center = self.view.center;
    }
    return _noDataView;
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
