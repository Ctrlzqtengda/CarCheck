//
//  ZQMaintainViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMaintainViewController.h"

#import "ZQInspectionCell.h"

#import "ZQHtmlViewController.h"
#import "ZQAlerInputView.h"

//UISearchResultsUpdating
@interface ZQMaintainViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    UISearchController *searchController;
}
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *agencyList;

@property (nonatomic, strong) NSMutableArray *searchListArry;
@end

@implementation ZQMaintainViewController

@synthesize searchController = _searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"车辆维修站";
    [self addNavigationRightItem];
    
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAgencyListData];
    }];
    [self.tableView.mj_header beginRefreshing];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10)];
    self.tableView.tableFooterView = view;
    
    //创建UISearchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate= self;
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    //    UIImageView *barImageView = [[[self.searchController.searchBar.subviews firstObject] subviews] firstObject];
    //    barImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    barImageView.layer.borderWidth = 1;
    
    self.searchController.searchBar.tintColor =  [UIColor darkGrayColor];
    // 改变searchBar背景颜色
    self.searchController.searchBar.barTintColor =  [UIColor whiteColor];
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    // 取消searchBar上下边缘的分割线
    self.searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    
    UITextField *searchTextField = (UITextField *)[[[self.searchController.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = [UIColor colorWithRed:182.0/255 green:182.0/255 blue:182.0/255 alpha:0.3];
    //
    //    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:[UISearchBar class]]
    //    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    //    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
    
    
    //位置
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.searchController.searchBar.frame.size.width, 44.0);
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)getAgencyListData
{
    __weak __typeof(self) weakSelf = self;
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (weakSelf.agencyList.count) {
            [weakSelf.agencyList removeAllObjects];
            [weakSelf.agencyList addObject:@{@"image":@"agency",@"name":@"聚州机动车检站",@"distance":@"2.3km",@"address":@"思明区岭兜北二路401",@"phone":@"0592-5979816\n18120732580"}];
        }
        else
        {
            weakSelf.agencyList = [NSMutableArray arrayWithObject:@{@"image":@"agency",@"name":@"聚州机动车检站",@"distance":@"2.3km",@"address":@"思明区岭兜北二路401",@"phone":@"0592-5979816\n18120732580"}];
        }
        for (int i = 0; i<5; i++) {
            NSDictionary *dic = @{@"image":@"agency",@"name":@"聚州机动车检站",@"distance":@"2.3km",@"address":@"思明区岭兜北二路401",@"phone":@"0592-5979816\n18120732580"};
            [self.agencyList addObject:dic];
        }
        if (weakSelf.agencyList.count<3) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
    });
}
- (void)loadMoreData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        NSDictionary *dic = @{@"image":@"agency",@"name":@"聚州机动车检站",@"distance":@"2.3km",@"address":@"思明区岭兜北二路401",@"phone":@"0592-5979816\n18120732580"};
        [self.agencyList addObject:dic];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [tableView.mj_footer endRefreshing];
    });
}
- (void)addNavigationRightItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"shouyeyuyue"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(rightBtnFilterAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
//右侧筛选按钮
- (void)rightBtnFilterAction
{
    ZQAlerInputView *alerView = [[ZQAlerInputView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alerView.handler = ^(NSArray *contenArr)
    {
        [contenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"车检机构内容筛选提交内容:%@",obj);
        }];
    };
    [alerView show];
}
#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    //    NSLog(@"viewForHeaderInSection--viewForHeaderInSection");
    //    UISearchBar *mySearchBar = [[UISearchBar alloc] init];
    //    [mySearchBar setShowsCancelButton:YES];
    //    mySearchBar.delegate = self;
    //    return mySearchBar;
    return self.searchController.searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.agencyList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ZQInspectionCell";
    ZQInspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ZQInspectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.navigationBtn addTarget:self action:@selector(navigationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bookingBtn addTarget:self action:@selector(bookingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.navigationBtn.tag = indexPath.row;
    cell.bookingBtn.tag = indexPath.row;
    cell.infoDict = self.agencyList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZQInspectionCell inspectionCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"id"];
    Vc.title = @"汽车站维修站详情";
    [self.navigationController pushViewController:Vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//导航
- (void)navigationBtnAction:(UIButton *)sender
{
    
}
//预约
- (void)bookingBtnAction:(UIButton *)sender
{
    
}
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf1/255.0 blue:0xf4/255.0 alpha:1.0];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView = tableView;
    }
    return _tableView;
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
