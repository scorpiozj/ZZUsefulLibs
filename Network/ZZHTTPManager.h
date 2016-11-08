//
//  ZZHTTPManager.h
//  PhotoFlows
//
//  Created by Charles on 16/11/4.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "ZZHNetWorkDefines.h"
#import "ZZHMacros.h"

@protocol ZZHRequestCommonHandleProtocol <NSObject>
/**
 Handle non-100 code result:
 the base view controller can do  a default impementation;
 the child can call super or implement its own
 */
- (void)handleRequestCommonErrorCode:(NSInteger)code;
/**
 handle the http error: no json string returns
 the base view controller can do  a default impementation;
 the child can call super or implement its own
 */

- (void)handleRequestFailureError:(nullable NSError *)error Task:(nullable NSURLSessionDataTask *)task;
@end


@interface ZZHTTPManager : AFHTTPSessionManager
AS_SINGLETON(ZZHTTPManager);

- (nullable NSURLSessionDataTask *)ZZGET:(nullable NSString *)URLString
                   parameters:(nullable id)parameters
                      success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask  * _Nullable task, NSError * _Nullable error))failure
                     delegate:(nullable id<ZZHRequestCommonHandleProtocol>)delegate;

@end
