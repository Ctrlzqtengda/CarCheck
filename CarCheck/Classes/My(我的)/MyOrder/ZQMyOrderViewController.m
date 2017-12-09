//
//  ZQMyOrderViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyOrderViewController.h"
#import "ZQNoDataView.h"
#import "ZQOrderTypeChooseView.h"

#import "ZQMyBooingCell.h"
#import "ZQHtmlViewController.h"

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

@end

@implementation ZQMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"我的订单";
    self.title = @"预约订单";
    _currentViewType = ZQInProcessOrdersView;
    _page = 1;
    [self.view addSubview:self.tableView];
    [self addSegment];
    [self segmentAction:ZQInProcessOrdersView];
}
- (void)requestOrdersDataWithTableViewType
{
    orderHeadView.userInteractionEnabled = YES;
    //我的订单接口 1.处理中，2.已完成 3.退款
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_file/u_id/%@/order_status/%u",[Utility getUserID],_currentViewType];
    
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
        case ZQInProcessOrdersView:
        {
            if (array.count) {
                self.inProcessList = [ZQOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_inProcessList];
            }
            else
            {
                [self.inProcessList removeAllObjects];
                [self noDataShowText:@"您无正在处理的订单"];
            }
        }
            break;
        case ZQSucessOrdersView:
        {
            if (array.count) {
                self.successList = [ZQOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_successList];
            }
            else
            {
                [self.successList removeAllObjects];
                [self noDataShowText:@"您暂时还无已完成订单"];
            }
        }
            break;
        case ZQRevocationOrdersView:
        {
            if (array.count) {
                self.revocationList = [ZQOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_revocationList];
            }
            else
            {
                [self.revocationList removeAllObjects];
                [self noDataShowText:@"您无撤销订单"];
            }
        }
            break;
        case ZQAllOrdersView:
        {
            if (array.count) {
                self.allOrdersList = [ZQOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_allOrdersList];
            }
            else
            {
                [self.allOrdersList removeAllObjects];
                [self noDataShowText:@"您无订单记录"];
            }
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
                        [strongSelf segmentAction:ZQInProcessOrdersView];
                        break;
                    case 1:
                        [strongSelf segmentAction:ZQSucessOrdersView];
                        break;
                    case 2:
//                        [strongSelf segmentAction:ZQRevocationOrdersView];
                        [strongSelf segmentAction:ZQAllOrdersView];
                        break;
                    case 3:
                        [strongSelf segmentAction:ZQAllOrdersView];
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
    _currentViewType = (ZQOrderViewType)orderType;
    switch (orderType) {
        case ZQInProcessOrdersView:
        {
            //待处理中
            if (self.inProcessList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                [self reloadDataWithArray:_inProcessList];
            }
        }
            break;
        case ZQSucessOrdersView:
        {
            //已成功
            if (self.successList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                [self reloadDataWithArray:_successList];
            }
        }
            break;
        case ZQRevocationOrdersView:
        {
            //已撤销
            if (self.revocationList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                [self reloadDataWithArray:_revocationList];
            }
        }
            break;
        case ZQAllOrdersView:
        {
            //全部
            if (self.allOrdersList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                [self reloadDataWithArray:_allOrdersList];
            }
        }
            break;
        default:
            break;
    }
}
- (void)reloadDataWithArray:(NSMutableArray *)mArray
{
    [self.noDataView removeFromSuperview];
    self.noDataView = nil;
    [self.tableView setHidden:NO];
    self.dataArr = mArray;
    [self.tableView reloadData];
}
- (void)noDataShowText:(NSString *)str
{
    [self.tableView setHidden:YES];
    [self.view addSubview:self.noDataView];
    self.noDataView.noOrderLabel.text = str;
//    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
}
#pragma mark ==UITableViewDelegate==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _dataArr.count;
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ZQMyBooingCell";
    ZQMyBooingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ZQMyBooingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.agencyDetailBtn addTarget:self action:@selector(agencyDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.endorseBtn addTarget:self action:@selector(endorseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.agencyDetailBtn.tag = indexPath.row;
    cell.orderModel = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZQMyBooingCell myBooingCellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//机构详情
- (void)agencyDetailBtnAction:(UIButton *)sender
{
    ZQOrderModel *model = self.dataArr[sender.tag];
    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"agency.html" testId:model.testing_id andShowBottom:YES];
    Vc.title = @"检车站详情";
    Vc.dSubType = model.type.integerValue;
    [self.navigationController pushViewController:Vc animated:YES];
}
//改签订单
- (void)endorseBtnAction:(UIButton *)sender
{
    
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
