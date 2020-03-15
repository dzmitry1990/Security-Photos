//
//  STInAppPurchaseManager.m
//  MillionMoji
//
//  Created by Dzmitry Zhuk on 8/27/16.
//  Copyright © 2016 Fam, Inc. All rights reserved.
//

#import "STInAppPurchaseManager.h"
#import <StoreKit/StoreKit.h>
#import <iAd/iAd.h>

@interface STInAppPurchaseManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>


@property(nonatomic, strong) NSArray * productIDs;
@property(nonatomic, strong) NSMutableArray * productsArray;

@end

@implementation STInAppPurchaseManager



+ (id)sharedManager {
    static STInAppPurchaseManager *sharedSearchManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSearchManager = [[self alloc] init];
        
    });
    return sharedSearchManager;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        
        self.productIDs=[NSArray arrayWithObjects:@"safekeys",nil];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [self getListOfProducts];

    }
    return self;
}


-(void) getListOfProducts
{
    if ([SKPaymentQueue canMakePayments]) {
        NSSet * productIdentifiers = [NSSet setWithArray: self.productIDs];
        SKProductsRequest * productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        
        productRequest.delegate = self;
        [productRequest start];
    }
    else {
        NSLog(@"Cannot perform In App Purchases.");
    }
}

#pragma mark SKProductsRequestDelegate

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"productsRequest");
    
    
    self.productsArray = [[NSMutableArray alloc] initWithCapacity:[self.productIDs count]];
    for (NSUInteger i = 0; i < [self.productIDs count]; i++) {
        [self.productsArray addObject:[NSNull null]];
    }
    
    
    if([response products].count != 0) {
        for(SKProduct * product in [response products]) {
            
            NSLog(@"product: %@",product.productIdentifier);
            
            if([product.productIdentifier isEqualToString:self.productIDs[0]])
            {
                self.productsArray[ [self.productIDs indexOfObject:product.productIdentifier] ]=product;
            }
            //[self.productsArray addObject:product];
            
        }
        
    }
    else {
        NSLog(@"There are no products.");
    }
    
//    if([response invalidProductIdentifiers].count != 0) {
//        NSLog(@"%@",[response invalidProductIdentifiers].description);
//    }
    
    
    //[self.delegate didGetProductsList];
    
    //[self buyProduct:0];

}

-(NSDictionary*)productDetails:(NSInteger)index {
    
    
    SKProduct * product = self.productsArray[index];
    
    return @{@"credits":[product.localizedTitle stringByReplacingOccurrencesOfString:@" credits" withString:@""],@"price":[NSString stringWithFormat:@"$%@",product.price]};
    
}
-(NSInteger)numberOfProducts {
    
    return (self.productsArray == nil) ? 0 : [self.productsArray count];
}
-(void)buyProduct:(NSInteger)index {
    
    
    
    if(self.productsArray[index] == [NSNull null])
    {
        [self.delegate didFinishBuyingProduct:index success:NO withErrorMessage:@"There was an error retriving the product from Apple" withReceipt:nil];

    }
    else {
        
        
        if ([SKPaymentQueue canMakePayments]) {
            
            SKPayment * payment = [SKPayment paymentWithProduct: self.productsArray[index]];
            
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else {
            
            NSLog(@"Can't make payments");
            [self.delegate didFinishBuyingProduct:index success:NO withErrorMessage:@"Your iTunes account can't make payments" withReceipt:nil];
        }
        
    }
    
}

-(void)restoreProduct {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

}

#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction * transaction in transactions)
    {
        NSLog(@"transaction.identifier: %@",transaction.transactionIdentifier);

        switch (transaction.transactionState) {
                
                
            case SKPaymentTransactionStatePurchased:
                
                NSLog(@"removedTransactions: Transaction completed successfully.");
                break;
            case SKPaymentTransactionStateRestored:
                
                NSLog(@"removedTransactions: Transaction restored successfully.");
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"removedTransactions: Transaction Failed");
                NSLog(@"Transaction error: %@", transaction.error.localizedDescription);

                break;
                
            default:
                NSLog(@"removedTransactions: TransactionState %d",transaction.transactionState);
                break;
                
        }
        
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions NS_AVAILABLE_IOS(3_0) {
    
    for (SKPaymentTransaction * transaction in transactions)
    {
        NSLog(@"transaction.identifier: %@",transaction.transactionIdentifier);
        
        if(transaction.transactionIdentifier==nil) return;
        
        
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"SKPaymentTransactionStatePurchasing");
                
                break;
                
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"SKPaymentTransactionStatePurchased");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                NSData *dataReceipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                NSString *receipt = [dataReceipt base64EncodedStringWithOptions:0];

                //[self getStoreReceipt];
                
                [self.delegate didFinishBuyingProduct:[self.productIDs indexOfObject:transaction.payment.productIdentifier] success:YES withErrorMessage:nil withReceipt:receipt];
                
                
                [self logPurchase];
                [self logPurchaseAttribution];
                
                
                
                break;
            }
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"SKPaymentTransactionStateRestored");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                NSData *dataReceipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                NSString *receipt = [dataReceipt base64EncodedStringWithOptions:0];
                
                //[self getStoreReceipt];
                
                [self.delegate didFinishBuyingProduct:[self.productIDs indexOfObject:transaction.payment.productIdentifier] success:YES withErrorMessage:nil withReceipt:receipt];
                
                
                
                break;
            }
                
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"SKPaymentTransactionStateFailed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self.delegate didFinishBuyingProduct:[self.productIDs indexOfObject:transaction.payment.productIdentifier] success:NO withErrorMessage:@"Failed" withReceipt:nil];

                break;
                
            default:
                NSLog(@"%d",transaction.transactionState);
                break;
                
                
        }
        
    }
    
}


