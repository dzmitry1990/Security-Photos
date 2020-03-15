//
//  DefaultPurchaseViewController.m
//  CallBlocker
//
//  Created by Dzmitry Zhuk on 10/9/16.
//  Copyright © 2016 Fam, Inc. All rights reserved.
//

#import "DefaultPurchaseViewController.h"
#import "STInAppPurchaseManager.h"
#import <iAd/iAd.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)


@interface DefaultPurchaseViewController ()<STInAppPurchaseManagerDelegate>
{
    BOOL completedPurchase;
}
@property(nonatomic,strong) UIImageView * backgroundImageView;
@property(nonatomic,strong) UILabel * navigationLabel;
@property(nonatomic,strong) UILabel * topLabel;
@property(nonatomic,strong) UILabel * middleLabel;
@property(nonatomic,strong) UIView * separatorView;
@property(nonatomic,strong) UIButton * cancelButton;
@property(nonatomic,strong) UIButton * okButton;
@end

@implementation DefaultPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    float heightFactor = (self.view.frame.size.height/667.0);

    
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    backgroundImageView.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    //backgroundImageView.image=[UIImage imageNamed:@"background.png"];
    backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImageView];

    
    
//    
//    self.backgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
//    self.backgroundImageView.image=[UIImage imageNamed:@"background.png"];
//    self.backgroundImageView.contentMode=UIViewContentModeScaleToFill;
//    [self.view addSubview:self.backgroundImageView];
    
    
    self.navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.view.frame.size.width, 64)];
    self.navigationLabel.backgroundColor=[UIColor clearColor];
    self.navigationLabel.textColor=[UIColor whiteColor];
    self.navigationLabel.text=@"Subscribe";
    self.navigationLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationLabel.font=[UIFont boldSystemFontOfSize:20];
    self.navigationLabel.numberOfLines=0;
    [self.view addSubview:self.navigationLabel];
    
    
    
    
    UIButton * doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame=CGRectMake(0,0,self.view.frame.size.width-10,64);
    doneButton.backgroundColor=[UIColor clearColor];
    [doneButton setTitle:@"X" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    [doneButton addTarget:self action:@selector(didTapDoneButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:doneButton];
    
    
    
    
    UIView * separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, 1)];
    separatorView.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    [self.view addSubview:separatorView];
        
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 171*heightFactor, self.view.frame.size.width, 34)];
    self.topLabel.textColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.topLabel.text=@"Try it for 3 days for FREE!";
    self.topLabel.textAlignment=NSTextAlignmentCenter;
    self.topLabel.font=[UIFont boldSystemFontOfSize:21];
    self.topLabel.numberOfLines=0;
    [self.view addSubview:self.topLabel];
    
    
    
    self.middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-285/2, 207*heightFactor, 285, 157+110)];
    //self.middleLabel.backgroundColor=[UIColor yellowColor];
    self.middleLabel.textColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.middleLabel.text=@"After 3 days your subscription will automatically renew every year for $99.99.\n\n– Payment will be charged to iTunes Account at confirmation of purchase\n– Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period\n– Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal\n– Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase\n– Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable";
    self.middleLabel.textAlignment=NSTextAlignmentLeft;
    self.middleLabel.font=[UIFont systemFontOfSize:12];
    self.middleLabel.numberOfLines=0;
    [self.view addSubview:self.middleLabel];
    
    
    
//    self.separatorView=[[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 372*heightFactor+(IS_IPHONE_5 ? 10 : 0), 300, 1)];
//    self.separatorView.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
//    [self.view addSubview:self.separatorView];

    
    
    self.cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.cancelButton.backgroundColor=[UIColor yellowColor];
    self.cancelButton.frame=CGRectMake((self.view.frame.size.width-300)/2,self.view.frame.size.height-100,300,30);
//    self.cancelButton.frame=CGRectMake((self.view.frame.size.width-300)/2+10.5,409*heightFactor,80,30);
    [self.cancelButton setTitle:@"Already a subscriber? Restore" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font=[UIFont systemFontOfSize:18];
    [self.cancelButton addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];

    
    self.okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.okButton.frame=CGRectMake((self.separatorView.frame.origin.x+self.separatorView.frame.size.width-24.5)-100,400*heightFactor,110,48);
    self.okButton.frame=CGRectMake(self.view.frame.size.width/2-110/2,(400+90)*heightFactor,110,48);
    self.okButton.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.okButton.layer.cornerRadius=24;
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.okButton setTintColor:[UIColor whiteColor]];
    self.okButton.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.okButton addTarget:self action:@selector(didTapOkButton) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.okButton];
    
    [[STInAppPurchaseManager sharedManager] setDelegate:self];

    
    
    
//screenshot
//    UIImageView * backgroundImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-274.0/2.0, self.view.frame.size.width, 274.0/2.0)];
//    backgroundImageView2.image=[UIImage imageNamed:@"images.png"];
//    backgroundImageView2.contentMode=UIViewContentModeScaleAspectFill;
//    [self.view addSubview:backgroundImageView2];

    
    
    
}

-(void)didTapDoneButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
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
-(void)didTapOkButton{
    
    [[STInAppPurchaseManager sharedManager] buyProduct:0];
}


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
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        
        
        if(!completedPurchase)
        {
            completedPurchase=YES;
            
            
         
            [self dismissViewControllerAnimated:YES completion:^{
                
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_UI_AFTER_PAYMENT" object:nil userInfo:nil];
            
            }];
        }
        
        
        
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

-(void)didTapCancelButton {
    
    [[STInAppPurchaseManager sharedManager] restoreProduct];
}


@end
