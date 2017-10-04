//
//  ZQCarServerViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQCarServerViewController.h"
#import "ZQHeaderViewScoll.h"
#import "ZQServerViewCell.h"
#import "ZQAppointmentHeaderView.h"

@interface ZQCarServerViewController()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *_dataArray;
    NSMutableArray *_imagePpointArray;
    NSMutableArray *_appointArray;
}
@property(strong,nonatomic) UICollectionView *mainView;
@end

@implementation ZQCarServerViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    
}

- (void)initViews {
    
    [self getData];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.mainView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.mainView.backgroundColor = [UIColor colorWithRed:235/255.0 green:246/255.0 blue:252/255.0 alpha:1];;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:self.mainView];
    
    // 注册
    [self.mainView registerClass:[ZQServerViewCell class] forCellWithReuseIdentifier:@"ServerViewCell"];
    [self.mainView registerClass:[ZQHeaderViewScoll class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScrollPageView"];
    [self.mainView registerClass:[ZQAppointmentHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQAppointmentHeaderView"];
    
}

-(void)getData {
    _appointArray = [NSMutableArray arrayWithObjects:@"预约须知",@"在线预约",@"电话预约检车", nil];
    _imagePpointArray = [NSMutableArray arrayWithObjects:@"know",@"online",@"phone", nil];
    _dataArray = [NSMutableArray arrayWithObjects:@"违章查询",@"检车机构列表",@"保险服务",@"车辆维修",@"代缴罚款",@"常见问题",@"法律咨询",@"加油充值", nil];
}

#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        return _appointArray.count;
    }else {
        return _dataArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZQServerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServerViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZQServerViewCell alloc] init];
    }
    if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor clearColor];
        [cell writeDataWithTitle:_appointArray[indexPath.row] imageStr:_imagePpointArray[indexPath.row]];
    }else{
        [cell writeDataWithTitle:_dataArray[indexPath.row] imageStr:nil];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark headerAndFooter
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reuseV = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            // 轮播图
            ZQHeaderViewScoll *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScrollPageView" forIndexPath:indexPath];
            headView.imageStrArray = @[@"adp",@"adp",@",adp"];
            headView.backgroundColor = [UIColor redColor];
            [headView startWithBlock:^(NSInteger index) {
                
            }];
            reuseV = headView;
        }else{
            // 轮播图
            ZQAppointmentHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQAppointmentHeaderView" forIndexPath:indexPath];
            
            reuseV = headView;
        }
        
    }else {
        // 轮播图
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"defaultHeaderView" forIndexPath:indexPath];
        reuseV = headView;
        
    }
    return reuseV;
    
}

#pragma mark flowlayout
//x 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
//y 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((__kWidth-5*2)/3.0, (__kWidth-5*2)/3.0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(__kWidth, 150);
    }else if(section == 1){
        return CGSizeMake(__kWidth, 40);
    }else{
        return CGSizeMake(__kWidth, 0);
    }
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
