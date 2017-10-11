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
#import "ZQViolationViewController.h"
#import "ZQPayVioViewController.h"
#import "ZQSubTimeViewController.h"
#import "ZQProblemViewController.h"
#import "ZQOnlineAlertView.h"
#import "ZQSuccessAlerView.h"
#import "ZQInspectionListController.h"

@interface ZQCarProcessViewController()<UITableViewDelegate,UITableViewDataSource,ZQProcessRightCellDelegate,ZQProcessCellDelegate>{
    
    NSMutableArray *_dataArray;
    NSMutableArray *_colorArray;
    NSMutableArray *_stepArray;
    
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
    
    // 背景图
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"process.png"]];
    imgView.frame = CGRectMake(0, 0, KWidth, KHeight - 84 - 44);
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.tableView setBackgroundView:imgView];
}

-(void)getData {
    
    _dataArray = [NSMutableArray arrayWithObjects:@[@"违章查询"],@[@"代缴违章罚款"],@[@"检车预约",@"上门接送检车",@"电话预约检车"],@[@"常见问题"],@[@"平台介绍"], nil];
//    _stepArray = [NSMutableArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五", nil];
    _stepArray = [NSMutableArray arrayWithObjects:@"第一步",@"第二步",@"第三步",@"第四部",@"了解", nil];

    _colorArray = [NSMutableArray array];
    [_colorArray addObject:[UIColor colorWithRed:4/255.0 green:139/255.0 blue:254/255.0 alpha:1]];
    [_colorArray addObject:[UIColor colorWithRed:143/255.0 green:130/255.0 blue:188/255.0 alpha:1]];
    [_colorArray addObject:[UIColor colorWithRed:18/255.0 green:180/255.0 blue:177/255.0 alpha:1]];
    [_colorArray addObject:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1]];
    [_colorArray addObject:[UIColor colorWithRed:228/255.0 green:1/255.0 blue:127/255.0 alpha:1]];
    
}

-(void)showSubView {
    ZQOnlineAlertView *alerView = [[ZQOnlineAlertView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alerView.handler = ^(NSArray *contenArr)
    {
        [contenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"上门接送车提交内容:%@",obj);
        }];
        //                    [ZQLoadingView makeSuccessfulHudWithTips:@"上传完成" parentView:nil];
        
        [ZQSuccessAlerView showCommitSuccess];
    };
    [alerView show];
}
#pragma mark 共有方法

#pragma mark ZQProcessCellDelegate
-(void)selectAtRow:(NSInteger)row index:(NSInteger)index {
    NSLog(@"ZQProcessCellDelegate row=%ld index = %ld",(long)row,(long)index);
    switch (row) {
        case 0:{
            ZQViolationViewController *vc = [[ZQViolationViewController alloc] initWithNibName:@"ZQViolationViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            if (index == 0) {

                ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
                [self.navigationController pushViewController:inspectionVC animated:YES];
            }else if (index == 1){
                [self showSubView];
            }else if (index == 2){
                NSString *phoneStr = @"1888888888";
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                UIApplication * app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    [app openURL:[NSURL URLWithString:PhoneStr]];
                }
            }
        }
            break;
        case 4:{
            ZQProblemViewController *subVC = [[ZQProblemViewController alloc] init];
            [self.navigationController pushViewController:subVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark ZQProcessRightCellDelegate
-(void)selectRightAtRow:(NSInteger)row index:(NSInteger)index {
    NSLog(@"ZQProcessRightCellDelegate row=%ld index = %ld",(long)row,(long)index);
    switch (row) {
        case 1:{
            ZQPayVioViewController *vc = [[ZQPayVioViewController alloc] initWithNibName:@"ZQPayVioViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            ZQProblemViewController *subVC = [[ZQProblemViewController alloc] init];
            [self.navigationController pushViewController:subVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
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
        [cell writeDataWithArray:_dataArray[indexPath.row] color:_colorArray[indexPath.row] title:_stepArray[indexPath.row]];
        return cell;
    }else{
        
        ZQProcessRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQProcessRightCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (cell == nil) {
            cell = [[ZQProcessRightCell alloc] init];
        }
        [cell writeDataWithArray:_dataArray[indexPath.row] color:_colorArray[indexPath.row] title:_stepArray[indexPath.row]];
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
