//
//  UdStorage.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQMessageModel.h"

@interface UdStorage : NSObject

// NSUserDefaults 存储数据   获取数据
+(void)storageObject:(id)object forKey:(NSString*)key;

+(id)getObjectforKey:(NSString*)key;

//是否已同意预约须知协议
+(void)storageAgreeReservationNotice:(BOOL)agree forKey:(NSString*)key;
+(BOOL)isAgreeReservationNoticeForKey:(NSString*)key;

+(NSMutableArray *)getMessageModelWithArray:(NSArray *)array;
@end
