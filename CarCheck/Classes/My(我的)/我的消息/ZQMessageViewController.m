//
//  ZQMessageViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMessageViewController.h"
#import "ZQMessageCell.h"
#import "ZQNoDataView.h"

#import "NSDictionary+propertyCode.h"
@interface ZQMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *contentArr;

@property (strong, nonatomic) ZQNoDataView *noDataView;
@property (assign, nonatomic) NSInteger  page;//页面
@property (strong, nonatomic) NSString *status;//订单类型
@end

@implementation ZQMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [self.view addSubview:self.tableView];
    [self getMessageListData];
}
- (void)getMessageListData
{
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_news/u_id/%@",[Utility getUserID]];

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
                        [dic createProperty];
                        strongSelf.contentArr = [ZQMessageModel mj_objectArrayWithKeyValuesArray:array];
                        [self.tableView setHidden:NO];
                        [self.noDataView removeFromSuperview];
                        self.noDataView = nil;
                    }
                    else
                    {
                        [strongSelf.contentArr removeAllObjects];
                        [self.tableView setHidden:YES];
                        [self.view addSubview:self.noDataView];
                        self.noDataView.noOrderLabel.text = @"您当前无消息";
                    }
                    [strongSelf.tableView reloadData];
                    [strongSelf.tableView.mj_header endRefreshing];
                }
            }
        }
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf.contentArr removeAllObjects];
            [strongSelf.tableView reloadData];
            [strongSelf.tableView.mj_header endRefreshing];
        }
    } animated:YES];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
        _tableView.estimatedSectionHeaderHeight = 10;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZQMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQMessageCell"];
    if (!cell) {
        cell = [[ZQMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ZQMessageCell"];
    }
    ZQMessageModel *msgModel = _contentArr[indexPath.row];
    cell.model = msgModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
