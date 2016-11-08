//
//  ZZHTableStyleCollectionReusableView.m
//  PhotoFlows
//
//  Created by Charles on 16/11/7.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import "ZZHTableStyleCollectionCell.h"

@implementation ZZHTableStyleCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 
- (void)setSelected:(BOOL)selected
{
    if (self.isSelected)
    {
        [super setSelected:YES];
        self.labelTop.textColor = [UIColor grayColor];
    }
    else
    {
        [super setSelected:selected];
        if (selected)
        {
            self.labelTop.textColor = [UIColor grayColor];
        }
        else
        {
            self.labelTop.textColor = [UIColor blackColor];
        }

    }
}
#pragma mark - Public
+ (UINib *)cellNib
{
    return [UINib nibWithNibName:@"ZZHTableStyleCollectionCell" bundle:nil];
    
}
+ (NSString *)identifier;
{
    return @"ZZHTableStyleCollectionCellIdentifier";
}
//// 设置后cell并没有刷新，应该是CollectionView的刷新机制导致cell在下一次出行时更新了
- (void)setClicked:(BOOL)clicked
{
    if (clicked)
    {
        self.labelTop.textColor = [UIColor grayColor];
//        self.labelBottome.textColor = [UIColor grayColor];
    }
}
@end
