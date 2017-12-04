//
//  NSDictionary+propertyCode.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/27.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "NSDictionary+propertyCode.h"

@implementation NSDictionary (propertyCode)

- (void)createProperty {
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
    if ([value isKindOfClass:[NSString class]]) {
        NSLog(@"%@", [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;", key]);
    }else if ([value isKindOfClass:[NSArray class]]) {
        NSLog(@"%@", [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@", key]);
    }else if ([value isKindOfClass:[NSNumber class]]) {
        NSLog(@"%@", [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger key;"]);
    }}];
}
@end
