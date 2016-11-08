//
//  ZZHNetWorkDefines.h
//  PhotoFlows
//
//  Created by Charles on 16/11/4.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - URL Defines
/**
 Relative URL defines
 */
#define     ZZHURLDef(X)            FOUNDATION_EXPORT NSString *const ZZH##X##RelativeURL;
ZZHURLDef(JSON);

#pragma mark - Request Input Keys
/**
 Request Input Keys
 */
#define     ZZHInputKeyDef(X)       FOUNDATION_EXPORT NSString *const ZZH##X##Key;


#pragma mark - Response Key
/**
 Response Key
 */

#define     ZZHRespKeyDef(X)        FOUNDATION_EXPORT NSString *const ZZHResp##X##Key;

ZZHRespKeyDef(ProID);
ZZHRespKeyDef(ProName);
ZZHRespKeyDef(ProImgURL);
ZZHRespKeyDef(ProDetailURL);
ZZHRespKeyDef(ShopName);
ZZHRespKeyDef(ProPrice);
ZZHRespKeyDef(SalesMon);
ZZHRespKeyDef(TBKURL);