-(void) dealloc {
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}

-(void) getStoreReceipt {
    
    // Load the receipt from the app bundle.
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    if (!receipt) { /* No local receipt -- handle the error. */ }
    
    
    
    // Create the JSON object that describes the request
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { /* ... Handle error ... */ }
    
    // Create a POST request with the receipt data.
#ifdef DEBUG
    NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
#else
    NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
#endif
    
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // Make a connection to the iTunes Store on a background queue.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   /* ... Handle error ... */
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) { /* ... Handle error ...*/ }
                                   /* ... Send a response back to the device ... */
                                   
                                   NSLog(@"jsonResponse %@",jsonResponse);
                               }
                           }];

    
}

-(void)logPurchase {
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]!=nil)
    {
        
        
        
        NSData *requestData;
        
        
        requestData = [NSJSONSerialization dataWithJSONObject:@{@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"receipt":[[NSUserDefaults standardUserDefaults] objectForKey:@"receipt"]} options:0 error:nil]; //TODO handle error
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://safekeys-app.com/log-purchase/"]];
        
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             
             
             NSDictionary * jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             NSLog(@"jsonResponse %@",jsonResponse);
         }];
        
        
    }
    
    
}

-(void)logPurchaseAttribution {
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]!=nil)
    {
        
        
        
        __weak typeof(self) weakSelf = self;
        
        
        // Check for iOS 10 attribution implementation
        if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
            NSLog(@"iOS 10 call exists");
            [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *attributionDetails, NSError *error) {
                // Look inside of the returned dictionary for all attribution details
                NSLog(@"Attribution Dictionary: %@", attributionDetails);
                
                
                NSData *requestData;
                
                
                if (error) {
                    NSLog(@"Request Search Ads attributes failed with error: %@", error.description);
                    
                    if (error.code == ADClientErrorLimitAdTracking) {
                        NSLog(@"Limit Ad Tracking is enabled for this device.");
                    }
                    
                    requestData = [NSJSONSerialization dataWithJSONObject:@{@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} options:0 error:nil]; //TODO handle error
                    
                }
                else {
                    NSLog(@"Search Ads attributes: %@", attributionDetails);
                    
                    requestData = [NSJSONSerialization dataWithJSONObject:@{@"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"attribution":attributionDetails} options:0 error:nil]; //TODO handle error
                    
                }
                
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://safekeys-app.com/log-purchase-attribution/"]];
                
                
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody: requestData];
                
                [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                 {
                     
                     
                     NSDictionary * jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                     
                     NSLog(@"jsonResponse %@",jsonResponse);
                     
                     
                 }];
                
                
                
            }];
        }
        
        
        
    }
    
    
}
@end
