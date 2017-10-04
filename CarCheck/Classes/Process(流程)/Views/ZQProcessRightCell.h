//
//  ZQProcessRightCell.h
//  CarCheck
//
//  Created by zhangqiang on 2017/9/27.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQProcessRightCellDelegate

-(void)selectRightAtRow:(NSInteger )row index:(NSInteger )index;

@end

@interface ZQProcessRightCell : UITableViewCell

@property(nonatomic,strong)NSArray *dataArray;

@property(assign,nonatomic)id<ZQProcessRightCellDelegate> delegate;

@end
