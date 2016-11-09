//
//  ZZStoreKitHandler.h
//  
//
//  Created by Charles on 16/10/25.
//  Copyright © 2016年 Ch J. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class SKPaymentTransaction;

/**
 struct definitions
 */
typedef enum : NSUInteger {
    ZZSKErrorInvalid = 300,
    ZZSKErrorNA,
    ZZSKErrorReceiptVerifyFailed,
    ZZSKErrorRestoreFailed,
} ZZSKErrorCode;


typedef NS_ENUM(NSInteger, ZZSKTransactionState) {
    ZZSKTransactionStatePurchasing,    // Transaction is being added to the server queue.
    ZZSKTransactionStatePurchased,     // Transaction is in queue, user has been charged.  Client should complete the transaction.
    ZZSKTransactionStateFailed,        // Transaction was cancelled or failed before being added to the server queue.
    ZZSKTransactionStateRestored,      // Transaction was restored from user's purchase history.  Client should complete the transaction.
    ZZSKTransactionStateDeferred,   // The transaction is in the queue, but its final status is pending external action.
};


/**
 Block Definitions
 */

typedef void(^ZZSKSuccessBlock)(NSString *name, NSString *localPrice);
typedef void(^ZZSKFailBlock)(NSError *error);
typedef void(^ZZSKTransactionBlock)(ZZSKTransactionState state);
typedef void(^ZZSKRestoreSuccess)(void);

/**
 simple iap
 only for non-consumable
 */
@interface ZZStoreKitHandler : NSObject
/**
 ProductRequest,etc must be retained
 so we use a single to hold these objects
 should call in AppDelegate
 */
+(instancetype)sharedInstance;

/**
 Currently we only have one product
 for test
 */
- (BOOL)isProductAvailable;
/**
 query whether product is available
 1. show HUD before call
 2. pop alert to show product and actions
 3. pop alert if error happens
 */
- (void)queryProductResult:(ZZSKSuccessBlock)success FailAction:(ZZSKFailBlock)fail;
/**
 Only one product so simplify it
 Only do UI related works; others will be done by this handler
 */

- (void)purchaseProductResult:(ZZSKTransactionBlock)transaction;
/**
 
 */
- (void)restoreProductSuccess:(ZZSKRestoreSuccess)success Fail:(ZZSKFailBlock)fail;
/**
 only check whether a receipt exists or not
 no validation
 */
+ (BOOL)receiptDataExist;
/**
 verify whether Ads is purchased
 */
+ (BOOL)isAdsRemovedPurchased;
@end
