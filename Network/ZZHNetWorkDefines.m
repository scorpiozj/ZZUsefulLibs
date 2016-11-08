//
//  ZZHNetWorkDefines.m
//  PhotoFlows
//
//  Created by Charles on 16/11/4.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import "ZZHNetWorkDefines.h"

#pragma mark - URL Defines
//Relative URLs
#define ZZHURL(X, Y)            NSString *const ZZH##X##RelativeURL = @#Y;

ZZHURL(JSON, https:/\/raw.githubusercontent.com/scorpiozj/JSONFiles/master/json1)

#pragma mark - Request Input Keys
// Request Input Keys
#define ZZHInputKey(X, Y)       NSString *const ZZH##X##Key = @#Y;




#pragma mark - Response Key
// Response Keys
#define ZZHResKey(X, Y)         NSString *const ZZHResp##X##Key = @#Y
#define ZZHResKey2(X)           NSString *const ZZHResp##X##Key = @#X

ZZHResKey2(ProID);
ZZHResKey2(ProName);
ZZHResKey2(ProImgURL);
ZZHResKey2(ProDetailURL);
ZZHResKey2(ShopName);
ZZHResKey2(ProPrice);
ZZHResKey2(SalesMon);
ZZHResKey2(TBKURL);
