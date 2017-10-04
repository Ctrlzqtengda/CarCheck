//
//  ZQCarProcessViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQCarProcessViewController.h"
#import "ZQProcessCell.h"
#import "ZQProcessRightCell.h"

@interface ZQCarProcessViewController()<UITableViewDelegate,UITableViewDataSource,ZQProcessRightCellDelegate,ZQProcessCellDelegate>{
    
    NSMutableArray *_dataArray;
    
}

@property(strong,nonatomic)UITableView *tableView;

@end

@implementation ZQCarProcessViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
}

#pragma mark 私有方法
-(void)initViews {
    
    [self getData];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 注册
    [self.tableView registerClass:[ZQProcessCell class] forCellReuseIdentifier:@"ZQProcessCell"];
    [self.tableView registerClass:[ZQProcessRightCell class] forCellReuseIdentifier:@"ZQProcessRightCell"];
}

-(void)getData {
    
    _dataArray = [NSMutableArray arrayWithObjects:@[@"违章查询"],@[@"代缴违章罚款"],@[@"检车预约",@"上门接送检车",@"电话预约检车"],@[@"常见问题"],@[@"平台介绍"], nil];
    
}
#pragma mark 共有方法

#pragma mark ZQProcessCellDelegate
-(void)selectAtRow:(NSInteger)row index:(NSInteger)index {
    NSLog(@"ZQProcessCellDelegate row=%ld index = %ld",(long)row,(long)index);
}

#pragma mark ZQProcessRightCellDelegate
-(void)selectRightAtRow:(NSInteger)row index:(NSInteger)index {
    NSLog(@"ZQProcessRightCellDelegate row=%ld index = %ld",(long)row,(long)index);
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row % 2 == 0) {
        ZQProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQProcessCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ZQProcessCell alloc] init];
        }
        cell.delegate = self;
        cell.dataArray = _dataArray[indexPath.row];
        return cell;
    }else{
        
        ZQProcessRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQProcessRightCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (cell == nil) {
            cell = [[ZQProcessRightCell alloc] init];
        }
        cell.dataArray = _dataArray[indexPath.row];
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *tmpArray = _dataArray[indexPath.row];
    return 30 * (2 + tmpArray.count) + 5 * (tmpArray.count - 1);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
