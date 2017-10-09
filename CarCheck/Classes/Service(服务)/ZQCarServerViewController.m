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

#import "ZQHtmlViewController.h"
#import "ZQInspectionListController.h"
#import "ZQViolationViewController.h" //违章查询
#import "ZQPayVioViewController.h"  //代缴罚款
#import "ZQSubTimeViewController.h"
#import "ZQOnlineSubViewController.h" // 在线预约

#import "ZQInsuranceView.h" //保险
#import "ZQLoadingView.h"


@interface ZQCarServerViewController()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_dataArray;
    NSArray *_imagePpointArray;
    NSArray *_appointArray;
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
    _appointArray = @[@"预约须知",@"在线预约",@"电话预约检车"];
    _imagePpointArray = @[@"know",@"online",@"phone"];
    _dataArray = @[@{@"title":@"违章查询",@"image":@"weizhang"},@{@"title":@"检车机构列表",@"image":@"jianche"},@{@"title":@"保险服务",@"image":@"baoxian"},@{@"title":@"车辆维修",@"image":@"weixiu"},@{@"title":@"代缴罚款",@"image":@"fakuan"},@{@"title":@"常见问题",@"image":@"wenti"},@{@"title":@"法律咨询",@"image":@"falv"},@{@"title":@"加油充值",@"image":@"jiayou"}];
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
//        [cell writeDataWithTitle:_dataArray[indexPath.row] imageStr:nil];
        [cell writDataWithModel:_dataArray[indexPath.row]];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==2) {
        switch (indexPath.row) {
            case 0:
            {
                ZQViolationViewController *vc = [[ZQViolationViewController alloc] initWithNibName:@"ZQViolationViewController" bundle:nil];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:
            {
                ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
                [inspectionVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:inspectionVC animated:YES];
                
                break;
            }
            case 2:
            {
                ZQInsuranceView *alerView = [[ZQInsuranceView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
                alerView.handler = ^(NSArray *contenArr)
                {
                    [contenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSLog(@"保险提交内容:%@",obj);
                    }];
                    [ZQLoadingView makeSuccessfulHudWithTips:@"上传完成" parentView:nil];
                };
                [alerView show];
                break;
            }
                case 4:
            {
                ZQPayVioViewController *vc = [[ZQPayVioViewController alloc] initWithNibName:@"ZQPayVioViewController" bundle:nil];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }
    else if (indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
            {
                ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"https://www.baidu.com"];
                Vc.title = @"预约须知";
                [Vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:Vc animated:YES];
                break;
            }
            case 1:
            {
                ZQOnlineSubViewController *vc = [[ZQOnlineSubViewController alloc] initWithNibName:@"ZQOnlineSubViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:
            {
                NSString *phoneStr = @"1888888888";
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                UIApplication * app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    [app openURL:[NSURL URLWithString:PhoneStr]];
                }
                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:phoneStr preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    NSLog(@"点击了呼叫按钮10.2下");
//                    NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
//                    UIApplication * app = [UIApplication sharedApplication];
//                    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
//                        [app openURL:[NSURL URLWithString:PhoneStr]];
//                    }
//                }]];
//                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                    NSLog(@"点击了取消按钮");
//                }]];
//                [self presentViewController:alert animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }
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
            __weak __typeof(self) weakSelf = self;
            headView.handler = ^{
                ZQSubTimeViewController *subVC = [[ZQSubTimeViewController alloc] initWithNibName:@"ZQSubTimeViewController" bundle:nil];
                [subVC setHidesBottomBarWhenPushed:YES];
                [weakSelf.navigationController pushViewController:subVC animated:YES];
            };
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
