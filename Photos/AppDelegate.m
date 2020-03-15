//
//  AppDelegate.m
//  Photos
//
//  Created by Dzmitry Zhuk on 3/5/17.
//  Copyright © 2017 Fam, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "AlbumsViewController.h"
#import "AlbumViewController.h"
#import "CalculatorViewController.h"
#import "DefaultPurchaseViewController.h"
#import "PurchaseViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"session"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[AlbumsViewController alloc] init]];
    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DefaultPurchaseViewController alloc] init]];
    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[PurchaseViewController alloc] init]];

    [self.window makeKeyAndVisible];
    
    
    [self loadConfig];
    
    [self createUserID];
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"session"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




-(void)createUserID {
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]==nil)
    {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://safekeys-app.com/create-user/"]];
        
        [request setHTTPMethod:@"GET"];
        
        __weak typeof(self) weakSelf = self;
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             
             
             NSDictionary * jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             NSLog(@"jsonResponse %@",jsonResponse);
             
             NSString * userID=jsonResponse[@"_id"][@"$id"];
             
             NSLog(@"userID: %@",userID);
             
             [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"user_id"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
         }];
        
    }
    else {
        
        NSLog(@"userID: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]);
        
    }
}



-(void)loadConfig {
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"production"]==nil)
    {
        //check production api and store values
        
        NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://safekeys-app.com/app-config/?v=%@",appVersionString]]];
        
        [request setHTTPMethod:@"GET"];
        
        __weak typeof(self) weakSelf = self;
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             
             
             NSDictionary * jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             NSLog(@"jsonResponse %@",jsonResponse);
             
             [[NSUserDefaults standardUserDefaults] setObject:jsonResponse forKey:@"production"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             //--[FBSDKSettings setAppID:[[NSUserDefaults standardUserDefaults] objectForKey:@"production"][@"facebook"][@"appid"]];
             
             
         }];
        
        
        
    }
    
}


@end
