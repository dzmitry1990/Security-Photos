//
//  MMInAppPurchaseManager.h
//  MillionMoji
//
//  Created by Dzmitry Zhuk on 8/27/16.
//  Copyright © 2016 Fam, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STInAppPurchaseManagerDelegate;

@interface STInAppPurchaseManager : NSObject

+ (id)sharedManager;
@property (nonatomic, weak) id<STInAppPurchaseManagerDelegate> delegate;


-(void) buyProduct:(NSInteger)index;
-(void)restoreProduct;

@end


@protocol STInAppPurchaseManagerDelegate <NSObject>

@required
- (void)didFinishBuyingProduct:(NSInteger)index success:(BOOL)success withErrorMessage:(NSString*)message withReceipt:(NSString*)receipt;

@end

