//
//  UdStorage.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdStorage : NSObject

// NSUserDefaults 存储数据   获取数据
+(void)storageObject:(id)object forKey:(NSString*)key;

+(id)getObjectforKey:(NSString*)key;
@end
