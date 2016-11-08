//
//  ZZHMacros.h
//  PhotoFlows
//
//  Created by Charles on 16/11/4.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#ifndef ZZHMacros_h
#define ZZHMacros_h

//Log
#ifdef DEBUG
#   define ZZHDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define ZZHDLog(...)
#endif
//iDevice
#define ZZHiPhoneDevice                 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define ZZHiPadDevice                   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

//iOS
#define ZZHiOS7_OR_LATER                ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending )
#define ZZHiOS8_OR_LATER                ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending )
#define ZZHiOS9_OR_LATER                ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending )
#define ZZHiOS10_OR_LATER                ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending )


//Screen, iphone screen
//see http://stackoverflow.com/a/26697326/371974
#define ZZHSCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define ZZHSCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define ZZHSCREEN_MAX_LENGTH            (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define ZZHSCREEN_MIN_LENGTH            (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define ZZHIS_IPHONE_4_OR_LESS          (ZZHiPhoneDevice && ZZHSCREEN_MAX_LENGTH < 568.0)
#define ZZHIS_IPHONE_5                  (ZZHiPhoneDevice && ZZHSCREEN_MAX_LENGTH == 568.0)
#define ZZHIS_IPHONE_6                  (ZZHiPhoneDevice && ZZHSCREEN_MAX_LENGTH == 667.0)
#define ZZHIS_IPHONE_6P                 (ZZHiPhoneDevice && ZZHSCREEN_MAX_LENGTH == 736.0)

//singleton
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
- (nullable __class *)sharedInstance; \
+ (nullable __class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (nullable __class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (nullable __class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
}

#define ZZHBundlePath(X, Y)      [[NSBundle mainBundle] pathForResource:X ofType:Y]

#define ZZHLocalizedString(__X__)       NSLocalizedString((__X__), nil)

#endif /* ZZHMacros_h */
