//
//  CalculatorViewController.m
//  Photos
//
//  Created by Dzmitry Zhuk on 3/5/17.
//  Copyright © 2017 Fam, Inc. All rights reserved.
//

#import "CalculatorViewController.h"
#import "UIImage+DynamicFontSize.h"
#import "DefaultPurchaseViewController.h"

@import LocalAuthentication;

@interface CalculatorViewController ()

@property(nonatomic,strong) UILabel * numbersLabel;
@property(nonatomic,strong) UILabel * statuLabel;
@property(nonatomic,strong) NSString * tmpPassCode;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat buttonWidth = (self.view.frame.size.width-3.0)/4.0;
    
    //float heightFactor = 667.0/self.view.frame.size.height;
    
    self.statuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165/2, self.view.frame.size.width, 115)];
    self.statuLabel.backgroundColor=[UIColor clearColor];
    self.statuLabel.textColor=[UIColor blackColor];
    self.statuLabel.font=[UIFont systemFontOfSize:26];
    self.statuLabel.text=([[NSUserDefaults standardUserDefaults] objectForKey:@"password"]==nil) ?
    @"SELECT A PASSCODE" : @"ENTER PASSCODE";
    self.statuLabel.numberOfLines = 1;
    self.statuLabel.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:self.statuLabel];
    
    
    self.numbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 165/2, self.view.frame.size.width-20*2, 115)];
    self.numbersLabel.backgroundColor=[UIColor clearColor];
    self.numbersLabel.textColor=[UIColor blackColor];
    //self.numbersLabel.font=[UIFont systemFontOfSize:40];
    self.numbersLabel.text=@"0";
    self.numbersLabel.numberOfLines = 1;
    self.numbersLabel.textAlignment=NSTextAlignmentRight;
    
