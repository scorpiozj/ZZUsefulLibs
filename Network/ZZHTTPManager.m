//
//  ZZHTTPManager.m
//  PhotoFlows
//
//  Created by Charles on 16/11/4.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import "ZZHTTPManager.h"

static NSString *const CTWBaseURLString = @"";


@implementation ZZHTTPManager
DEF_SINGLETON(ZZHTTPManager);

- (instancetype)init
{
    // Session configuration setup
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                      diskCapacity:50 * 1024 * 1024
                                                          diskPath:nil];
    
    [sessionConfiguration setURLCache:cache];
    sessionConfiguration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    if (self = [super initWithBaseURL:[NSURL URLWithString:[CTWBaseURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] sessionConfiguration:sessionConfiguration])
    {
        //support unrestrict HTTP method
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
        
        
        
    }
    return self;
}

#pragma mark - Public
- (NSURLSessionDataTask *)ZZGET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure                     delegate:(id<ZZHRequestCommonHandleProtocol>)delegate
{
    __weak typeof(delegate) weakDelegate = delegate;
    return [super GET:URLString
           parameters:parameters
            progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  ZZHDLog(@"response: %@",responseObject);
                  __strong typeof(delegate) strongDelegate = weakDelegate;
                  NSArray *array = (NSArray *)responseObject;
                  NSInteger code = -1;
//                  if ([dic valueForKey:CTWRetCodeKey])
//                  {
//                      code = [dic[CTWRetCodeKey] integerValue];
//                  }
//                  if (100 == code)
//                  {
//                      success(task, responseObject[@"result"]);
//                  }
//                  else
//                  {
//                      if([URLString isEqualToString:CTWGetDailyReportRelativeURL])
//                      {
                          success(task, array);
//                      }
//                      else
//                      {
                          if (strongDelegate && [strongDelegate respondsToSelector:@selector(handleRequestCommonErrorCode:)])
                          {
                              [strongDelegate handleRequestCommonErrorCode:code];
                          }
//                      }
//                      
//                  }
                  
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  ZZHDLog(@"%@", error);
                  __strong typeof(delegate) strongDelegate = weakDelegate;
                  if (strongDelegate && [strongDelegate respondsToSelector:@selector(handleRequestFailureError:Task:)])
                  {
                      [strongDelegate handleRequestFailureError:error Task:task];
                  }
                  //                  else
                  {
                      failure(task, error);
                  }
              }];
    
}
@end
