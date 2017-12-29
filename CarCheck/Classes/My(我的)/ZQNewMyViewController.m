//
//  ZQNewMyViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNewMyViewController.h"
#import "ZQSettingViewController.h"
#import "ZQMessageViewController.h"
#import "ZQMyOrderViewController.h"
#import "ZQNewCarOrderViewController.h"
#import "ZQSubstituteOrderController.h"
#import "ZQMyMoneyViewController.h"
#import "ZQLoginViewController.h"
//#import "ZQNewVIPViewController.h"
#import "ZQBuyVipViewController.h"
#import "BaseNavigationController.h"
#import "UIButton+WebCache.h"

static CGFloat kImageOriginHight = 200.f;
@interface ZQNewMyViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
     NSArray *_titleArray;
     UIImageView *expandZoomImageView;
}
@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) UIImageView *headIV;
@property (strong, nonatomic) UIButton *headBtn;
@property (strong, nonatomic) UILabel *phoneLabel;

@property (strong, nonatomic) UIImageView *VIPImageV;
@end

@implementation ZQNewMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@[@{@"title":@"预约订单",@"image":@"myOrder"},@{@"title":@"新车免检预约订单",@"image":@"myOrder"},@{@"title":@"代缴罚款订单",@"image":@"myOrder"},@{@"title":@"VIP服务",@"image":@"vipServer"},@{@"title":@"我的钱包",@"image":@"myMoney"}],@[@{@"title":@"我的消息",@"image":@"myMessage"}],@[@{@"title":@"客服电话",@"image":@"customerService"}],@[@{@"title":@"设置",@"image":@"mySetting"}]];
  
    [self.view addSubview:self.tableView];
}
//更换头像
- (void)headBtnAction
{
    if (![Utility isLogin])
    {
        ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
        BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:loginNa animated:YES completion:^{
            
        }];
        return;
    }
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.tabBarController presentViewController:pickerVC animated:YES completion:nil];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        //想要知道选择的图片
        pickerVC.delegate = self;
        //开启编辑状态
        pickerVC.allowsEditing = YES;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheetController addAction:cameraAction];
    [actionSheetController addAction:albumAction];
    [actionSheetController addAction:cancelAction];
    [self presentViewController:actionSheetController animated:YES completion:nil];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGRect f = expandZoomImageView.frame;
    f.origin.y = yOffset;
    f.size.height =  -yOffset+kImageOriginHight;
    expandZoomImageView.frame = f;
}
#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = _titleArray[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idMy"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell_idMy"];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = _titleArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    cell.textLabel.text = dic[@"title"];
    if (indexPath.section==0&&indexPath.row==3) {
        cell.detailTextLabel.textColor = LH_RGBCOLOR(17,149,232);
//        cell.detailTextLabel.text = @"开通VIP独享全年减免";
        cell.detailTextLabel.text = @"首次开通VIP赠送200积分";
    }
    else
    {
        cell.detailTextLabel.text = nil;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![Utility isLogin]&&indexPath.section!=3&&indexPath.section!=2)
    {
        ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
        BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:loginNa animated:YES completion:^{
            
        }];
        return;
    }
    switch (indexPath.section) {
        case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        //我的订单
                        ZQMyOrderViewController *myOrderVc = [[ZQMyOrderViewController alloc] init];
                        [myOrderVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myOrderVc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        //新车免检预约订单
                        ZQNewCarOrderViewController *myOrderVc = [[ZQNewCarOrderViewController alloc] init];
                        [myOrderVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myOrderVc animated:YES];
                    }
                        break;
                    case 2:
                    {
                        //代缴罚款订单
                        ZQSubstituteOrderController *myOrderVc = [[ZQSubstituteOrderController alloc] init];
                        [myOrderVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myOrderVc animated:YES];
                    }
                        break;
                    case 3:{
                        //VIP服务
                        //                        ZQNewVIPViewController *myVipVc = [[ZQNewVIPViewController alloc] initWithNibName:@"ZQNewVIPViewController" bundle:nil];
                        //                        [myVipVc setHidesBottomBarWhenPushed:YES];
                        //                        [self.navigationController pushViewController:myVipVc animated:YES];
                        ZQBuyVipViewController *myMoneyVc = [[ZQBuyVipViewController alloc] init];
                        [myMoneyVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myMoneyVc animated:YES];
                    }
                        break;
                    case 4:
                    {
                        //我的钱包
                        ZQMyMoneyViewController *myMoneyVc = [[ZQMyMoneyViewController alloc] init];
                        [myMoneyVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myMoneyVc animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
            break;
        case 1:{
            //我的消息
            ZQMessageViewController *messageVC = [[ZQMessageViewController alloc] init];
            [messageVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 2:
        {
            //客服电话
            [Utility phoneCallAction];
        }
            break;
        case 3:
        {
            //设置
            ZQSettingViewController *setVC = [[ZQSettingViewController alloc] init];
            [setVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        default:
            break;
    }
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    if (picker.allowsEditing) {
        image = [self scaleImage:info[UIImagePickerControllerEditedImage] toScale:0.5];
    }
    else
    {
        image = [self scaleImage:info[UIImagePickerControllerOriginalImage] toScale:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    //保存图片进入沙盒中
    [self saveImage:image withName:@"headImage"];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSLog(@"%@",NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}
#pragma mark - 上传头像
-(void)saveImage:(UIImage*)headImage withName:(NSString*)imageName{
    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5);
//    [Utility storageObject:imageData forKey:@"UserHead"];
    
    [self modifyUserHeadimgWith:imageData];
}
-(void)modifyUserHeadimgWith:(NSData *)image{
    
    //修改头像接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/update_head/u_id/%@",[Utility getUserID]];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr Params:nil NSData:image key:@"head" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSString *headUrl = jsonDic[@"head"];
                if ([headUrl isKindOfClass:[NSString class]]) {
                    if (headUrl.length) {
                        [strongSelf.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageBaseAPI,headUrl]] forState:UIControlStateNormal placeholderImage:MImage(@"user_head")];
                        [Utility storageObject:headUrl forKey:@"userHeadUrl"];
                        return ;
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
    //    http://b2b2c.sztd123.com/api?controller=User&method=ModifyUserHeadimg1&callback=uploadImg&common_param=%7B%22uid%22:293,%22user_headimg%22:%22upload%2Favator%2F1508737708.jpg%22%7D
    
//    NSData *data =UIImageJPEGRepresentation(image, 0.3);
//    NSString *imgStr = [data base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
//    NSString *userId = [UdStorage getObjectforKey:Userid];
//    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    //    [dict setObject:userId forKey:@"uid"];
//    //    [dict setObject:image forKey:@"user_headimg"];
//    //    NSString *common_param = [YSParseTool jsonDict:dict];
//    
//    NSString *controller = @"User";
//    NSString *method = @"ModifyUserHeadimg";
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:controller forKey:@"controller"];
//    [param setObject:method forKey:@"method"];
//    //    [param setObject:common_param forKey:@"common_param"];
//    
//    NSString *str1 = [NSString stringWithFormat:@"{\"uid\":%@,\"user_headimg\":%@}",userId,imgStr];
//    
//    [param setValue:str1 forKey:@"common_param"];
//    
//    [JKHttpRequestService POST:@"?" withParameters:param success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        if (succe) {
//            [ZQLoadingView showAlertHUD:@"头像修改成功" duration:1.5];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"modifyUserHeadimgNoti" object:nil];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height - 50) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
        _tableView.estimatedSectionHeaderHeight = 10;
        _tableView.estimatedSectionFooterHeight = 0;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, kImageOriginHight)];
        headView.backgroundColor = [UIColor clearColor];
        headView.autoresizesSubviews = YES;
        _tableView.tableHeaderView = headView;
        expandZoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageOriginHight, 128)];
        expandZoomImageView.contentMode = UIViewContentModeScaleAspectFill;
        expandZoomImageView.image = [UIImage imageNamed:@"my_bgImage"];
        expandZoomImageView.clipsToBounds = YES;
        [headView addSubview:expandZoomImageView];
        
        //        self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-80)/2,(kImageOriginHight-80)/2, 80, 80)];
        //        _headIV.layer.cornerRadius = 40;
        //        _headIV.layer.borderColor = [UIColor whiteColor].CGColor;
        //        _headIV.layer.borderWidth = 2.5;
        //        _headIV.image =MImage(@"user_head");
        //        _headIV.clipsToBounds = YES;
        //        _headIV.contentMode =UIViewContentModeScaleAspectFill;
        //        [headView addSubview:_headIV];
        
        self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setFrame:CGRectMake((__kWidth-80)/2,(kImageOriginHight-80)/2, 80, 80)];
        _headBtn.layer.cornerRadius = 40;
        _headBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _headBtn.layer.borderWidth = 2.5;
        _headBtn.clipsToBounds = YES;
        [_headBtn addTarget:self action:@selector(headBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:_headBtn];
        
        self.VIPImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VIP_Head_logo"]];
        [self.VIPImageV setCenter:CGPointMake(CGRectGetMaxX(_headBtn.frame)-8, CGRectGetMaxY(_headBtn.frame)-15)];
        [headView addSubview:_VIPImageV];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headBtn.frame), __kWidth, 30)];
        [_phoneLabel setTextAlignment:NSTextAlignmentCenter];
        [_phoneLabel setTextColor:[UIColor whiteColor]];
        [headView addSubview:_phoneLabel];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    expandZoomImageView.frame = CGRectMake(0, -20, _tableView.frame.size.width, kImageOriginHight+20);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [_phoneLabel setText:[Utility getUserName]];
     [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageBaseAPI,[Utility getUserHeadUrl]]] forState:UIControlStateNormal placeholderImage:MImage(@"user_head")];
    if ([Utility getIs_vip]) {
        [self.VIPImageV setHidden:NO];
    }
    else
    {
        [self.VIPImageV setHidden:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
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
