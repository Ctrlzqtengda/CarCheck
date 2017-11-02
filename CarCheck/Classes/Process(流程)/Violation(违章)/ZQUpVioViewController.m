//
//  ZQUpVioViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/31.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQUpVioViewController.h"
#import "ZQVioUpTableViewCell.h"
#import "ZQvioFooterView.h"
#import "YSureOrderBottomView.h"
#import "YBuyingDatePicker.h"

@interface ZQUpVioViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZQvioFooterViewDelegate,YSureOrderBottomViewDelegate,YBuyingDatePickerDelegate>{
    NSArray *_titleArray;
    NSArray *_placeArray;
    NSMutableArray *_contentArray;
}

@property(strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic) YSureOrderBottomView *bottomV;
@property (strong,nonatomic) YBuyingDatePicker *datePickV;

@end

@implementation ZQUpVioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self initViews];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupData {
    
    _titleArray = @[@[@"车牌号码",@"处罚金额",@"处罚日期",@"上传照片"],@[@"处罚金额",@"滞纳金",@"服务费",@""]];
    _placeArray = @[@[@"请输入完整车牌号",@"请输入罚单上的处罚金额",@"请输入开具罚单的日期",@"请上传处罚决定书的照片"],@[@"￥0",@"￥0",@"￥0",@"合计：￥0"]];
    _contentArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    
}

-(void)initViews {
    
    self.title = @"代缴罚款";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height - 50) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZQVioUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZQVioUpTableViewCell_id"];
    // 注册表尾
    [self.tableView registerClass:[ZQvioFooterView class] forHeaderFooterViewReuseIdentifier:@"ZQvioFooterView_headerId"];
    
    // 底部view
    _bottomV = [[YSureOrderBottomView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.tableView), __kWidth, 50)];
    [self.view addSubview:_bottomV];
    _bottomV.delegate = self;
    _bottomV.total = [NSString stringWithFormat:@"%.2f",[@"0" floatValue]+[@"0" floatValue]];
}

#pragma mark 私有方法
-(YBuyingDatePicker *)datePickV{
    if (!_datePickV) {
        _datePickV = [[YBuyingDatePicker alloc]initWithFrame:CGRectMake(0, __kHeight-260, __kWidth, 260)];
        _datePickV.delegate = self;
    }
    return _datePickV;
}

#pragma mark ==YBuyingDatePickerDelegate==
-(void)chooseDateTime:(NSString *)sender{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *coms = [NSDate dateWithTimeIntervalSince1970:[sender integerValue]];
    NSString *dates =[formatter stringFromDate:coms];
//    _placeArray = dates;
    _contentArray[2] = dates;
    [self.tableView reloadData];
}

- (void)hiddenView {
    
    [self.datePickV removeFromSuperview];
    
}


#pragma mark ZQvioFooterViewDelegate
// 是否同意协议
-(void)agreeAction:(BOOL )isAgree{
    
}
// 服务须知
-(void)knowProtocolAction:(id )sender{
    
}

#pragma mark YSureOrderBottomViewDelegate
// 提交订单
-(void)putOrder {
    
    
    
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    _contentArray[textField.tag] = textField.text;
//    self.tableView.reloadData;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
    if (cell == nil) {
        
    }
    ZqCellType type;
    if (indexPath.section == 0) {
        cell.contentTf.delegate = self;
        cell.contentTf.text = _contentArray[indexPath.row];
        if (indexPath.row == 0) {
            type = ZQVioUpCellType1;
        }else if(indexPath.row == 1){
            type = ZQVioUpCellType2;
        }else{
            type = ZQVioUpCellType3;
        }
    }else{
        type = ZQVioUpCellType4;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    NSString *title = _titleArray[indexPath.section][indexPath.row];
    NSString *palceText = _placeArray[indexPath.section][indexPath.row];
    cell.contentTf.tag = indexPath.row;
    [cell setCellType:type title:title placeText:palceText];
    return cell;
}
// 设置表尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    ZQvioFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZQvioFooterView_headerId"];
    if (!footerView) {
        
    }
    footerView.delegate = self;
    if (section == 0) {
        return footerView;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 0) && (indexPath.row == 2) ) {
        [self.view addSubview:self.datePickV];
    }
    
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 70.0;
    }else{
        return 0.1;
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
