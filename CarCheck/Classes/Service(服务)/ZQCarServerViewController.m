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
#import "ZQPayVioViewController.h"    //代缴罚款
#import "ZQSubTimeViewController.h"
#import "ZQMaintainViewController.h"  //车辆维修站
#import "ZQOnlineSubViewController.h" //在线预约
#import "ZQMyBookingViewController.h" //我的预约
#import "ZQRechargeViewController.h"  //加油充值
#import "ZQUpVioViewController.h"     //代缴罚款

#import "ZQInsuranceView.h"           //保险
#import "ZQInsuranceVController.h"    //保险服务
#import "ZQLoadingView.h"
#import "ZQSuccessAlerView.h"         //保险成功提示

#import "BaseNavigationController.h"
#import "ZQLoginViewController.h"

#import "ZQBannerModel.h"

@interface ZQCarServerViewController()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_dataArray;
    NSArray *_imagePpointArray;
    NSArray *_appointArray;
}
@property (strong, nonatomic) UICollectionView *mainView;
@property (strong, nonatomic) NSMutableArray *bannerArray;
//@property (strong, nonatomic) NSArray *imageArray;

@property (strong, nonatomic) ZQHeaderViewScoll *aheadView;
@end

@implementation ZQCarServerViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self getBannerData];
}

