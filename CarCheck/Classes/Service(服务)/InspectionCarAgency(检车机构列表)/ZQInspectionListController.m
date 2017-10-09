//
//  ZQInspectionListController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQInspectionListController.h"
#import "ZQInspectionCell.h"

#import "ZQHtmlViewController.h"
#import "ZQAlerInputView.h"

@interface ZQInspectionListController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{
    UISearchController *searchController;
}
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *agencyList;

@property (nonatomic, strong) NSMutableArray *searchListArry;
@end

@implementation ZQInspectionListController

@synthesize searchController = _searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"检车机构";
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
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate= self;
    self.searchController.searchResultsUpdater = self;

//    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
//    UIImageView *barImageView = [[[self.searchController.searchBar.subviews firstObject] subviews] firstObject];
//    barImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    barImageView.layer.borderWidth = 1;
    
    self.searchController.searchBar.tintColor =  [UIColor darkGrayColor];
    // 改变searchBar背景颜色
    self.searchController.searchBar.barTintColor =  [UIColor whiteColor];
    // 取消searchBar上下边缘的分割线
    self.searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    
    UITextField *searchTextField = (UITextField *)[[[self.searchController.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = [UIColor lightGrayColor];
//    
//    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:[UISearchBar class]]
//    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
//    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];


    //位置
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        // 添加 searchbar 到 headerview
//    self.tableView.tableHeaderView = self.searchController.searchBar;
    
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
    }
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
    Vc.title = @"检车站详情";
    [self.navigationController pushViewController:Vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //    //修改"Cancle"退出字眼,这样修改,按钮一开始就直接出现,而不是搜索的时候再出现
    //    searchController.searchBar.showsCancelButton = YES;
    //    for(id sousuo in [searchController.searchBar subviews])
    //    {
    //
    //        for (id zz in [sousuo subviews])
    //        {
    //
    //            if([zz isKindOfClass:[UIButton class]]){
    //                UIButton *btn = (UIButton *)zz;
    //                [btn setTitle:@"搜索" forState:UIControlStateNormal];
    //                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //            }
    //
    //
    //        }
    //    }
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchListArry!= nil) {
        [self.searchListArry removeAllObjects];
    }
    //过滤数据
//    self.searchListArry= [NSMutableArray arrayWithArray:[self.dataListArry filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}
#pragma mark - UISearchControllerDelegate代理,可以省略,主要是为了验证打印的顺序
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    //    [self.view addSubview:self.searchController.searchBar];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
}
/*
- (void)addDestinationTableView
{
    if (self.tableView == nil) {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, width, 20)];
        sView.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf1/255.0 blue:0xf4/255.0 alpha:1.0];
        [self.view addSubview:sView];
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        searchBar.placeholder = @"输入目的地";
        searchBar.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf1/255.0 blue:0xf4/255.0 alpha:1.0];
        searchBar.tintColor = kHWColorHaiwanMain;
        [self.view addSubview:searchBar];
        
        for (UIView *view in searchBar.subviews) {
            for (UIView *bbView in view.subviews) {
                if ([NSStringFromClass([bbView class]) isEqualToString:@"UISearchBarBackground"]) {
                    [bbView removeFromSuperview];
                    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, width, .5)];
                    lineV.backgroundColor = kHWColorLineGray;
                    [searchBar addSubview:lineV];
                    break;
                }
            }
        }
        
        
        
        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        searchDisplayController.delegate = self;
        searchDisplayController.searchResultsDataSource = self;
        searchDisplayController.searchResultsDelegate = self;
    }
}
*/

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
