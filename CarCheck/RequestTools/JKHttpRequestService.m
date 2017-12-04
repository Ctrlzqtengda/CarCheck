//
//  JKHttpRequestService.m
//  shopsN
//
//  Created by imac on 2017/2/10.
//  Copyright © 2017年 联系QQ:1084356436. All rights reserved.
//

#import "JKHttpRequestService.h"

@implementation JKHttpRequestService

+(void)POST:(NSString *)path withParameters:(NSDictionary *)params success:(SuccessCallBack)success failure:(FailureCallBack)fail animated:(BOOL)animated{
    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZQLoadingView showProgressHUD:@"loading..."];
        });
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,path];
    NSLog(@"post:path===%@\n%@",url,params);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[JKHttpClientTool sharedManager] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask *  task, id responseObject) {

        NSDictionary *dic = (NSDictionary*)responseObject;
        BOOL succe=NO;
        if ([dic[@"code"] integerValue] == 1) {
            succe = YES;
        }
        if (animated) {
            [ZQLoadingView showAlertHUD:dic[@"codeInfo"] duration:SXLoadingTime];
        }
        NSLog(@"接口返回数据%@",dic);
        success(responseObject,succe,dic);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        NSLog(@"%@",error.description);
        [ZQLoadingView showAlertHUD:@"网络故障" duration:SXLoadingTime];
        fail(error);
    }];
}
+(void)POST:(NSString *)path withParameters:(NSDictionary *)params success:(SuccessCallBack)success failure:(FailureCallBack)fail {
   
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,path];
    NSLog(@"post:path===%@\n%@",url,params);
    
    [[JKHttpClientTool sharedManager] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
        
//        NSError *error;
        NSDictionary *dic = (NSDictionary*)responseObject;
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"code"]];
        BOOL succe=NO;
        if ([str isEqualToString:@"0"]) {
            succe = YES;
        }
        if (succe) {
            //            [SXLoadingView showAlertHUD:@"加载成功" duration:SXLoadingTime];
        }else{
            if (![dic[@"message"] isEqualToString:@"暂无数据"]) {
//                [SXLoadingView showAlertHUD:[dic valueForKey:@"message"] duration:SXLoadingTime];
            }
        }
//        [SXLoadingView hideProgressHUD];
        NSLog(@"%@",dic[@"data"]);
        success(responseObject,succe,dic);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        NSLog(@"%@",error.description);
//        [SXLoadingView showAlertHUD:@"网络故障" duration:0.5];
    }];
}

+(void)GET:(NSString *)path withParameters:(NSDictionary *)params success:(SuccessCallBack)success failure:(FailureCallBack)fail animated:(BOOL)animated{
    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SXLoadingView showProgressHUD:@"loading..."];
        });
    }

     NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,path];
    NSLog(@"get:path===%@\n%@",url,params);
    [[JKHttpClientTool sharedManager] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        NSError *error;
        NSDictionary *dic = (NSDictionary*)responseObject;
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"code"]];
        BOOL succe=NO;
        if ([str isEqualToString:@"1"]) {
            succe = YES;
        }
        if (succe) {
//            [SXLoadingView showAlertHUD:@"加载成功" duration:SXLoadingTime];
        }else{
            if (IsNilString(dic[@"msg"])) {
//                [SXLoadingView showAlertHUD:@"加载失败" duration:SXLoadingTime];
            }else{
                if (![dic[@"msg"] isEqualToString:@"暂无数据"]) {
//                    [SXLoadingView showAlertHUD:[dic valueForKey:@"msg"] duration:SXLoadingTime];
                }
            }
        }
//        [SXLoadingView hideProgressHUD];
        NSLog(@"%@",dic[@"data"]);
        success(responseObject,succe,dic);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        fail(error);
//        [SXLoadingView showAlertHUD:@"网络故障" duration:0.5];
    }];
}

