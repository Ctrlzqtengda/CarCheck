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

@interface ZQSubTimeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NSMutableArray *_dataArray;
    
}

@property(weak,nonatomic)IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollView;
@property (weak, nonatomic) IBOutlet UILabel *costMoneyLabel;


@end

@implementation ZQSubTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view from its nib.
    if (self.serviceChargeMoney>0) {
     [self.costMoneyLabel setText:[NSString stringWithFormat:@"检车费用: %@ 上门服务费: %.0f元\n 合计金额: 600元",self.costMoney,self.serviceChargeMoney]];
    }
    else
    {
        [self.costMoneyLabel setText:[NSString stringWithFormat:@"检车费用: %@ 服务费: 300元\n 合计金额: 600元",self.costMoney]];
    }
}
#pragma mark私有方法

- (IBAction)nextAction:(id)sender {
    
//    ZQUpSubdataViewController *vc = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    YPayViewController *payVC = [[YPayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
    
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
        return 30;
    }else {
        return 4;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        ZQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthDayCell_id" forIndexPath:indexPath];
        return cell;
    }else {
        ZQTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timeCell_id" forIndexPath:indexPath];
        return cell;
    }
    
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
        width = (KWidth - 4*2 - 30) / 5.0;
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
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //选中之后的cell变颜色
    [self updateCellStatus:cell selected:YES];
}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self updateCellStatus:cell selected:NO];
}
// 改变cell的背景颜色
-(void)updateCellStatus:(UICollectionViewCell *)cell selected:(BOOL)selected
{
    if ([cell class] == [ZQTimeCollectionViewCell class]) {
        ZQTimeCollectionViewCell *tmpCell = (ZQTimeCollectionViewCell *)cell;
        tmpCell.timeLabel.backgroundColor = selected ? [UIColor colorWithRed:130/255.0 green:202/255.0 blue:63/255.0 alpha:1]:[UIColor colorWithRed:208/255.0 green:231/255.0 blue:245/255.0 alpha:1];
    }else {
        cell.backgroundColor = selected ? [UIColor colorWithRed:130/255.0 green:202/255.0 blue:63/255.0 alpha:1]:[UIColor colorWithRed:208/255.0 green:231/255.0 blue:245/255.0 alpha:1];
    }
    
//    cell.layer.borderWidth = selected ? 0:1.0;
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
