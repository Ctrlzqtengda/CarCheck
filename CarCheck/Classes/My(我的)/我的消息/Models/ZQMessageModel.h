//
//  ZQMessageModel.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQMessageModel : NSObject

/**消息id*/
@property (strong,nonatomic) NSString *newsId;
/**消息标题*/
@property (strong,nonatomic) NSString *title;
/**消息时间戳*/
@property (strong,nonatomic) NSString *time;
/**消息内容*/
@property (strong,nonatomic) NSString *content;
/**图片*/
@property (strong,nonatomic) NSString *imageName;
@end
