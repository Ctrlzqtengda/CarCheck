//
//  ZQValuationController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/18.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQValuationController.h"
#import "ZQValuationCell.h"

@interface ZQValuationController ()<UITableViewDelegate,UITableViewDataSource,ZQValuationCellDelegate>

@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, copy) NSString *valuationStr;
@property (nonatomic, assign) NSInteger valuationStar;
/**  弹出框 */
//@property (strong,nonatomic) UIView *iconImageView;
@end

@implementation ZQValuationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    
    [self initView];
}
-(void)initView{
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-64-50)];
    [self.view addSubview:_tableV];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundColor = [UIColor clearColor];
    _tableV.separatorColor = [UIColor clearColor];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectYH(_tableV), __kWidth, 50)];
    [self.view addSubview:sureBtn];
    sureBtn.backgroundColor = __DefaultColor;
    sureBtn.titleLabel.font = MFont(16);
    [sureBtn setTitle:@"提交评价" forState:BtnNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:BtnTouchUpInside];
}

#pragma mark ==UITableViewDelegate==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZQValuationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQValuationCell"];
    if (!cell) {
        cell = [[ZQValuationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YEvaluteOrderCell"];
        cell.delegate = self;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZQValuationCell getValuationCellHeight];
}
#pragma mark ==YEvaluteOrderCellDelegate==
-(void)giveStar:(NSInteger)star index:(NSInteger)tag{
//    _dataModel.star = [NSString stringWithFormat:@"%ld",star];
//    NSLog(@"评价的星星:%ld",(long)star);
    self.valuationStar = star;
}
/*
-(void)addPhotos:(NSInteger)tag{
    [self addImage];
}
*/
-(void)evaluteText:(NSString *)string index:(NSInteger)tag{
//    NSLog(@"评价的内容string:%@",string);
    self.valuationStr = string;
//    _dataModel.evalue = string;
}


#pragma mark ===== 添加图片 =====
/*
-(void)addImage{
    [self.view endEditing:YES];
    //弹出框
    _iconImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    _iconImageView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:_iconImageView];
    //*** 按设计修改后内容
    NSArray *array = @[@"拍照", @"我的相册", @"取消"];
    //1 菜单视图 选择拍照或相册
    UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(10, __kHeight-172, __kWidth-20, 102)];
    chooseView.backgroundColor = HEXCOLOR(0xffffff);
    [_iconImageView addSubview:chooseView];
    chooseView.layer.cornerRadius = 10.0f;
    
    //1.1 中间分隔线
    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 51, CGRectW(chooseView), 1)];
    [chooseView addSubview:lineIV];
    lineIV.backgroundColor = HEXCOLOR(0xdedede);
    
    //1.2 选择拍照或相册 按钮
    //    按钮颜色 color(0 84 255)  (0x0051ff)
    for (NSInteger i=0; i<array.count-1; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*52, CGRectW(chooseView), 50)];
        //        btn.backgroundColor = HEXCOLOR(0xf1f1f1);
        [btn setTitleColor:HEXCOLOR(0x0051ff) forState:BtnNormal];
        //        btn.titleLabel.font = MFont(15);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(iconBtnAction:) forControlEvents:BtnTouchUpInside];
        btn.tag = 160+i;
        [chooseView addSubview:btn];
    }
    
    
    //2 菜单视图 选择 取消
    UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectYH(chooseView)+10, __kWidth-20, 50)];
    cancelView.backgroundColor = HEXCOLOR(0xffffff);
    [_iconImageView addSubview:cancelView];
    cancelView.layer.cornerRadius = 10.0f;
    
    //2.1 按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectW(cancelView), 50)];
    [cancelView addSubview:cancelBtn];
    [cancelBtn setTitleColor:HEXCOLOR(0x0051ff) forState:BtnNormal];
    //  cancelBtn.titleLabel.font = MFont(15);
    [cancelBtn setTitle:array[2] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(iconBtnAction:) forControlEvents:BtnTouchUpInside];
    cancelBtn.tag = 162;
    
    
    
}

- (void)iconBtnAction:(UIButton *)btn {
    switch (btn.tag - 160) {
        case 0: {
            NSLog(@"拍照");
            UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
//            pickerVC.delegate = self;
            //选择照片数据源 ---默认是相册
            pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerVC animated:YES completion:nil];
        }
            
            
            break;
        case 1: {
            NSLog(@"从相册获取");
            UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
            //想要知道选择的图片
//            pickerVC.delegate = self;
            //开启编辑状态
            pickerVC.allowsEditing = YES;
            [self presentViewController:pickerVC animated:YES completion:nil];
            [_iconImageView removeFromSuperview];
        }
            
            break;
        default:
            NSLog(@"取消");
            [_iconImageView removeFromSuperview];
            break;
    }
}

#pragma mark - 更换头像Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *goodImage  = info[UIImagePickerControllerOriginalImage];
    if (picker.allowsEditing) {
        goodImage = info[UIImagePickerControllerEditedImage];
    }
    NSData *imageData = UIImageJPEGRepresentation(goodImage, 0.5);
    
//    [_dataModel.imageArr addObject:imageData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //保存图片进入沙盒中
    [_tableV reloadData];
}
*/
#pragma mark ==确认提交==
-(void)sureAction{
    NSLog(@"确认提交");
    if (!self.valuationStr)
    {
        [ZQLoadingView showAlertHUD:@"请输入您的评价" duration:1.5];
        return;
    }
    if (!self.valuationStar)
    {
        [ZQLoadingView showAlertHUD:@"请给出评价" duration:1.5];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"daf/add_pl/u_id/%@/jigou_id/%@/ptype/%ld/txt/%@",[Utility getUserID],self.jigou_id,(long)self.valuationStar,self.valuationStr];
    //检车机构接口
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf performSelector:@selector(bacAction) withObject:nil afterDelay:SXLoadingTime];
            }
        }
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            
        }
    } animated:YES];
}
- (void)bacAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
