//
//  ZZHTableStyleCollectionReusableView.h
//  PhotoFlows
//
//  Created by Charles on 16/11/7.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ZZHTableStyleCollectionCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *labelTop;
@property (nonatomic, weak) IBOutlet UILabel *labelBottome;

+ (UINib *)cellNib;
+ (NSString *)identifier;

//@property (nonatomic, getter=isClicked) BOOL clicked;

@end
