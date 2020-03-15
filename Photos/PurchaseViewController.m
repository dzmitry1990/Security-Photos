//
//  PurchaseViewController.m
//  ShareExtension
//
//  Created by Dzmitry Zhuk on 7/26/17.
//  Copyright © 2017 Fam, Inc. All rights reserved.
//

#import "PurchaseViewController.h"


#import "STInAppPurchaseManager.h"
#import "DefaultPurchaseViewController.h"

@interface PurchaseViewController ()<STInAppPurchaseManagerDelegate>
{
    BOOL _completedPurchase;
}

@property(nonatomic,strong) UIView * aboutView;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImageView.image=[UIImage imageNamed:@"background.png"];
    backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImageView];

    
    
    
    UIView * purchaseView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-560.0/2.0)/2.0, (self.view.frame.size.height-560.0/2.0)/2.0, 560.0/2.0, 560.0/2.0)];
    purchaseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:purchaseView];
    
    UILabel * topLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0/2.0,46.0/2.0-5, purchaseView.frame.size.width-40.0/2.0*2, 86.0/2.0+10)];
    //topLabel.backgroundColor=[UIColor greenColor];
    topLabel.text=@"Please continue for\nfree trial!";
    topLabel.numberOfLines=2;
    topLabel.textAlignment=NSTextAlignmentCenter;
    topLabel.textColor=[UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
    topLabel.font=[UIFont systemFontOfSize:40.0/2.0 weight:UIFontWeightSemibold];
    [purchaseView addSubview:topLabel];
    
    
    UIButton * purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    purchaseButton.frame=CGRectMake(40.0/2.0, 200.0/2.0, purchaseView.frame.size.width-40.0/2.0*2, 100.0/2.0);
    purchaseButton.backgroundColor=[UIColor colorWithRed:253/255.0 green:79.0/255.0 blue:43.0/255.0 alpha:1.0];
    [purchaseButton setTitle:@"TRY FOR FREE" forState:UIControlStateNormal];
    [purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    purchaseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    purchaseButton.contentEdgeInsets = UIEdgeInsetsMake(0, 51.0/2.0, 0, 0);
    purchaseButton.titleLabel.font=[UIFont systemFontOfSize:34.0/2.0 weight:UIFontWeightSemibold];
    [purchaseButton setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
    purchaseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 366.0/2.0, 0, 0);
    purchaseButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [purchaseButton addTarget:self action:@selector(didTapPurchaseButton) forControlEvents:UIControlEventTouchUpInside];
    [purchaseView addSubview:purchaseButton];
    
    
    UILabel * bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0/2.0,purchaseView.frame.size.height-182.0/2.0-5, purchaseView.frame.size.width-40.0/2.0*2, 28.0/2.0+10)];
    //bottomLabel.backgroundColor=[UIColor greenColor];
    bottomLabel.text=@"Cloud archiving up to 7GB!";
    bottomLabel.numberOfLines=1;
    bottomLabel.textAlignment=NSTextAlignmentCenter;
    bottomLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    bottomLabel.font=[UIFont systemFontOfSize:28.0/2.0 weight:UIFontWeightSemibold];
    [purchaseView addSubview:bottomLabel];
    
    
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, purchaseView.frame.size.height-80.0/2.0, purchaseView.frame.size.width, 80.0/2.0)];
    bottomView.backgroundColor=[UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1.0];
    [purchaseView addSubview:bottomView];
    
    
    UIButton * restoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    restoreButton.frame=CGRectMake(0, 0, bottomView.frame.size.width/2.0, bottomView.frame.size.height);
    //restoreButton.backgroundColor=[UIColor greenColor];
    [restoreButton setTitle:@"restore" forState:UIControlStateNormal];
    [restoreButton setTitleColor:[UIColor colorWithRed:116.0/255.0 green:116.0/255.0 blue:116.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    restoreButton.titleLabel.font=[UIFont systemFontOfSize:26.0/2.0 weight:UIFontWeightMedium];
    restoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    restoreButton.contentEdgeInsets = UIEdgeInsetsMake(0, 22.0/2.0, 0, 0);
    [restoreButton addTarget:self action:@selector(didTapRestoreButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:restoreButton];
    
    
    UIButton * aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutButton.frame=CGRectMake(bottomView.frame.size.width/2.0, 0, bottomView.frame.size.width/2.0, bottomView.frame.size.height);
    //aboutButton.backgroundColor=[UIColor greenColor];
    [aboutButton setTitle:@"about subscriptions" forState:UIControlStateNormal];
    [aboutButton setTitleColor:[UIColor colorWithRed:116.0/255.0 green:116.0/255.0 blue:116.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    aboutButton.titleLabel.font=[UIFont systemFontOfSize:26.0/2.0 weight:UIFontWeightMedium];
    aboutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    aboutButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22.0/2.0);
    [aboutButton addTarget:self action:@selector(didTapAboutButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:aboutButton];
    
    
    //
    
    self.aboutView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-560.0/2.0)/2.0, (self.view.frame.size.height-844.0/2.0)/2.0, 560.0/2.0, 844.0/2.0)];
    self.aboutView.backgroundColor=[UIColor whiteColor];
    self.aboutView.layer.cornerRadius=34.0/2.0;
    self.aboutView.clipsToBounds=YES;
    self.aboutView.hidden=YES;
    [self setupAboutView];
    [self.view addSubview:self.aboutView];
    
    [[STInAppPurchaseManager sharedManager] setDelegate:self];

    
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"receipt"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }

}
-(void)didTapPurchaseButton {
    
//    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"receipt"];
//    [self dismissViewControllerAnimated:YES completion:nil];
  
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"production"][@"payment"][@"controller"] boolValue])
    {
        DefaultPurchaseViewController * defaultPurchaseViewController = [[DefaultPurchaseViewController alloc] init];
        [self presentViewController:defaultPurchaseViewController animated:YES completion:nil];
        
        return;
    }
    else
    {
        [[STInAppPurchaseManager sharedManager] buyProduct:0];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark STInAppPurchaseManagerDelegate
- (void)didFinishBuyingProduct:(NSInteger)index success:(BOOL)success withErrorMessage:(NSString *)message withReceipt:(NSString *)receipt
{
    
    NSLog(@"didFinishBuyingProduct. Success %@ Receipt %@",success ? @"YES":@"NO",receipt);
    
    if(success)
    {
        
        
        NSLog(@"success %@",receipt);
        
        
        [[NSUserDefaults standardUserDefaults] setObject:receipt forKey:@"receipt"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"purchased"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //[self.navigationController pushViewController:[[FindNumberViewController alloc] init] animated:YES];
        
        
        if(!_completedPurchase)
        {
            _completedPurchase=YES;
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_UI_AFTER_PAYMENT" object:nil userInfo:nil];
                
            }];
            
            
            //[self.navigationController pushViewController:[[FindNumberViewController alloc] init] animated:YES];
            
        }
        
        //        __weak typeof(self) weakSelf = self;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [weakSelf hidePurchaseButtons];
        //        });
        
    }
    else {
        
        
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"Your purchase failed"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

-(void)didTapRestoreButton {
    
    [[STInAppPurchaseManager sharedManager] restoreProduct];
}
-(void)didTapAboutButton {
    
    self.aboutView.hidden=NO;

}
-(void)setupAboutView {
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.aboutView.frame.size.width, 99.0/2.0)];
    topView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.aboutView addSubview:topView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(41.0/2.0, 0, self.aboutView.frame.size.width-41.0/2.0, 99.0/2.0)];
    label.text=@"about subscriptions";
    label.font=[UIFont systemFontOfSize:38.0/2.0 weight:UIFontWeightSemibold];
    label.textColor=[UIColor whiteColor];
    [self.aboutView addSubview:label];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(self.aboutView.frame.size.width-124.0/2.0, 0, 124.0/2.0, 99.0/2.0);
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:50.0/2.0 weight:UIFontWeightBold];
    [button addTarget:self action:@selector(didTapCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.aboutView addSubview:button];
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 99.0/2.0, self.aboutView.frame.size.width, 603.0/2.0)];
    textView.text=@"- If you want to use our service, we offer you cloud archiving service. With subscription you will get minimum 5GB / month cloud disk space.\n- Subscription period is 1 year. Every 1 year your subscription renews.\n- Payment will be charged to iTunes Account at confirmation of Purchase\n- Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.\n- Account will be charged for renewal within 24-hours prior to the end of the current period.\n- Price for subscription is $99 / year.\n- You can cancel your subscription via this url: https://support.apple.com/HT202039\n- Privacy policy: http://www.safekeys-app.com/privacy_policy.html\n- Terms of use: http://www.safekeys-app.com/terms_of_use.html";
    textView.font=[UIFont systemFontOfSize:24.0/2.0 weight:UIFontWeightRegular];
    textView.textColor=[UIColor blackColor];
    [self.aboutView addSubview:textView];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.aboutView.frame.size.height-142.0/2.0, self.aboutView.frame.size.width, 142.0/2.0)];
    bottomView.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    [self.aboutView addSubview:bottomView];
    
    UIView * separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.aboutView.frame.size.width, 1.0)];
    separatorView.backgroundColor=[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    [bottomView addSubview:separatorView];
    
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor=[UIColor colorWithRed:253/255.0 green:79.0/255.0 blue:43.0/255.0 alpha:0.8];
    closeButton.frame=CGRectMake(20.0/2.0,22.0/2.0,bottomView.frame.size.width-20.0/2.0*2,bottomView.frame.size.height-22.0/2.0*2);
    [closeButton setTitle:@"close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font=[UIFont systemFontOfSize:28.0/2.0 weight:UIFontWeightBold];
    closeButton.layer.cornerRadius=9.0/2.0;
    closeButton.layer.borderWidth=2.0/2.0;
    closeButton.layer.borderColor=[[UIColor colorWithRed:253/255.0 green:79.0/255.0 blue:43.0/255.0 alpha:1.0] CGColor];
    [closeButton addTarget:self action:@selector(didTapCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeButton];
    
    
}
-(void)didTapCloseButton {
    
    self.aboutView.hidden=YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}
@end
