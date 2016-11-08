//
//  ZZHTableStyleFlowLayout.h
//  PhotoFlows
//
//  Created by Charles on 16/11/4.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Table View Style Collection View Flow Layout;
 Collection supports add Dynamic animator
 */
@interface ZZHTableStyleFlowLayout : UICollectionViewFlowLayout
- (instancetype)initWithColumn:(NSUInteger)column;
@end