//    self.numbersLabel.adjustsFontSizeToFitWidth = YES;
//    self.numbersLabel.minimumScaleFactor = 0.5;
    [self.numbersLabel adjustFontSizeToFillItsContents];
    self.numbersLabel.hidden=YES;
    [self.view addSubview:self.numbersLabel];
    
    
    
    UIView * calculatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.numbersLabel.frame.origin.y+self.numbersLabel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(self.numbersLabel.frame.origin.y+self.numbersLabel.frame.size.height))];
    //calculatorView.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:calculatorView];
    
    CGFloat buttonHeight =(calculatorView.frame.size.height-4.0)/5.0;

    
    //first row
    
    
    UIButton * acButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //acButton.backgroundColor=[UIColor yellowColor];
    acButton.backgroundColor=[UIColor colorWithWhite:100.0/255.0 alpha:1.0];
    acButton.frame=CGRectMake(0,0,buttonWidth,buttonHeight);
    [acButton setTitle:@"C" forState:UIControlStateNormal];
    acButton.titleLabel.font=[UIFont systemFontOfSize:28 weight:UIFontWeightLight];
    [acButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acButton addTarget:self action:@selector(didTapACButton) forControlEvents:UIControlEventTouchUpInside];
    acButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    acButton.layer.borderWidth=5.0;
    acButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:acButton];
    
    
    UIButton * plusMinusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusMinusButton.backgroundColor=[UIColor colorWithWhite:100.0/255.0 alpha:1.0];
    plusMinusButton.frame=CGRectMake(buttonWidth+1,0,buttonWidth,buttonHeight);
    [plusMinusButton setTitle:@"%" forState:UIControlStateNormal];
    plusMinusButton.titleLabel.font=[UIFont systemFontOfSize:28 weight:UIFontWeightLight];
    
    [plusMinusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    plusMinusButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    plusMinusButton.layer.borderWidth=5.0;
    plusMinusButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [plusMinusButton addTarget:self action:@selector(didTapPercentButton) forControlEvents:UIControlEventTouchUpInside];
    [calculatorView addSubview:plusMinusButton];
    
    UIButton * percentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    percentButton.backgroundColor=[UIColor colorWithWhite:100.0/255.0 alpha:1.0];
    percentButton.frame=CGRectMake((buttonWidth+1)*2,0,buttonWidth,buttonHeight);
    
    [percentButton setTitle:@"÷" forState:UIControlStateNormal];
    percentButton.titleLabel.font=[UIFont systemFontOfSize:40];
    
    [percentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    percentButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    percentButton.layer.borderWidth=5.0;
    percentButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:percentButton];
    
    
    UIButton * divisionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    divisionButton.backgroundColor=[UIColor colorWithWhite:100.0/255.0 alpha:1.0];
    divisionButton.frame=CGRectMake((buttonWidth+1)*3,0,buttonWidth,buttonHeight);
    [divisionButton setTitle:@"x" forState:UIControlStateNormal];
    divisionButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    divisionButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    divisionButton.layer.borderWidth=5.0;
    divisionButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:divisionButton];
    
    
    //second row
    
    
    UIButton * sevenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sevenButton.backgroundColor=[UIColor blackColor];
    sevenButton.frame=CGRectMake(0,(buttonHeight+1),buttonWidth,buttonHeight);
    [sevenButton setTitle:@"7" forState:UIControlStateNormal];
    sevenButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    sevenButton.backgroundColor=[UIColor blackColor];
    [sevenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sevenButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    sevenButton.tag=7;
    sevenButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    sevenButton.layer.borderWidth=5.0;
    sevenButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:sevenButton];
    
    
    UIButton * eightMinusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    eightMinusButton.backgroundColor=[UIColor blackColor];
    eightMinusButton.frame=CGRectMake(buttonWidth+1,(buttonHeight+1),buttonWidth,buttonHeight);
    [eightMinusButton setTitle:@"8" forState:UIControlStateNormal];
    eightMinusButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    eightMinusButton.backgroundColor=[UIColor blackColor];
    [eightMinusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [eightMinusButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    eightMinusButton.tag=8;
    eightMinusButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    eightMinusButton.layer.borderWidth=5.0;
    eightMinusButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:eightMinusButton];
    
    UIButton * nineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nineButton.backgroundColor=[UIColor blackColor];
    nineButton.frame=CGRectMake((buttonWidth+1)*2,(buttonHeight+1),buttonWidth,buttonHeight);
    [nineButton setTitle:@"9" forState:UIControlStateNormal];
    nineButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    nineButton.backgroundColor=[UIColor blackColor];
    [nineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nineButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    nineButton.tag=9;
    nineButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    nineButton.layer.borderWidth=5.0;
    nineButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:nineButton];
    
    
    UIButton * xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xButton.backgroundColor=[UIColor colorWithWhite:100.0/255.0 alpha:1.0];
    xButton.frame=CGRectMake((buttonWidth+1)*3,(buttonHeight+1),buttonWidth,buttonHeight);
    [xButton setTitle:@"-" forState:UIControlStateNormal];
    xButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    xButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    xButton.layer.borderWidth=5.0;
    xButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:xButton];
    
    
    
    //third row

    
    UIButton * fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fourButton.backgroundColor=[UIColor blackColor];
    fourButton.frame=CGRectMake(0,(buttonHeight+1)*2,buttonWidth,buttonHeight);
    [fourButton setTitle:@"4" forState:UIControlStateNormal];
    fourButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    fourButton.backgroundColor=[UIColor blackColor];
    [fourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fourButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    fourButton.tag=4;
    fourButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    fourButton.layer.borderWidth=5.0;
    fourButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:fourButton];
    
    
    UIButton * fiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fiveButton.backgroundColor=[UIColor blackColor];
    fiveButton.frame=CGRectMake(buttonWidth+1,(buttonHeight+1)*2,buttonWidth,buttonHeight);
    [fiveButton setTitle:@"5" forState:UIControlStateNormal];
    fiveButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    fiveButton.backgroundColor=[UIColor blackColor];
    [fiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fiveButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    fiveButton.tag=5;
    fiveButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    fiveButton.layer.borderWidth=5.0;
    fiveButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:fiveButton];
    
    UIButton * sixButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sixButton.backgroundColor=[UIColor blackColor];
    sixButton.frame=CGRectMake((buttonWidth+1)*2,(buttonHeight+1)*2,buttonWidth,buttonHeight);
    [sixButton setTitle:@"6" forState:UIControlStateNormal];
    sixButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    sixButton.backgroundColor=[UIColor blackColor];
    [sixButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sixButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    sixButton.tag=6;
    sixButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    sixButton.layer.borderWidth=5.0;
    sixButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:sixButton];
    
    
    UIButton * minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.backgroundColor=[UIColor colorWithWhite:100.0/255.0 alpha:1.0];
    minusButton.frame=CGRectMake((buttonWidth+1)*3,(buttonHeight+1)*2,buttonWidth,buttonHeight);
    [minusButton setTitle:@"+" forState:UIControlStateNormal];
    minusButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    minusButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    minusButton.layer.borderWidth=5.0;
    minusButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:minusButton];
    
    
    
    //fourth row
    
    
    UIButton * oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    oneButton.backgroundColor=[UIColor blackColor];
    oneButton.frame=CGRectMake(0,(buttonHeight+1)*3,buttonWidth,buttonHeight);
    [oneButton setTitle:@"1" forState:UIControlStateNormal];
    oneButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    oneButton.backgroundColor=[UIColor blackColor];
    [oneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [oneButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    oneButton.tag=1;
    oneButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    oneButton.layer.borderWidth=5.0;
    oneButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:oneButton];
    
    
    UIButton * twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twoButton.backgroundColor=[UIColor blackColor];
    twoButton.frame=CGRectMake(buttonWidth+1,(buttonHeight+1)*3,buttonWidth,buttonHeight);
    [twoButton setTitle:@"2" forState:UIControlStateNormal];
    twoButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    twoButton.backgroundColor=[UIColor blackColor];
    [twoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [twoButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    twoButton.tag=2;
    twoButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    twoButton.layer.borderWidth=5.0;
    twoButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:twoButton];
    
    UIButton * threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    threeButton.backgroundColor=[UIColor blackColor];
    threeButton.frame=CGRectMake((buttonWidth+1)*2,(buttonHeight+1)*3,buttonWidth,buttonHeight);
    [threeButton setTitle:@"3" forState:UIControlStateNormal];
    threeButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    threeButton.backgroundColor=[UIColor blackColor];
    [threeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [threeButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    threeButton.tag=3;
    threeButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    threeButton.layer.borderWidth=5.0;
    threeButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:threeButton];
    
    
    UIButton * plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.backgroundColor=[UIColor blackColor];
    plusButton.frame=CGRectMake((buttonWidth+1)*3,(buttonHeight+1)*3,buttonWidth,buttonHeight+1+buttonHeight);
    [plusButton setTitle:@"=" forState:UIControlStateNormal];
    plusButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    plusButton.backgroundColor=[UIColor colorWithRed:253/255.0 green:79.0/255.0 blue:43.0/255.0 alpha:1.0];
    plusButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    plusButton.layer.borderWidth=5.0;
    plusButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:plusButton];
    
    
    
    
    //fourth row
    
    
    UIButton * zeroButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zeroButton.backgroundColor=[UIColor blackColor];
    zeroButton.frame=CGRectMake(0,(buttonHeight+1)*4,buttonWidth,buttonHeight);
    [zeroButton setTitle:@"0" forState:UIControlStateNormal];
    zeroButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    zeroButton.backgroundColor=[UIColor blackColor];
    [zeroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zeroButton.tag=10;
    [zeroButton addTarget:self action:@selector(didTapNumberButton:) forControlEvents:UIControlEventTouchUpInside];
    zeroButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    zeroButton.layer.borderWidth=5.0;
    zeroButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:zeroButton];
    
    
    UIButton * dotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dotButton.backgroundColor=[UIColor blackColor];
    dotButton.frame=CGRectMake((buttonWidth+1)*2,(buttonHeight+1)*4,buttonWidth,buttonHeight);
    [dotButton setTitle:@"." forState:UIControlStateNormal];
    dotButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    dotButton.backgroundColor=[UIColor blackColor];
    [dotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dotButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    dotButton.layer.borderWidth=5.0;
    dotButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:dotButton];
    
    
    UIButton * extraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    extraButton.backgroundColor=[UIColor blackColor];
    extraButton.frame=CGRectMake(buttonWidth+1,(buttonHeight+1)*4,buttonWidth,buttonHeight);
    [extraButton setTitle:@"+-" forState:UIControlStateNormal];
    extraButton.titleLabel.font=[UIFont systemFontOfSize:28 weight:UIFontWeightLight];
    extraButton.backgroundColor=[UIColor blackColor];
    [extraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    extraButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    extraButton.layer.borderWidth=5.0;
    extraButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:extraButton];
    
    
    /*UIButton * equalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    equalButton.backgroundColor=[UIColor blackColor];
    equalButton.frame=CGRectMake((buttonWidth+1)*3,(buttonHeight+1)*4,buttonWidth,buttonHeight);
    [equalButton setTitle:@"=" forState:UIControlStateNormal];
    equalButton.titleLabel.font=[UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    equalButton.backgroundColor=[UIColor colorWithRed:253/255.0 green:79.0/255.0 blue:43.0/255.0 alpha:1.0];
    equalButton.layer.cornerRadius=acButton.frame.size.width/5.0;
    equalButton.layer.borderWidth=5.0;
    equalButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [calculatorView addSubview:equalButton];*/
    


    

    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"password"]!=nil)
    {
        
        LAContext *myContext = [[LAContext alloc] init];
        
        NSError *authError = nil;
        
        NSString *myLocalizedReasonString = @"Authentication required to proceed";
        
        __weak typeof(self) weakSelf = self;
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:myLocalizedReasonString
                                reply:^(BOOL success, NSError *error) {
                                    
                                    if (success) {
                                        // User authenticated successfully, take appropriate action
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            // write all your code here
                                            NSLog(@"TouchID success!");
                                            
                                            
                                            //user logged in
                                            
                                            //mark session as logged in
                                            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"session"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            
                                            NSLog(@"Logged in");
                                            
                                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                            
                                            
                                        });
                                    } else {
                                        // User did not authenticate successfully, look at error and take appropriate action
                                        
                                        switch (error.code) {
                                            case LAErrorAuthenticationFailed:
                                                NSLog(@"Authentication Failed");
                                                break;
                                                
                                            case LAErrorUserCancel:
                                                NSLog(@"User pressed Cancel button");
                                                break;
                                                
                                            case LAErrorUserFallback:
                                                NSLog(@"User pressed \"Enter Password\"");
                                                break;
                                                
                                            default:
                                                NSLog(@"Touch ID is not configured");
                                                break;
                                        }
                                        
                                        NSLog(@"Authentication Fails");
                                    }
                                }];
        } else {
            // Could not evaluate policy; look at authError and present an appropriate message to user
            
            NSLog(@"error: %@",[authError localizedDescription]);
        }

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
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}
-(void)didTapNumberButton:(UIButton*)button
{
    self.statuLabel.hidden=YES;
    self.numbersLabel.hidden=NO;
    
    NSString * currentText = self.numbersLabel.text;
    
    if([self.numbersLabel.text isEqualToString:@"0"])
    {
        currentText = @"";
    }
    
    NSString * digit = [NSString stringWithFormat:@"%d",button.tag == 10 ? 0 : button.tag];
    self.numbersLabel.text=[currentText stringByAppendingString:digit];
    [self.numbersLabel adjustFontSizeToFillItsContents];
    
    
    if(self.numbersLabel.text.length==4)
        [self didTapPercentButton];
}