- (void)getBannerData
{
    //获取Banner接口
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"daf/get_banner" withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                if (strongSelf.aheadView.imageStrArray) {
                    if (strongSelf.aheadView.imageStrArray.count) {
                        return;
                    }
                }
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.bannerArray = [ZQBannerModel mj_objectArrayWithKeyValuesArray:array];
                        NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:0];
                        for (ZQBannerModel *model in strongSelf.bannerArray) {
                            [muArray addObject:model.b_path];
                            //                        NSLog(@"model.b_path = %@",model.b_path);
                        }
                        //                    strongSelf.imageArray = muArray;
                        //                    [strongSelf.mainView reloadData];
                        strongSelf.aheadView.imageStrArray = muArray;
                        [strongSelf.aheadView startWithBlock:^(NSInteger index) {
                            
                        }];
                        return ;
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
//        __strong typeof(self) strongSelf = weakSelf;
//        if (strongSelf) {
//            strongSelf.aheadView.imageStrArray = @[@"ada",@"adb",@"adc",@"adp"];
//            [strongSelf.aheadView startWithBlock:^(NSInteger index) {
//
//            }];
//        }
    } animated:NO];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.aheadView.imageStrArray) {
//        NSString *firstStr = self.aheadView.imageStrArray.firstObject;
//        if ([firstStr isEqualToString:@"ada"]) {
//            [self getBannerData];
//        }
    }
    else
    {
        [self getBannerData];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (!self.aheadView.imageStrArray) {
//       
//    }
//    else
//    {
//        if (self.aheadView.imageStrArray.count==0) {
//            
//        }
//    }
}
- (void)initViews {
    
    [self getData];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.mainView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.mainView.backgroundColor = MainBgColor;
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
//    _dataArray = @[@{@"title":@"违章查询",@"image":@"weizhang"},@{@"title":@"检车机构",@"image":@"jianche"},@{@"title":@"保险服务",@"image":@"baoxian"},@{@"title":@"车辆维修",@"image":@"weixiu"},@{@"title":@"代缴罚款",@"image":@"fakuan"},@{@"title":@"常见问题",@"image":@"wenti"},@{@"title":@"法律咨询",@"image":@"falv"}];

    _dataArray = @[@{@"title":@"违章查询",@"image":@"weizhang"},@{@"title":@"检车机构",@"image":@"jianche"},@{@"title":@"保险服务",@"image":@"baoxian"},@{@"title":@"车辆维修",@"image":@"weixiu"},@{@"title":@"代缴罚款",@"image":@"fakuan"},@{@"title":@"常见问题",@"image":@"wenti"},@{@"title":@"法律咨询",@"image":@"falv"},@{@"title":@"加油充值",@"image":@"jiayou"}];
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
                ZQHtmlViewController *htmlVc = [[ZQHtmlViewController alloc] initWithUrlString:@"http://m.hbgajg.com/?from=singlemessage&isappinstalled=0" andShowBottom:NO];
                [htmlVc hidesBottomBarWhenPushed];
                htmlVc.title = @"违章查询";
                [self.navigationController pushViewController:htmlVc animated:YES];
//                ZQViolationViewController *vc = [[ZQViolationViewController alloc] initWithNibName:@"ZQViolationViewController" bundle:nil];
//                [vc setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:
            {
                if ([self userIsLogin]) {
                    ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
                    inspectionVC.subType = ZQSubScTypeNone;
                    [inspectionVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:inspectionVC animated:YES];
                }
                break;
            }
            case 2:
            {
                ZQInsuranceVController *insuranceVc = [[ZQInsuranceVController alloc] init];
                [insuranceVc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:insuranceVc animated:YES];
//                ZQInsuranceView *alerView = [[ZQInsuranceView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
//                alerView.handler = ^(NSArray *contenArr)
//                {
//                    [contenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        NSLog(@"保险提交内容:%@",obj);
//                    }];
////                    [ZQLoadingView makeSuccessfulHudWithTips:@"上传完成" parentView:nil];
//
//                    [ZQSuccessAlerView showCommitSuccess];
//                };
//                [alerView show];
                break;
            }
            case 3:
            {
                //车辆维修站
                NSString *phoneStr = [Utility getServerPhone];
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                UIApplication * app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    [app openURL:[NSURL URLWithString:PhoneStr]];
                }
//                ZQMaintainViewController *vc = [[ZQMaintainViewController alloc] init];
//                [vc setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                case 4:
            {
                if ([self userIsLogin])
                {
                    // 代缴罚款
                    //                ZQPayVioViewController *vc = [[ZQPayVioViewController alloc] initWithNibName:@"ZQPayVioViewController" bundle:nil];
                    //                [vc setHidesBottomBarWhenPushed:YES];
                    //                [self.navigationController pushViewController:vc animated:YES];
                    ZQUpVioViewController *vc = [[ZQUpVioViewController alloc] init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
                case 5:
            {
                ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"questions.html" andShowBottom:NO];
                Vc.title = @"常见问题";
                [Vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:Vc animated:YES];
                break;
            }
            case 6:
            {
                //法律咨询
                NSString *phoneStr = [Utility getServerPhone];
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                UIApplication * app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    [app openURL:[NSURL URLWithString:PhoneStr]];
                }
                break;
            }
            case 7:
            {
               //加油充值
                NSString *phoneStr = [Utility getServerPhone];
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                UIApplication * app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    [app openURL:[NSURL URLWithString:PhoneStr]];
                }
//                ZQRechargeViewController *Vc = [[ZQRechargeViewController alloc] init];
//                [Vc setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:Vc animated:YES];

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
                ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"reservationNotice.html" andShowBottom:NO];
                Vc.title = @"预约须知";
                [Vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:Vc animated:YES];
                break;
            }
            case 1:
            {
                if ([self userIsLogin]) {
                    // 在线预约
                    ZQOnlineSubViewController *vc = [[ZQOnlineSubViewController alloc] initWithNibName:@"ZQOnlineSubViewController" bundle:nil];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    //                NSString *htmlStr = @"reservationNotice3.html";
                    //                if ([UdStorage isAgreeReservationNoticeForKey:htmlStr]) {
                    //                    ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
                    //                    [inspectionVC setHidesBottomBarWhenPushed:YES];
                    //                    [self.navigationController pushViewController:inspectionVC animated:YES];
                    //                }
                    //                else
                    //                {
                    //                    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr andShowBottom:3];
                    //                    Vc.title = @"预约须知";
                    //                    Vc.classString = NSStringFromClass([ZQInspectionListController class]);
                    //                    [Vc setHidesBottomBarWhenPushed:YES];
                    //                    [self.navigationController pushViewController:Vc animated:YES];
                    //                }
                }
                break;
            }
            case 2:
            {
                NSString *phoneStr = [Utility getServerPhone];
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
- (BOOL)userIsLogin
{
    if ([Utility isLogin])
    {
        return YES;
    }
    else
    {
        ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
        BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:loginNa animated:YES completion:^{
            
        }];
        return NO;
    }
}
#pragma mark headerAndFooter
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reuseV = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            // 轮播图
            ZQHeaderViewScoll *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScrollPageView" forIndexPath:indexPath];
//            headView.imageStrArray = @[@"ada",@"adb",@"adc",@"adp"];
//            headView.imageStrArray = strongSelf.imageArray;
            headView.backgroundColor = MainBgColor;
            self.aheadView = headView;
            reuseV = headView;
        }else{
            // 预约
            /*
            ZQAppointmentHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQAppointmentHeaderView" forIndexPath:indexPath];
            __weak __typeof(self) weakSelf = self;
            headView.handler = ^{
                ZQMyBookingViewController *bookingVC = [[ZQMyBookingViewController alloc] init];
                [bookingVC setHidesBottomBarWhenPushed:YES];
                [weakSelf.navigationController pushViewController:bookingVC animated:YES];
//                ZQSubTimeViewController *subVC = [[ZQSubTimeViewController alloc] initWithNibName:@"ZQSubTimeViewController" bundle:nil];
//                [subVC setHidesBottomBarWhenPushed:YES];
//                [weakSelf.navigationController pushViewController:subVC animated:YES];
            };
            reuseV = headView;
             */
            UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"defaultHeaderView" forIndexPath:indexPath];
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
    if (indexPath.section==1) {
        if (__kWidth>320) {
            if (__kWidth>375) {
                return CGSizeMake((__kWidth-5*2)/3.0-20, (__kWidth-5*2)/3.0);
            }
            return CGSizeMake((__kWidth-5*2)/3.0-15, (__kWidth-5*2)/3.0);
        }
        return CGSizeMake((__kWidth-5*2)/3.0, (__kWidth-5*2)/3.0);
    }
    else
    {
        return CGSizeMake((__kWidth-5*3)/4.0, (__kWidth-5*3)/4.0);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(__kWidth, 150);
    }else if(section == 1){
//        return CGSizeMake(__kWidth, 40);
        return CGSizeMake(0, 0);
    }else{
        return CGSizeMake(0, 0);
    }
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
