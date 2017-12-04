//
//  ZQSubTimeViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQSubTimeViewController.h"
#import "ZQCollectionViewCell.h"
#import "ZQTimeCollectionViewCell.h"
#import "ZQUpSubdataViewController.h"
#import "YPayViewController.h"
#import "NSDate+helper.h"
#import "ZQDateModel.h"

@interface ZQSubTimeViewController ()<UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NSMutableArray *_dataArray;
    NSArray *timeArray;
    NSArray *costArray;
    NSArray *costDetailArray;
    CGFloat totalMoney;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollView;
@property (weak, nonatomic) IBOutlet UILabel *costMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenMinutesL;

@property (strong, nonatomic) NSMutableArray *dateArray;

@property (copy, nonatomic) NSString *u_date;
@property (copy, nonatomic) NSString *phase;

@end

@implementation ZQSubTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.u_date = @"";
    self.phase = @"";
    
    timeArray = @[@"8:00 - 10:00",@"10:00 - 12:00",@"13:00 - 15:00",@"15:00 - 17:00"];
    [self getcalendarDatesForDays:15];
    [self initViews];
    // Do any additional setup after loading the view from its nib.
    
    if (self.serviceChargeMoney>0) {
        costArray = @[@"检车费用:",@"上门服务费:"];
        costDetailArray = @[[NSString stringWithFormat:@"%@ ",self.costMoney],[NSString stringWithFormat:@"%.0f 元",self.serviceChargeMoney]];
        [self.tenMinutesL setHidden:YES];
        totalMoney = [self.costMoney floatValue]+self.serviceChargeMoney;
    }
    else
    {
        costArray = @[@"检车费用:",@"服务费:"];
        costDetailArray = @[[NSString stringWithFormat:@"%@元",self.costMoney],@"0元"];
        totalMoney = [self.costMoney floatValue];
    }
    NSString *string = [NSString stringWithFormat:@"合计金额: %.0f元",totalMoney];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
    [att setAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]} range:[string rangeOfString:@"合计金额:"]];
    [self.costMoneyLabel setAttributedText:att];
}
- (void)getcalendarDatesForDays:(NSInteger)days
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *endOfDate = [today dateAfterDay:days];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:today
                                                 toDate:endOfDate
                                                options:0];
    NSInteger cDays = [components day];
    NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
    for (NSInteger day = 0; day <cDays; day++) {
        [components setDay:day];
        NSDate *dDate = [calendar dateByAddingComponents:components toDate:today options:0];
        NSDateComponents * comps_other= [calendar components:(NSCalendarUnitMonth |
                                                              NSCalendarUnitDay |
                                                              NSCalendarUnitWeekday) fromDate:dDate];
        
        ZQDateModel *model = [[ZQDateModel alloc] init];
        model.dMonth = comps_other.month;
        model.dDay = [NSString stringWithFormat:@"%ld",(long)comps_other.day];
        model.dWeek = [NSDate getWeekStringFromInteger:comps_other.weekday];
        model.dDate = dDate;
        [calendarDays addObject:model];
    }
    self.dateArray = calendarDays;
}
#pragma mark私有方法