-(void)didTapACButton {
    
    self.statuLabel.hidden=YES;
    self.numbersLabel.hidden=NO;
    
    
    self.numbersLabel.text=@"0";
    [self.numbersLabel adjustFontSizeToFillItsContents];

}
-(void) didTapPercentButton {
    
//screenshot
//    DefaultPurchaseViewController * purchaseViewController = [[DefaultPurchaseViewController alloc] init];
//    purchaseViewController.modalTransitionStyle=UIModalTransitionStylePartialCurl;
//    [self presentViewController:purchaseViewController animated:YES completion:nil];
//    
//    return;
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"password"]==nil)
    {
        
        if(self.tmpPassCode==nil)
        {
            self.tmpPassCode = self.numbersLabel.text;
            
            
            self.statuLabel.text=@"REPEAT PASSCODE";
            
            self.statuLabel.hidden=NO;
            self.numbersLabel.hidden=YES;
            
            self.numbersLabel.text=@"0";
            
        }
        else {
            
            if((self.tmpPassCode.length >= 4) && [self.tmpPassCode isEqualToString:self.numbersLabel.text])
            {
                //finished setup
                NSLog(@"Done %@",self.numbersLabel.text);
                
                
                [[NSUserDefaults standardUserDefaults] setObject:self.numbersLabel.text forKey:@"password"];
                //mark session as logged in
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"session"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                
                //save passcode to nsuserdefaults
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            else {
                
                
                self.statuLabel.text=@"INCORRECT PASSCODE";
                
                if(self.tmpPassCode.length < 4)
                    self.statuLabel.text=@"PASSCODE TOO SHORT";
                
                self.tmpPassCode = nil;
                
                
                self.statuLabel.hidden=NO;
                self.numbersLabel.hidden=YES;
                
                
                
                
                CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0.0);
                CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, 10, 0.0);
                
                self.statuLabel.transform = translateLeft;
                
                [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
                    [UIView setAnimationRepeatCount:2.0];
                    self.statuLabel.transform = translateRight;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            self.statuLabel.transform = translateLeft;
                            
                        } completion:^(BOOL finished) {
                            if(finished)
                            {
                                //self.statuLabel.transform = CGAffineTransformIdentity;
                                self.statuLabel.text=([[NSUserDefaults standardUserDefaults] objectForKey:@"password"]==nil) ?
                                @"SELECT A PASSCODE" : @"ENTER PASSCODE";
                            }
                        }];
                    }
                }];
                
                
                
                
                //self.statuLabel.text=@"SELECT A PASSCODE";
                
                self.statuLabel.hidden=NO;
                self.numbersLabel.hidden=YES;
                
                self.numbersLabel.text=@"0";
                
            }
        }

    }
    else {
        
        
        if([self.numbersLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]])
        {
            //finished setup
            NSLog(@"Done %@",self.numbersLabel.text);
            
            
            //mark session as logged in
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"session"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            //save passcode to nsuserdefaults
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else {
            
            
            self.statuLabel.text=@"INCORRECT PASSCODE";
            
            if(self.numbersLabel.text.length < 4)
                self.statuLabel.text=@"PASSCODE TOO SHORT";
            
            
            self.statuLabel.hidden=NO;
            self.numbersLabel.hidden=YES;
            
            
            
            
            CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0.0);
            CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, 10, 0.0);
            
            self.statuLabel.transform = translateLeft;
            
            [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
                [UIView setAnimationRepeatCount:2.0];
                self.statuLabel.transform = translateRight;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        self.statuLabel.transform = translateLeft;
                        
                    } completion:^(BOOL finished) {
                        if(finished)
                        {
                            //self.statuLabel.transform = CGAffineTransformIdentity;
                            self.statuLabel.text=([[NSUserDefaults standardUserDefaults] objectForKey:@"password"]==nil) ?
                            @"SELECT A PASSCODE" : @"ENTER PASSCODE";
                        }
                    }];
                }
            }];
            
            
            
            
            //self.statuLabel.text=@"SELECT A PASSCODE";
            
            self.statuLabel.hidden=NO;
            self.numbersLabel.hidden=YES;
            
            self.numbersLabel.text=@"0";
            
        }
        
    }
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"password"]==nil)
    {
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"INSTRUCTIONS"
                                              message:@"Select a 4-digit passcode and press the % button to continue.\n\nOnce set up, you'll use the % button to unlock your secret folder"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                           
                                           
                                       }];
        
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }


}
@end