+(void)POST:(NSString *)path Params:(NSDictionary *)params NSData:(NSData *)imageData key:(NSString *)name success:(SuccessCallBack)success failure:(FailureCallBack)fail animated:(BOOL)animated{
    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZQLoadingView showProgressHUD:@"loading..."];
        });
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,path];
    NSLog(@"path ==%@%@",url,params);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>   formData) {
        if (imageData) {
            NSString *file  =[NSString stringWithFormat:@"%@.jpg",name];
            [formData appendPartWithFileData:imageData name:name fileName:file mimeType:@"image/png/jpeg/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZQLoadingView hideProgressHUD];
//        NSError *error;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:&error];
        NSDictionary *resulDic = (NSDictionary*)responseObject;
        BOOL succe=NO;
        if ([resulDic[@"code"] integerValue] == 1) {
            succe = YES;
        }
        [ZQLoadingView showAlertHUD:resulDic[@"codeInfo"] duration:SXLoadingTime];
        NSLog(@"%@",resulDic);
        success(responseObject,succe,resulDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+(void)POST:(NSString *)path Params:(NSDictionary *)params NSArray:(NSArray<NSData *> *)imageArr key:(NSString *)name success:(SuccessCallBack)success failure:(FailureCallBack)fail animated:(BOOL)animated{
    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZQLoadingView showProgressHUD:@"loading..."];
        });
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,path];
//    url = [Utility percentEncodingWithUrl:url];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //传图片传5张图片 暂定随便传
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageArr[0] name:@"u_car_pic1" fileName:@"u_car_pic1.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:imageArr[1] name:@"u_idcard_pic2" fileName:@"u_idcard_pic2.jpg" mimeType:@"image/jpeg"];

        [formData appendPartWithFileData:imageArr[2] name:@"u_idcard_pic3" fileName:@"u_idcard_pic3.jpg" mimeType:@"image/jpeg"];

        [formData appendPartWithFileData:imageArr[3] name:@"u_car_pic4" fileName:@"u_car_pic4.jpg" mimeType:@"image/jpeg"];

//        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//        for (NSInteger i = 0; i < imageArr.count; i++) {
//            [formData appendPartWithFileData:imageArr[i] name:[NSString stringWithFormat:@"%@_%ld",timeSp,(long)i] fileName:[NSString stringWithFormat:@"%@_%ld.jpg",timeSp,(long)i] mimeType:@"image/jpeg"];
//        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resulDic = (NSDictionary*)responseObject;
        NSLog(@"resulDicresulDic%@",resulDic);
        [ZQLoadingView hideProgressHUD];
        if ([resulDic[@"code"] integerValue] == 1) {
            [ZQLoadingView showAlertHUD:resulDic[@"codeInfo"] duration:SXLoadingTime];

        }else{
            [ZQLoadingView showAlertHUD:resulDic[@"codeInfo"] duration:SXLoadingTime];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errorerror%@",error);
        [ZQLoadingView hideProgressHUD];
    }];

    /*
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSLog(@"path ==%@%@",url,params);
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
        if (imageArr.count) {
            for (int i=0; i<imageArr.count; i++) {
                NSData *data = imageArr[i];
                NSString *file  =[NSString stringWithFormat:@"%@.jpg",data];
                NSString *names = [NSString stringWithFormat:@"%@%d",name,i+1];
                [formData appendPartWithFileData:data name:names fileName:file mimeType:@"image/png/jpeg/jpg"];
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SXLoadingView hideProgressHUD];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:&error];
        BOOL succe=NO;
        if ([dic[@"code"] integerValue] == 1) {
            succe = YES;
        }
        if (succe) {
         [ZQLoadingView showAlertHUD:dic[@"codeInfo"] duration:SXLoadingTime];
        }else{
//            [SXLoadingView showAlertHUD:[dic valueForKey:@"message"] duration:SXLoadingTime];
        }
        NSLog(@"%@",dic[@"data"]);
        success(responseObject,succe,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (animated) {
//            [SXLoadingView hideProgressHUD];
        }
        NSLog(@"%@",error.description);
        fail(error);
    }];
     */
}

+ (void)payPost:(NSString *)path Params:(NSDictionary *)params success:(SuccessCallBack)success failure:(FailureCallBack)fail animated:(BOOL)animated {
    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SXLoadingView showProgressHUD:@"loading..."];
        });
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseAPI,path];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 30;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSLog(@"path ==%@%@",url,params);
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
//            [SXLoadingView hideProgressHUD];
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            NSString *str = [NSString stringWithFormat:@"%@",dic[@"status"]];
            BOOL succe=NO;
            if ([str isEqualToString:@"1"]) {
                succe = YES;
            }

            if (succe) {
                //            [SXLoadingView showAlertHUD:@"加载成功" duration:SXLoadingTime];
            }else{
//                [SXLoadingView showAlertHUD:[dic valueForKey:@"message"] duration:SXLoadingTime];
            }
            NSLog(@"%@",dic[@"data"]);
            success(responseObject,succe,dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (animated) {
//            [SXLoadingView hideProgressHUD];
        }
        NSLog(@"%@",error.description);
        fail(error);
    }];
}


@end
