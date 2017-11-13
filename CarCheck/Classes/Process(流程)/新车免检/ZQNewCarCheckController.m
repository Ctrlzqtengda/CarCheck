//
//  ZQNewCarCheckController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNewCarCheckController.h"
#import "ZQVioUpTableViewCell.h"
#import "ZQChoosePickerView.h"
#import "ZQHtmlViewController.h"
#import "YPayViewController.h"

@interface ZQNewCarCheckController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZQVioUpTableViewCellDelegate>
{
    NSInteger _index;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *titleArray;
@property (strong,nonatomic) NSArray *pickerDataArray;
@property (strong,nonatomic) NSArray *placeArray;
@property(strong,nonatomic) ZQChoosePickerView *pickView;

@end

@implementation ZQNewCarCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新车免检预约";
    [self setupData];
    [self initViews];
}
-(void)setupData {
    _titleArray = @[@"车主姓名",@"手机号码",@"车辆号码",@"收货地址"];
    _placeArray = @[@"请输入车主姓名",@"请输入手机号码",@"请输入车辆号码",@"请输入详细的收货地址"];
    _pickerDataArray = @[@"冀",@"鲁",@"鄂"];

}
-(void)initViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height-50) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZQVioUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZQVioUpTableViewCell_id"];
    
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 140)];
//    self.tableView.tableFooterView = footView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = __TextColor;
    label.text = @"*将办理免检所需资料邮寄至\n邢台市桥西区中兴西大街\n居然空间写字楼617室\n服务热线：4008769838 \n我们将在收到资料后2-3个工作日办理完成并寄出";
    self.tableView.tableFooterView = label;
//    [footView addSubview:label];
    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10, CGRectGetWidth(self.view.frame), 30)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:18];
//    label.textColor = __TextColor;
//    label.text = @"服务费: 30元";
//    [footView addSubview:label];
    
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.view.frame), 50)];
    _putBtn.backgroundColor = __DefaultColor;
    _putBtn.titleLabel.font = MFont(18);
    [_putBtn setTitle:@"提交订单 (服务费: 30元)" forState:BtnNormal];
    [_putBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [_putBtn addTarget:self action:@selector(commitInformation) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:_putBtn];
}
//提交订单
- (void)commitInformation
{
    YPayViewController *payVC = [[YPayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
}
#pragma mark ZQVioUpTableViewCellDelegate
-(void)showChooseView {
    
    [self.pickView showWithDataArray:self.pickerDataArray inView:self.view chooseBackBlock:^(NSInteger index) {
        _index = index;
        [self.tableView reloadData];
        //        self.carShapeTf.text = _pickerDataArray[index];
    }];
    
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //    self.tableView.reloadData;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
    ZqCellType type;
    if (indexPath.row==2) {
        type = ZQVioUpCellType1;
    }
    else
    {
        type = ZQVioUpCellType2;
    }
    cell.contentTf.delegate = self;
    //        cell.contentTf.text = _contentArray[indexPath.row];
    cell.delegate = self;
    NSString *title = _titleArray[indexPath.row];
    cell.contentTf.tag = indexPath.row;
    [cell setCellType:type title:title placeText:_placeArray[indexPath.row] provinceCode:_pickerDataArray[_index]];
    return cell;
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(ZQChoosePickerView *)pickView {
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
}

-(void)back{
    UIViewController *htmlVc = self.navigationController.viewControllers[1];
    if ([htmlVc isKindOfClass:[ZQHtmlViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
