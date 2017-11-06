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
#import "ZQChoosePickerView.h"
#import "ZQHtmlViewController.h"

@interface ZQUpVioViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZQvioFooterViewDelegate,YSureOrderBottomViewDelegate,YBuyingDatePickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZQVioUpTableViewCellDelegate>{
    NSArray *_titleArray;
    NSArray *_placeArray;
    NSMutableArray *_contentArray;
    UIImage *_chooseImage;
    NSArray *_pickerDataArray;
    NSInteger _index;
}

@property(strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic) YSureOrderBottomView *bottomV;
@property (strong,nonatomic) YBuyingDatePicker *datePickV;
@property(strong,nonatomic) ZQChoosePickerView *pickView;

@end

@implementation ZQUpVioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self initViews];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupData {
    
    _index = 0;
//    _titleArray = @[@[@"车牌号码",@"处罚金额",@"处罚日期"],@[@"处罚金额",@"滞纳金",@"服务费",@""]];
//    _placeArray = @[@[@"请输入完整车牌号",@"请输入罚单上的处罚金额",@"请输入开具罚单的日期"],@[@"￥0",@"￥0",@"￥0",@"合计：￥0"]];
//    手机号码：“请输入办理进度通知的手机号码”
//    验证码：“请输入手机验证码”获取验证码
//
    _titleArray = @[@[@"罚单编号",@"车牌号码",@"处罚金额",@"处罚日期",@"手机号码",@"验证码"],@[@"处罚金额",@"滞纳金",@"服务费",@""]];
    _placeArray = @[@[@"请输入16位处罚决定书编号",@"请输入完整车牌号",@"请输入罚单上的处罚金额",@"请输入开具罚单的日期",@"请输入办理进度通知的手机号码",@"请输入验证码"],@[@"￥0",@"￥0",@"￥0",@"合计：￥0"]];
    _contentArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    
    _pickerDataArray = @[@"京",@"冀",@"鄂"];
    
}

-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
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
    _contentArray[3] = dates;
    [self.tableView reloadData];
}

- (void)hiddenView {
    
    [self.datePickV removeFromSuperview];
    self.datePickV = nil;
}

#pragma mark ZQVioUpTableViewCellDelegate
-(void)showChooseView {
    
    [self.pickView showWithDataArray:_pickerDataArray inView:self.view chooseBackBlock:^(NSInteger index) {
        _index = index;
        [self.tableView reloadData];
//        self.carShapeTf.text = _pickerDataArray[index];
    }];
    
}

#pragma mark ZQvioFooterViewDelegate
// 是否同意协议
-(void)agreeAction:(BOOL )isAgree{
    
}
// 服务须知
-(void)knowProtocolAction:(id )sender{
    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"forfeit.html" andShowBottom:NO];
    Vc.title = @"罚款代缴服务须知";
    [self.navigationController pushViewController:Vc animated:YES];
}

// 选择图片
-(void)chooseImageAction:(id )sender {
    
    [self chooseImageAction];
    
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
        switch (indexPath.row) {
            case 1:
            {
                type = ZQVioUpCellType1;
            }
             break;
            case 3:
            {
                type = ZQVioUpCellType3;
            }
                break;
            case 5:
            {
                type = ZQVioUpCellType2;
                UIButton *codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 85, 40)];
                codeBtn.titleLabel.font = MFont(15);
                codeBtn.layer.cornerRadius =5;
                codeBtn.backgroundColor = [UIColor whiteColor];
                [codeBtn setTitle:@"获取验证码" forState:BtnNormal];
                [codeBtn setTitleColor:__TextColor forState:BtnNormal];
                [codeBtn addTarget:self action:@selector(getCode) forControlEvents:BtnTouchUpInside];
                cell.accessoryView = codeBtn;
            }
                break;
            default:
            {
                type = ZQVioUpCellType2;
            }
                break;
        }
    }else{
        type = ZQVioUpCellType4;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    cell.delegate = self;
    NSString *title = _titleArray[indexPath.section][indexPath.row];
    NSString *palceText = _placeArray[indexPath.section][indexPath.row];
    cell.contentTf.tag = indexPath.row;
    [cell setCellType:type title:title placeText:palceText provinceCode:_pickerDataArray[_index]];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, 10, __kWidth, 40)];
        label.text = @"填写处罚决定书必要信息";
        label.font = [UIFont systemFontOfSize:14.0];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}
// 设置表尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    ZQvioFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZQvioFooterView_headerId"];
    if (!footerView) {
        
    }
    if (_chooseImage) {
        footerView.image = _chooseImage;
    }
    footerView.delegate = self;
    if (section == 0) {
        return footerView;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.datePickV) {
        [self hiddenView];
    }
    if ((indexPath.section == 0) && (indexPath.row == 3) ) {
        [self.view addSubview:self.datePickV];
    }
    
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    return 18;
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 70.0 + 230;
    }else{
        return 0.1;
    }
}

-(void)chooseImageAction {
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    //想要知道选择的图片
    pickerVC.delegate = self;
    //开启编辑状态
    pickerVC.allowsEditing = YES;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//    [self.imgView setImage:info[UIImagePickerControllerOriginalImage]];
    _chooseImage = info[UIImagePickerControllerOriginalImage];
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//获取验证码
- (void)getCode
{
    
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
