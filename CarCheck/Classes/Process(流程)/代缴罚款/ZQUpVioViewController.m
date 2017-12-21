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
#import "YPayViewController.h"

@interface ZQUpVioViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZQvioFooterViewDelegate,YSureOrderBottomViewDelegate,YBuyingDatePickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZQVioUpTableViewCellDelegate>{
    NSArray        *_titleArray;
    NSArray        *_placeArray;
    NSMutableArray *_contentArray;
    UIImage        *_chooseImage;
    NSString       *desString;
    
    BOOL           isAgreeServer;    //是否同意协议
    BOOL           isVerifyCode;    //验证码是否正确
    
    NSInteger temp;
}

@property (strong, nonatomic) UITableView          *tableView;
@property (strong, nonatomic) YSureOrderBottomView *bottomV;
@property (strong, nonatomic) YBuyingDatePicker    *datePickV;
@property (strong, nonatomic) ZQChoosePickerView   *pickView;
@property (copy,   nonatomic) NSString             *shortNumString;   //简称
@property (copy,   nonatomic) NSString             *overdueFine;      //滞纳金
@property (copy,   nonatomic) NSString             *veriyCode;        //验证码

@property (strong, nonatomic) NSTimer *sTimer;
@property (strong, nonatomic) UIButton *codeBtn;
@end

@implementation ZQUpVioViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.sTimer) {
        [self.sTimer invalidate];
        self.sTimer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    temp = 60;
    self.title = @"代缴罚款";
    self.shortNumString = @"冀";
    self.overdueFine = @"";
    isAgreeServer = NO;
    self.veriyCode = @"123456";
    desString = @"该服务适用于已开具《公安交通管理简易程序处罚决定书》的违章，若没有该罚单，请先到交通管理部门领取处罚决定书，然后填写下面的信息即可在线缴纳罚款";
    [self setupData];
    [self initViews];
}

-(void)setupData {
//    _titleArray = @[@[@"车牌号码",@"处罚金额",@"处罚日期"],@[@"处罚金额",@"滞纳金",@"服务费",@""]];
//    _placeArray = @[@[@"请输入完整车牌号",@"请输入罚单上的处罚金额",@"请输入开具罚单的日期"],@[@"￥0",@"￥0",@"￥0",@"合计：￥0"]];
//    手机号码：“请输入办理进度通知的手机号码”
//    验证码：“请输入手机验证码”获取验证码
//
    _titleArray = @[@[@"罚单编号",@"车牌号码",@"处罚金额",@"处罚日期",@"手机号码",@"验证码"],@[@"处罚金额",@"滞纳金",@"服务费",@""]];
    _placeArray = @[@[@"请输入16位处罚决定书编号",@"请输入完整车牌号",@"请输入罚单上的处罚金额",@"请输入开具罚单的日期",@"请输入办理进度通知的手机号码",@"请输入验证码"],@[@"￥0",@"￥0",@"￥0",@"合计：￥0"]];
//    _placeArray = @[@"请输入16位处罚决定书编号",@"请输入完整车牌号",@"请输入罚单上的处罚金额",@"请输入开具罚单的日期",@"请输入办理进度通知的手机号码",@"请输入验证码"];
    _contentArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
}

-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
}

-(void)initViews {
    
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

#pragma mark ==YBuyingDatePickerDelegate==
-(void)chooseDateTime:(NSString *)sender{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *coms = [NSDate dateWithTimeIntervalSince1970:[sender integerValue]];
    NSString *dates =[formatter stringFromDate:coms];
//    _placeArray = dates;
    _contentArray[3] = dates;
    NSString *money = _contentArray[2];
    if (money.floatValue>0) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                   fromDate:coms
                                                     toDate:[NSDate date]
                                                    options:0];
        NSInteger cDays = [components day];
        if (cDays>15) {
            CGFloat overdueFineMoney = (cDays-15)*money.floatValue*0.03;
            if (overdueFineMoney>money.floatValue) {
                self.overdueFine = money;
            }
            else
            {
                self.overdueFine = [NSString stringWithFormat:@"%.2f",overdueFineMoney];
            }
        }
        else
        {
            self.overdueFine = @"0";
        }
    }
    [self.tableView reloadData];
    _bottomV.total = [NSString stringWithFormat:@"%.2f",money.floatValue+self.overdueFine.floatValue];
}

