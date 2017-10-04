//
//  BaseTabBarViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "ZQMyViewController.h"
#import "ZQCarServerViewController.h"
#import "ZQCarProcessViewController.h"
#import "YtabBarButton.h"
#import "BaseNavigationController.h"

@interface BaseTabBarViewController ()

/**主控制器个数*/
@property (strong,nonatomic) NSMutableArray *itemsArr;

@property (strong,nonatomic) NSMutableArray *btnArr;

@property(strong,nonatomic) ZQMyViewController *myVC;

@property(strong,nonatomic) ZQCarServerViewController *serverVC;

@property(strong,nonatomic) ZQCarProcessViewController *carProcessVC;

@end

@implementation BaseTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initView {
    self.myVC = [[ZQMyViewController alloc]init];
    [self creatItemVC:self.myVC];
    self.serverVC = [[ZQCarServerViewController alloc]init];
    [self creatItemVC:self.serverVC];
    self.carProcessVC = [[ZQCarProcessViewController alloc]init];
    [self creatItemVC:self.carProcessVC];
}

- (void)creatItemVC:(UIViewController*)vc {
    BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:navi];
}


- (void)chooseTabbar:(UIButton*)sender {
    BOOL go =YES;
    if (go) {
        for (YtabBarButton*btn in _btnArr) {
            if (btn.tag == sender.tag) {
                btn.selected = !sender.selected;
                btn.colorIV.backgroundColor = __DefaultColor;
                btn.userInteractionEnabled = NO;
            }else{
                btn.userInteractionEnabled = YES;
                btn.colorIV.backgroundColor = [UIColor blackColor];
                btn.selected = NO;
            }
        }
        self.selectedIndex = sender.tag;
        _selectIndex = sender.tag;
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:[NSString stringWithFormat:@"%ld",_selectIndex]];
//        [[NSNotificationCenter defaultCenter]postNotificationName:YSTabBarChangeIndex object:arr userInfo:nil];
    }
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
