//
//  ZZHFormattedText.h
//  PhotoFlows
//
//  Created by Charles on 16/11/8.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZHFormattedText : NSObject
+ (NSString *)productPlainName:(NSString *)pName;
+ (NSAttributedString *)descriptionAttributedWith:(NSString *)des;
@end
