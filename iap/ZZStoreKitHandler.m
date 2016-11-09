//
//  ZZStoreKitHandler.m
//  
//
//  Created by Charles on 16/10/25.
//  Copyright © 2016年 Ch J. All rights reserved.
//

#import "ZZStoreKitHandler.h"
#import <StoreKit/StoreKit.h>
//#import "RMStoreAppReceiptVerifier.h"

NSString *const kProductPlistName       = @"iap";
NSString *const ZZSKErrorDomain         = @"com.zzsk.currency";
NSString *const ZZSKReceiptKey          = @"ZZSKReceipt_Key1";

NSString *const ZZSKPurchasedKey        = @"com_zzsk.OKKey";
/**
 Must finishTransaction:
 
 */
@interface ZZStoreKitHandler ()<SKProductsRequestDelegate, SKPaymentTransactionObserver,SKRequestDelegate>
{
    
}

@property (nonatomic, strong) SKProductsRequest *productRequest;
@property (nonatomic, strong) NSArray<SKProduct *> *productArray;

//确认Product
@property (nonatomic, strong) ZZSKSuccessBlock successBlock;
@property (nonatomic, strong) ZZSKFailBlock failBlock;
//Transaction
@property (nonatomic, strong) ZZSKTransactionBlock transactionBlock;

//Restore
@property (nonatomic, strong) SKReceiptRefreshRequest *restoreRequest;
@property (nonatomic, strong) ZZSKRestoreSuccess restoreSuccessBlock;
@property (nonatomic, strong) ZZSKFailBlock restoreFailBlock;
@end

@implementation ZZStoreKitHandler
- (instancetype)init
{
    if (self = [super init])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
#pragma mark - Public
+(instancetype)sharedInstance
{
    static ZZStoreKitHandler *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (handle == nil)
        {
            handle = [[ZZStoreKitHandler alloc] init];
        }
    });
    return handle;
}
- (BOOL)isProductAvailable
{
    if (self.productArray)
    {
        return self.productArray.count?YES:NO;
    }
    else
    {
        [self p_validateProcuctsFromPlist];
    }
    return NO;
}
- (void)queryProductResult:(ZZSKSuccessBlock)success FailAction:(ZZSKFailBlock)fail;
{
    self.successBlock = success;
    self.failBlock = fail;
    
    [self p_validateProcuctsFromPlist];
    
}

- (void)purchaseProductResult:(ZZSKTransactionBlock)transaction
{
    self.transactionBlock = transaction;
    
    SKProduct *product = self.productArray[0];
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)restoreProductSuccess:(ZZSKRestoreSuccess)success Fail:(ZZSKFailBlock)fail;
{
    self.restoreSuccessBlock = success;
    self.restoreFailBlock = fail;
    
//    SKReceiptRefreshRequest *temp = [[SKReceiptRefreshRequest alloc] init];
//    temp.delegate = self;
//    self.restoreRequest = temp;
//    [self.restoreRequest start];
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

+ (BOOL)receiptDataExist
{
    NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data.length)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isAdsRemovedPurchased;
{
//    if ([[self class] receiptDataExist])
//    {
//        //verify receipt
//        return [self p_validateLocalReceipt];
//    }
//    return NO;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL result = [userDefault boolForKey:ZZSKPurchasedKey];
    
    return result;
}
#pragma mark - Private
- (void)p_validateProcuctsFromPlist
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:kProductPlistName withExtension:@"plist"];
    NSArray *productIdentifier = [NSArray arrayWithContentsOfURL:url];
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifier]];
    // Keep a strong reference to the request.
    self.productRequest = productsRequest;
    productsRequest.delegate = self;
    [productsRequest start];
}

+ (BOOL)p_validateLocalReceipt
{
#warning - todo
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *data = [NSData dataWithContentsOfURL:receiptURL];
    
    return data.length > 0;
//    RMStoreAppReceiptVerifier *verify = [[RMStoreAppReceiptVerifier alloc] init];
//    verify.bundleIdentifier = @"com.zhjxml.supercurrency";
//    verify.bundleVersion = @"1.1.1";
//    BOOL result = [verify verifyAppReceipt];
//    return result;
}
#pragma mark - Private for Transaction
- (void)p_purchasing:(SKPaymentTransaction *)transaction
{
    
}
- (void)p_deferred:(SKPaymentTransaction *)transaction
{
    
}

- (void)p_purchased:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *data = [NSData dataWithContentsOfURL:receiptURL];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedReceipts = [userDefaults arrayForKey:ZZSKReceiptKey];
    if (!savedReceipts)
    {
        [userDefaults setObject:@[data] forKey:ZZSKReceiptKey];
    }
    else
    {
        NSArray *updatedReceipts = [savedReceipts arrayByAddingObject:data];
        [userDefaults setObject:updatedReceipts forKey:ZZSKReceiptKey];
    }
    
    [userDefaults setBool:YES forKey:ZZSKPurchasedKey];
    [userDefaults synchronize];
}

