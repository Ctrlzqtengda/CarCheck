//
//  ZQValuationCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/18.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQValuationCellDelegate <NSObject>

//-(void)addPhotos:(NSInteger)tag;

-(void)giveStar:(NSInteger)star index:(NSInteger)tag;

-(void)evaluteText:(NSString *)string index:(NSInteger)tag;

@end

@interface ZQValuationCell : UITableViewCell

@property (weak,nonatomic) id<ZQValuationCellDelegate>delegate;

//@property (strong,nonatomic) YOrderEvalueModel *model;
+ (CGFloat)getValuationCellHeight;

@end