- (void)hiddenView {
    
    [self.datePickV removeFromSuperview];
    self.datePickV = nil;
}

#pragma mark ZQVioUpTableViewCellDelegate
-(void)showChooseView {
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:[Utility getProvinceShortNum] inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                strongSelf.shortNumString = selectedStr;
                [strongSelf.tableView reloadData];
            }
        }
    }];
    
}

#pragma mark ZQvioFooterViewDelegate
// 是否同意协议
-(void)agreeAction:(BOOL)isAgree{
    isAgreeServer = isAgree;
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
    if (!isAgreeServer) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先阅读并同意相关须知 !" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSString *ticketNumStr = [_contentArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (ticketNumStr.length != 16) {
        [ZQLoadingView showAlertHUD:@"请输入16位罚单编号" duration:SXLoadingTime];
        return;
    }
    NSString *carCodeStr = [_contentArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (carCodeStr.length !=6) {
        [ZQLoadingView showAlertHUD:@"请输入正确车牌号码" duration:SXLoadingTime];
        return;
    }
    carCodeStr = [NSString stringWithFormat:@"%@%@",self.shortNumString,carCodeStr];
    NSString *punishMoneyStr = [_contentArray[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!punishMoneyStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入处罚金额" duration:SXLoadingTime];
        return;
    }
    NSString *punishDateStr = [_contentArray[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!punishDateStr.length) {
        [ZQLoadingView showAlertHUD:@"请选择处罚日期" duration:SXLoadingTime];
        return;
    }
    NSString *phoneStr = [_contentArray[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!phoneStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入手机号码" duration:SXLoadingTime];
        return;
    }
    NSString *codeStr = [_contentArray[5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!codeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入验证码" duration:SXLoadingTime];
        return;
    }
    else
    {
        if (!isVerifyCode) {
            [ZQLoadingView showAlertHUD:@"请输入正确的验证码" duration:SXLoadingTime];
            return;
        }
    }
    if (!_chooseImage) {
        [ZQLoadingView showAlertHUD:@"请上传处罚决定书" duration:SXLoadingTime];
        return;
    }
    //代缴罚款接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/payment_of_fines/u_id/%@/ticket_number/%@/car_card/%@/fine_money/%@/fine_date/%@/phone/%@",[Utility getUserID],ticketNumStr,carCodeStr,punishMoneyStr,punishDateStr,phoneStr];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr Params:nil NSData:UIImageJPEGRepresentation(_chooseImage, 0.5) key:@"pic_path" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                YPayViewController *payVC = [[YPayViewController alloc] init];
                payVC.payMoney = [NSString stringWithFormat:@"%@",jsonDic[@"total"]];
                payVC.orderNo = jsonDic[@"order_no"];
                payVC.aPayType = ZQPayAFineView;
                [strongSelf.navigationController pushViewController:payVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}
//获取验证码
- (void)getCode
{
    NSString *phoneStr = [_contentArray[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!phoneStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入手机号码" duration:SXLoadingTime];
        return;
    }
     NSString *urlStr = [NSString stringWithFormat:@"daf/get_phone_code/phone/%@",phoneStr];
//    获取验证码接口
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSInteger code = [jsonDic[@"code"] integerValue];
            if (code != 400) {
                strongSelf.veriyCode = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
                //            [strongSelf.codeBtn setBackgroundColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1.0]];
                strongSelf.sTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:strongSelf selector:@selector(numTiming:) userInfo:nil repeats:YES];
            }
            else
            {
                [ZQLoadingView showAlertHUD:jsonDic[@"statusmsg"] duration:SXLoadingTime];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}
- (void)numTiming:(NSTimer *)sTimer
{
    if (temp == 0) {
        [sTimer invalidate];
        self.sTimer = nil;
        temp = 60;
        [_codeBtn setUserInteractionEnabled:YES];
        //        [_codeBtn setBackgroundColor:[UIColor colorWithRed:0x41/255.0 green:0xc9/255.0 blue:0xdc/255.0 alpha:1.0]];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)temp--] forState:UIControlStateNormal];
    }
}
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _contentArray[textField.tag] = textField.text;
    if (textField.tag == 5) {
        isVerifyCode = [self.veriyCode isEqualToString:textField.text];
        if (!isVerifyCode) {
            [ZQLoadingView showAlertHUD:@"验证码错误" duration:SXLoadingTime];
            return YES;
        }
    }
    if (textField.tag==2) {
        NSString *dateStr = _contentArray[3];
        NSDate *date = nil;
        if (dateStr.length) {
            NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            date = [formatter dateFromString:dateStr];
            NSString *money = _contentArray[2];
            if (money.floatValue>0) {
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                               fromDate:date
                                                                                 toDate:[NSDate date]
                                                                                options:0];
                NSInteger cDays = [components day];
                if (cDays>15) {
                    CGFloat overdueFineMoney = (cDays-15)*money.floatValue*0.03;
                    if (overdueFineMoney>money.floatValue) {
                        self.overdueFine = money;
                    }
                    else
                    {
                        self.overdueFine = [NSString stringWithFormat:@"%.2f",overdueFineMoney];
                    }
                }
                else
                {
                    self.overdueFine = @"0";
                }
            }
            _bottomV.total = [NSString stringWithFormat:@"%.2f",money.floatValue+ self.overdueFine.floatValue];
        }
    }
    return YES;
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
    cell.accessoryView = nil;
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
                self.codeBtn = codeBtn;
                cell.accessoryView = codeBtn;
            }
                break;
            default:
            {
                type = ZQVioUpCellType2;
            }
                break;
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        type = ZQVioUpCellType4;
        switch (indexPath.row) {
            case 0:
            {
                NSString *str = _contentArray[2];
                if (str.length) {
                    cell.contentTf.text = [NSString stringWithFormat:@"￥%@",str];
                }
            }
                break;
            case 1:
            {
                CGFloat ff = [self.overdueFine floatValue];
                if (ff) {
                    cell.contentTf.text = [NSString stringWithFormat:@"￥%.2f",ff];
                }
                else
                {
                    cell.contentTf.text = @"￥0";
                }
            }
                break;
            case 2:
            {
                cell.contentTf.text = @"￥0";
            }
                break;
            case 3:
            {
                NSString *str = _contentArray[2];
                if (str.length) {
                    cell.contentTf.text = [NSString stringWithFormat:@"￥%.2f",str.floatValue+ self.overdueFine.floatValue];
                }
            }
                break;
            default:
                break;
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    cell.delegate = self;
    NSString *title = _titleArray[indexPath.section][indexPath.row];
    NSString *palceText = _placeArray[indexPath.section][indexPath.row];
    cell.contentTf.tag = indexPath.row;
    [cell setCellType:type title:title placeText:palceText provinceCode:self.shortNumString];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGFloat width = __kWidth-40;
        UIFont *font = [UIFont systemFontOfSize:14.0];
       CGSize size = [desString boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, size.height+50)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, 10, width, size.height+10)];
        label.text = desString;
        label.font = font;
        label.numberOfLines = 0;
        label.textColor = __TextColor;
        [headerView addSubview:label];

        label = [[UILabel alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(label.frame), width, 30)];
        label.text = @"填写处罚决定书必要信息";
        label.font = font;
        label.textColor = __TextColor;
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
        [self.view endEditing:YES];
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
        CGFloat width = __kWidth-40;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        CGSize size = [desString boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        return size.height+50;
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

#pragma mark 私有方法
-(YBuyingDatePicker *)datePickV{
    if (!_datePickV) {
        _datePickV = [[YBuyingDatePicker alloc]initWithFrame:CGRectMake(0, __kHeight-260, __kWidth, 260)];
        _datePickV.limitDate = YES;
        _datePickV.delegate = self;
    }
    return _datePickV;
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
