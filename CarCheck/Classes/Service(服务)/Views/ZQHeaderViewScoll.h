//
//  ZQHeaderViewScoll.h
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQScrollPageView.h"

@interface ZQHeaderViewScoll : UICollectionReusableView

@property(nonatomic,strong)NSArray *imageStrArray;

-(void)startWithBlock:(ClickBlock)block;

@end
