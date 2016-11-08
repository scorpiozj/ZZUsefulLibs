//
//  ZZHTableStyleFlowLayout.m
//  PhotoFlows
//
//  Created by Charles on 16/11/4.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import "ZZHTableStyleFlowLayout.h"


const NSUInteger    kColumnDefault      = 1;
const CGFloat       kItemSpacing        = 1.0;
const CGFloat       kItemHeight         = 80.0;

@interface ZZHTableStyleFlowLayout ()
@property (nonatomic, assign) NSUInteger column;
@end


@implementation ZZHTableStyleFlowLayout
- (instancetype)init
{
    if (self = [self initWithColumn:kColumnDefault])
    {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.column = kColumnDefault;
        [self p_commonInit];
    }
    return self;
}
#pragma mark - Public
- (instancetype)initWithColumn:(NSUInteger)col;
{
    if (self = [super init])
    {
        self.column = col;
        [self p_commonInit];
    }
    return self;
}
#pragma mark - Private
- (void)p_commonInit
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.column = kColumnDefault;
    
    
    CGFloat itemWidth = (screenWidth - kItemSpacing * (self.column -1 )) /self.column;
    self.itemSize = CGSizeMake(itemWidth, kItemHeight);
    self.minimumInteritemSpacing = kItemSpacing;
    
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark - Public
@end
