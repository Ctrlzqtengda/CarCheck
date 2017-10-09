//
//  ZQOnlineSubViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQOnlineSubViewController.h"
#import "ZQUpSubdataViewController.h"

@interface ZQOnlineSubViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ZQOnlineSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线预约";
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

-(void)getData {
    
    _dataArray = @[@"自行开车到检车机构上线检测",@"上门接送检车"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_Id"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_Id" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZQUpSubdataViewController *upVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
    [self.navigationController pushViewController:upVC animated:YES];
    
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