- (IBAction)nextAction:(id)sender {
    
//    ZQUpSubdataViewController *vc = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];

    if (!self.u_date.length) {
        [ZQLoadingView showAlertHUD:@"请选择日期" duration:SXLoadingTime];
        return;
    }
    if (!self.phase.length) {
        [ZQLoadingView showAlertHUD:@"请选择时间段" duration:SXLoadingTime];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/u_date/%@/phase/%@",self.requestUrl,self.u_date,self.phase];
    urlStr = @"daf/file_upload/u_id/51/u_name/肚肚/u_phone/18510556565/u_car_card/鲁PQM888/u_car_type/中型车 200元/testing_id/1/type/1/inspection_fee/200/service_charge/0.000000/u_date/11-29/phase/8:00 - 10:00";
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:@"51" forKey:@"u_id"];
//    [dict setObject:@"旺达" forKey:@"u_name"]; // 标题
//    [dict setObject:@"18098789878" forKey:@"u_phone"];// 类别ID
//    [dict setObject:@"鲁PM122" forKey:@"u_car_card"];// 文物名
//    [dict setObject:@"大型车300元" forKey:@"u_car_type"];// 性质 id
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr Params:nil NSArray:self.uploadImageArr key:@"u_car_pic" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                YPayViewController *payVC = [[YPayViewController alloc] init];
                payVC.payMoney = [NSString stringWithFormat:@"%.0f",totalMoney];
                [strongSelf.navigationController pushViewController:payVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}

-(void)initViews {
    
    self.title = @"选择预约时间";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc]init];
    self.timeCollView.collectionViewLayout = flowLayout1;
    self.timeCollView.backgroundColor = [UIColor whiteColor];
    self.timeCollView.delegate = self;
    self.timeCollView.dataSource = self;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZQCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"monthDayCell_id"];
    [self.timeCollView registerNib:[UINib nibWithNibName:@"ZQTimeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"timeCell_id"];
    
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sureTimeHeader"];
    
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return self.dateArray.count;
    }else {
        return timeArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        ZQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthDayCell_id" forIndexPath:indexPath];
        ZQDateModel *model = self.dateArray[indexPath.row];
        [cell.monLabel setText:[NSString stringWithFormat:@"%ld-%@",model.dMonth,model.dDay]];
        [cell.dayLabel setText:model.dWeek];
//        cell.backgroundColor = model.isSelected ? [UIColor colorWithRed:130/255.0 green:202/255.0 blue:63/255.0 alpha:1]:[UIColor colorWithRed:208/255.0 green:231/255.0 blue:245/255.0 alpha:1];
        return cell;
    }else {
        ZQTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timeCell_id" forIndexPath:indexPath];
        [cell.timeLabel setText:timeArray[indexPath.row]];
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZQDateModel *model = self.dateArray[indexPath.row];
   cell.backgroundColor = model.isSelected ? [UIColor colorWithRed:130/255.0 green:202/255.0 blue:63/255.0 alpha:1]:[UIColor colorWithRed:208/255.0 green:231/255.0 blue:245/255.0 alpha:1];
}
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//分组头
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reuseV = nil;
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        
//        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sureTimeHeader" forIndexPath:indexPath];
//        if (indexPath.section == 1) {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, KWidth, 30)];
//            label.text = @"请选择具体时间";
//            label.font = [UIFont systemFontOfSize:14];
//            label.textColor = [UIColor grayColor];
//            [header addSubview:label];
//        }
//        reuseV = header;
//    }else{
//        return reuseV;
//    }
//    return reuseV;
//}

//x 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

#pragma mark flowlayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width,height;
    if (collectionView == self.collectionView) {
//        width = (KWidth - 4*2 - 30) / 5.0;
        width = (KWidth - 4*2 - 30) / 4.5;
        height = width * 0.8;
    }else {
        width = (KWidth - 4*5 - 30) / 2.0;
        height = width * 0.25;
    }
    
    return CGSizeMake(width, height);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == self.collectionView) {
        return CGSizeMake(0, 15);
    }else {
        return CGSizeMake(KWidth, 0);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        return UIEdgeInsetsMake(0, 10, 0, 10);//分别为上、左、下、右
    }else {
        return UIEdgeInsetsMake(0, 15, 0, 15);//分别为上、左、下、右
    }
    
}


// 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionCell class] == [ZQTimeCollectionViewCell class])
    {
        self.phase = timeArray[indexPath.row];
        [self updateCellStatus:collectionCell selected:YES];
    }
    else
    {
        ZQCollectionViewCell *cell = (ZQCollectionViewCell *)collectionCell;
        if ([cell.dayLabel.text isEqualToString:@"星期日"]) {
            [ZQLoadingView showAlertHUD:@"周日不办理业务\n请选择其他日期" duration:2.0];
            cell.selected = NO;
            return;
        }
        //选中之后的cell变颜色
        ZQDateModel *model = self.dateArray[indexPath.row];
        model.isSelected = YES;
        [self updateCellStatus:cell selected:model.isSelected];
        self.u_date = [NSString stringWithFormat:@"%ld-%@",model.dMonth,model.dDay];
    }
}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{NSLog(@"取消选中操作取消选中操作=%ld",indexPath.row);
    UICollectionViewCell *collectionCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([collectionCell class] == [ZQTimeCollectionViewCell class])
    {
        [self updateCellStatus:collectionCell selected:NO];
    }
    else
    {
        ZQCollectionViewCell *cell = (ZQCollectionViewCell *)collectionCell;
        //    if ([cell.dayLabel.text isEqualToString:@"星期日"]||[cell.dayLabel.text isEqualToString:@"星期六"]) {
        //        [ZQLoadingView showAlertHUD:@"周六日不办理业务请选择其他日期" duration:2.0];
        //        return;
        //    }
        ZQDateModel *model = self.dateArray[indexPath.row];
        model.isSelected = NO;
        [self updateCellStatus:cell selected:model.isSelected];
    }
}
// 改变cell的背景颜色
-(void)updateCellStatus:(UICollectionViewCell *)cell selected:(BOOL)selected
{
    if ([cell class] == [ZQTimeCollectionViewCell class]) {
        ZQTimeCollectionViewCell *tmpCell = (ZQTimeCollectionViewCell *)cell;
        tmpCell.timeLabel.backgroundColor = selected ? [UIColor colorWithRed:130/255.0 green:202/255.0 blue:63/255.0 alpha:1]:[UIColor colorWithRed:208/255.0 green:231/255.0 blue:245/255.0 alpha:1];
    }else {
        if (selected) {
            NSLog(@"选中操作取消选中操作执行执行");
        }
        else
        {
            NSLog(@"取消选中操作取消选中操作执行执行");
        }
        cell.backgroundColor = selected ? [UIColor colorWithRed:130/255.0 green:202/255.0 blue:63/255.0 alpha:1]:[UIColor colorWithRed:208/255.0 green:231/255.0 blue:245/255.0 alpha:1];
    }
    
//    cell.layer.borderWidth = selected ? 0:1.0;
}
#pragma mark -UITableViewDelegate-
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return costArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"costCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.textLabel setText:costArray[indexPath.row]];
    [cell.detailTextLabel setText:costDetailArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
