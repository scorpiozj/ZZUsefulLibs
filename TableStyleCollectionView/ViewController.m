//
//  ViewController.m
//  PhotoFlows
//
//  Created by Charles on 16/11/4.
//  Copyright © 2016年 Charles Zhu. All rights reserved.
//

#import "ViewController.h"
#import "ZZHTableStyleFlowLayout.h"
#import "ZZHTTPManager.h"
#import "ZZHTableStyleCollectionCell.h"
#import "UIView_Constraints.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ZZHFormattedText.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableSet *clickedSet;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZZHTableStyleFlowLayout *layout = [[ZZHTableStyleFlowLayout alloc] init];
    
    UICollectionView *temp = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [temp registerNib:[ZZHTableStyleCollectionCell cellNib] forCellWithReuseIdentifier:[ZZHTableStyleCollectionCell identifier]];
    temp.allowsMultipleSelection = YES;
    [self.view addSubview:temp];
    self.collectionView = temp;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    NSArray *arrayConstraints = [self.collectionView constraintsWithSuperView:UIEdgeInsetsMake(0, 0, 0, 0)];
    temp.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:arrayConstraints];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    NSString *urlString = ZZHJSONRelativeURL;
    NSLog(@"%@", urlString);
    __weak typeof(self) weakSelf = self;
    [[ZZHTTPManager sharedInstance] ZZGET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                                      NSLog(@"%@, %@", task, responseObject);
                                      if ([responseObject isKindOfClass:[NSArray class]])
                                      {
                                          __strong typeof(weakSelf) strongSelf = weakSelf;
                                          strongSelf.dataArray = responseObject;
                                          [strongSelf.collectionView reloadData];
                                      }
    }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }
                                 delegate:nil];
    
    _clickedSet = [NSMutableSet setWithCapacity:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.dataArray.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    ZZHTableStyleCollectionCell *reuseView = (ZZHTableStyleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[ZZHTableStyleCollectionCell identifier] forIndexPath:indexPath];
    if ([self.clickedSet containsObject:indexPath])
    {
        [reuseView setSelected:YES];
    }
    else
    {
        [reuseView setSelected:NO];
    }
    reuseView.labelTop.text = [ZZHFormattedText productPlainName:dic[ZZHRespProNameKey]];
    NSString *botomString = [NSString stringWithFormat:@"¥%@   月销 %@", dic[ZZHRespProPriceKey], dic[ZZHRespSalesMonKey]];
    reuseView.labelBottome.attributedText = [ZZHFormattedText descriptionAttributedWith:botomString];;
    [reuseView.imgView setImageWithURL:[NSURL URLWithString:dic[ZZHRespProImgURLKey]]];
     
    return reuseView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.clickedSet addObject:indexPath];
}
@end
