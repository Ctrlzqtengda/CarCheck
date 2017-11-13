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
//是否已同意预约须知协议
+(void)storageAgreeReservationNotice:(BOOL)agree forKey:(NSString*)key
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setBool:agree forKey:key];
    [ud synchronize];
}
+(BOOL)isAgreeReservationNoticeForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
+(NSMutableArray *)getMessageModelWithArray:(NSArray *)array
{
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in array) {
        ZQMessageModel *model = [[ZQMessageModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [mutArray addObject:model];
    }
    return mutArray;
}
@end
