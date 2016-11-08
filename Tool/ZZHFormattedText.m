//
//  ZZHFormattedText.m
//  PhotoFlows
//
//  Created by Charles on 16/11/8.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import "ZZHFormattedText.h"
#import <UIKit/UIKit.h>

@implementation ZZHFormattedText
+ (NSString *)productPlainName:(NSString *)pName;
{
    return pName;
}
+ (NSAttributedString *)descriptionAttributedWith:(NSString *)des;
{
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:des];
    
    UIColor *orangeColor = [UIColor orangeColor];
    UIColor *grayColor = [UIColor grayColor];
    
    UIFont *little = [UIFont systemFontOfSize:12];
    UIFont *big = [UIFont systemFontOfSize:16];
    
    NSRange symbolRange = NSMakeRange(0, 1);
    NSRange dotRange = [des rangeOfString:@"."];
    
    //color and font
    [mStr addAttributes:@{NSForegroundColorAttributeName:orangeColor, NSFontAttributeName:little} range:NSMakeRange(0, dotRange.location + 2 + 1)];
    NSUInteger loc = symbolRange.location + symbolRange.length;
    [mStr addAttributes:@{NSFontAttributeName:big} range:NSMakeRange(loc, dotRange.location - loc)];
    
    loc = dotRange.location + dotRange.length + 2;
    [mStr addAttributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:little} range:NSMakeRange(loc, des.length - loc)];
    
    return mStr;
}
@end
