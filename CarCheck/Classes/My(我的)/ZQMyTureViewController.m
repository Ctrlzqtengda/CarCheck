//
//  ZQMyTureViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/11/2.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyTureViewController.h"
#import "YBuyingDatePicker.h"
#import "ZQVioUpTableViewCell.h"


@interface ZQMyTureViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YBuyingDatePickerDelegate>{
    NSArray *_titleArray;
    NSArray *_placeArray;
    NSMutableArray *_contentArray;
}

@property(strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic) YBuyingDatePicker *datePickV;

@end

@implementation ZQMyTureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self initViews];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupData {
    
    _titleArray = @[@"头像:",@"性别:",@"注册日期:",@"个人说明:",@"充值:",@"清楚缓存:",@"意见反馈:",@"平台介绍:",@"APP分享:"];
    _placeArray = @[@"男",@"2017-09-01",@"请输入"];
    _contentArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    
}

-(void)initViews {
    
    self.title = @"我的";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height - 50) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 注册cell
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZQVioUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZQVioUpTableViewCell_id"];

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

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell_id1"];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                UIImageView *_headIV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 40, 40)];
                _headIV.layer.cornerRadius = 20;
                _headIV.layer.borderColor = LH_RGBCOLOR(244, 150, 130).CGColor;
                _headIV.layer.borderWidth = 1;
                _headIV.image =MImage(@"user_head");
                _headIV.clipsToBounds = YES;
                _headIV.contentMode =UIViewContentModeScaleAspectFill;
                cell.accessoryView = _headIV;
            }
            break;
        case 1:
        case 2:
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = _placeArray[indexPath.row-1];
        }
            break;
        default:
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
    /*
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell_id1"];
        cell.textLabel.text = _placeArray[indexPath.row];
        return cell;
    }else if ((indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3)){
        ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
        [cell setCellType:ZQVioUpCellType2 title:_titleArray[indexPath.row] placeText:_placeArray[indexPath.row]];
        
        return cell;
    }else{
        ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
        [cell setCellType:ZQVioUpCellType3 title:_titleArray[indexPath.row] placeText:_placeArray[indexPath.row]];
        return cell;
    }
     */
}
// 设置表尾
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    return nil;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 0) && (indexPath.row == 2) ) {
        [self.view addSubview:self.datePickV];
    }
    
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//    if (section == 0) {
//        return 70.0;
//    }else{
//        return 0.1;
//    }
//}

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
