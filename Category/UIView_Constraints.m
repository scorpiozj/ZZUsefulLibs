//
//  UIView_Constraints.m
//  PhotoFlows
//
//  Created by Charles on 16/11/7.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import "UIView_Constraints.h"

@implementation UIView(Constraints)

- (NSArray *)constraintsWithSuperView:(UIEdgeInsets)edge;
{
    UIView *sView = self.superview;
    if (!sView)
    {
        return nil;
    }
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sView attribute:NSLayoutAttributeTop multiplier:1.0 constant:edge.top];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:edge.bottom];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:sView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:edge.left];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:sView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:edge.right];
    return @[top, bottom, leading, trailing];
}

@end