- (void)p_failed:(SKPaymentTransaction *)transaction
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.restoreFailBlock)
    {
        NSError *error = [NSError errorWithDomain:ZZSKErrorDomain code:ZZSKErrorRestoreFailed userInfo:nil];
        self.restoreFailBlock(error);
        self.restoreSuccessBlock = nil;
        self.restoreFailBlock = nil;
        
        [userDefaults setBool:NO forKey:ZZSKPurchasedKey];
    }
    else if (self.failBlock)
    {
        NSError *error = [NSError errorWithDomain:ZZSKErrorDomain code:ZZSKErrorInvalid userInfo:nil];
        self.failBlock(error);
        self.failBlock = nil;
        self.successBlock = nil;
        [userDefaults setBool:NO forKey:ZZSKPurchasedKey];
    }
    [userDefaults synchronize];
}

- (void)p_restored:(SKPaymentTransaction *)transaction
{
    if (self.restoreSuccessBlock)
    {
        self.restoreSuccessBlock();
        self.restoreSuccessBlock = nil;
        self.restoreFailBlock = nil;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:ZZSKPurchasedKey];
        [userDefaults synchronize];
    }
    
    
}
/**
 used in Delegate: paymentQueueRestoreCompletedTransactionsFinished
 */
- (void)p_restoredFailed
{
    if(self.restoreFailBlock)
    {
        NSError *error = [NSError errorWithDomain:ZZSKErrorDomain code:ZZSKErrorRestoreFailed userInfo:nil];
        self.restoreFailBlock(error);
        self.restoreSuccessBlock = nil;
        self.restoreFailBlock = nil;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:ZZSKPurchasedKey];
        [userDefaults synchronize];
    }
}

- (void)p_restoredSuccess
{
    if(self.restoreSuccessBlock)
    {
        self.restoreSuccessBlock();
        self.restoreSuccessBlock = nil;
        self.restoreFailBlock = nil;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:ZZSKPurchasedKey];
        [userDefaults synchronize];
    }

}
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (response.invalidProductIdentifiers.count)
    {
        if (self.failBlock)
        {
            NSError *error = [NSError errorWithDomain:ZZSKErrorDomain code:ZZSKErrorInvalid userInfo:nil];
            self.failBlock(error);
        }
    }
    else
    {
        self.productArray = response.products;
        if (self.productArray.count)
        {
            SKProduct *product = self.productArray[0];
            if (self.successBlock)
            {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                [numberFormatter setLocale:product.priceLocale];
                NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
                self.successBlock([product localizedTitle], [NSString stringWithFormat:@"%@", formattedPrice]);
            }
        }
        else
        {
            NSError *error = [NSError errorWithDomain:ZZSKErrorDomain code:ZZSKErrorNA userInfo:nil];
            self.failBlock(error);
        }
    }
}
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    DLog(@"transactions:%@", transactions);
    for (SKPaymentTransaction *transaction in transactions) {
        
        ZZSKTransactionState state = transaction.transactionState;
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                [self p_purchasing:transaction];
//                [self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
                [self p_deferred:transaction];
//                [self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed:
                [self p_failed:transaction];
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self p_purchased:transaction];
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self p_restoredSuccess];
                [queue finishTransaction:transaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
        if (self.transactionBlock)
        {
            self.transactionBlock(state);
        }
        
//        break;
    }
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error NS_AVAILABLE_IOS(3_0);
{
    DLog();
    [self p_restoredFailed];
}
// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    DLog();
    if (queue.transactions.count == 0)
    {
        [self p_restoredFailed];
    }
    else
    {
        for (SKPaymentTransaction *transaction in queue.transactions)
        {
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchasing:
                    break;
                case SKPaymentTransactionStateDeferred:
                    break;
                case SKPaymentTransactionStateFailed:
                    [self p_restoredFailed];
                    [queue finishTransaction:transaction];
                    break;
                case SKPaymentTransactionStatePurchased:
                    break;
                case SKPaymentTransactionStateRestored:
                    [self p_restored:transaction];
                    [queue finishTransaction:transaction];
                    break;
                    
            }
        }
    }
    
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads
{
    DLog();
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    DLog();
    for (SKPaymentTransaction *transaction in transactions)
    {
        //in case there is transaction missing to be finished
        [queue finishTransaction:transaction];
        
//        if (transaction.transactionState == SKPaymentTransactionStatePurchased)
//        {
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setBool:YES forKey:ZZSKPurchasedKey];
//            [userDefaults synchronize];
//            break;
//        }
//        NSLog(@"error=%@, identifier=%@, receipt=%ld", transaction.error, transaction.transactionIdentifier,(long)transaction.transactionState);
    }
}
#pragma mark -  SKRequestDelegate
- (void)requestDidFinish:(SKRequest *)request NS_AVAILABLE_IOS(3_0);
{
    if(request == self.restoreRequest)
    {
        
    }
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    if (request == self.restoreRequest)
    {
        if(self.restoreFailBlock)
        {
            NSError *error = [NSError errorWithDomain:ZZSKErrorDomain code:ZZSKErrorReceiptVerifyFailed userInfo:nil];
            self.restoreFailBlock(error);
            self.restoreSuccessBlock = nil;
            self.restoreFailBlock = nil;
        }
        self.restoreRequest.delegate = nil;
        self.restoreRequest = nil;
    }
}
@end
