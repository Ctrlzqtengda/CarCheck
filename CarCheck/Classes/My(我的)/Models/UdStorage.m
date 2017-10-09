//
//  UdStorage.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "UdStorage.h"

@implementation UdStorage

+(void)storageObject:(id)object forKey:(NSString*)key{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:object forKey:key];
    [ud synchronize];
}

+(id)getObjectforKey:(NSString*)key{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}
@end
