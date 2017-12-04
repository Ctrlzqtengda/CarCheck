//
//  ZQSubstituteOrderController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/1.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQSubstituteOrderController.h"
#import "ZQNoDataView.h"
#import "ZQSubstituteOrderCell.h"
#import "ZQOrderTypeChooseView.h"

#import "ZQHtmlViewController.h"
#import "NSDictionary+propertyCode.h"

@interface ZQSubstituteOrderController ()<UITableViewDelegate,UITableViewDataSource>
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
@end

@implementation ZQSubstituteOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代缴罚款订单";
    _currentViewType = ZQSubInProcessOrdersView;
    _page = 1;
    [self.view addSubview:self.tableView];
    [self addSegment];
    [self segmentAction:ZQSubInProcessOrdersView];
}
- (void)requestOrdersDataWithTableViewType
{
    orderHeadView.userInteractionEnabled = YES;
    //我的订单接口 1.处理中，2.已完成 3.退款
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_fine_order/u_id/%@/order_status/%u",[Utility getUserID],_currentViewType];
    
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    [strongSelf configDataWithArray:array];
                }
            }
        }
        else
        {
            if (strongSelf)
            {
                [strongSelf configDataWithArray:@[]];
            }
        }
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf configDataWithArray:@[]];
        }
    } animated:YES];
    
    
}

- (void)configDataWithArray:(NSArray *)array
{
    switch (_currentViewType) {
        case ZQSubInProcessOrdersView:
        {
            if (array.count) {
                self.inProcessList = [ZQSubstituteOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.inProcessList removeAllObjects];
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"您无正在处理的订单";
            }
            self.dataArr = _inProcessList;
            [self.tableView reloadData];
        }
            break;
        case ZQSubSucessOrdersView:
        {
            if (array.count) {
                self.successList = [ZQSubstituteOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.successList removeAllObjects];
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"您暂时还无已完成订单";
            }
            self.dataArr = _successList;
            [self.tableView reloadData];
        }
            break;
        case ZQSubRevocationOrdersView:
        {
            if (array.count) {
                self.revocationList = [ZQSubstituteOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.revocationList removeAllObjects];
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"您无撤销订单";
            }
            self.dataArr = _revocationList;
            [self.tableView reloadData];
        }
            break;
        case ZQSubAllOrdersView:
        {
            if (array.count) {
                self.allOrdersList = [ZQSubstituteOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.allOrdersList removeAllObjects];
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"您无订单记录";
            }
            self.dataArr = _allOrdersList;
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}
#pragma mark -segmentMethod-
- (void)addSegment
{
    if (!orderHeadView) {
        orderHeadView = [[ZQOrderTypeChooseView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 40)];
        //        [orderHeadView configViewWithArray:@[@"处理中",@"已成功",@"已撤销",@"全部"]];
        [orderHeadView configViewWithArray:@[@"处理中",@"已成功",@"全部"]];
        [self.view addSubview:orderHeadView];
        
        __weak __typeof(self)weakSelf = self;
        orderHeadView.chooseOrderType = ^(NSInteger orderType){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf) {
                switch (orderType) {
                    case 0:
                        [strongSelf segmentAction:ZQSubInProcessOrdersView];
                        break;
                    case 1:
                        [strongSelf segmentAction:ZQSubSucessOrdersView];
                        break;
                    case 2:
                        //                        [strongSelf segmentAction:ZQSubRevocationOrdersView];
                        [strongSelf segmentAction:ZQSubAllOrdersView];
                        break;
                    case 3:
                        [strongSelf segmentAction:ZQSubAllOrdersView];
                        break;
                    default:
                        break;
                }
            }
        };
    }
}
- (void)segmentAction:(NSInteger)orderType
{
    _currentViewType = (ZQSubOrderViewType)orderType;
    switch (orderType) {
        case ZQSubInProcessOrdersView:
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
        case ZQSubSucessOrdersView:
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
        case ZQSubRevocationOrdersView:
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
        case ZQSubAllOrdersView:
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
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     ZQSubstituteOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQSubstituteOrderCell"];
    if (!cell) {
        cell = [[ZQSubstituteOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZQSubstituteOrderCell"];
    }
    cell.orderModel = _dataArr[indexPath.row];
     return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZQSubstituteOrderCell SubstituteOrderCellHeight];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
