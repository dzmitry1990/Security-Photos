//
//  ViewController.m
//  Photos
//
//  Created by Dzmitry Zhuk on 3/5/17.
//  Copyright © 2017 Fam, Inc. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AlbumsTableViewCell.h"

#import "AlbumViewController.h"

#import "AlbumSearchManager.h"

#import "CalculatorViewController.h"
#import "PurchaseViewController.h"

@import MessageUI;


@interface AlbumsViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
{
    BOOL _isNotFirst;
}
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) UILabel * emptyLabel;


@property(nonatomic,strong) UIView * mainView;

@property(nonatomic,strong) UIView * leftMenuView;
@property(nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title=@"Albums";
    self.view.backgroundColor=[UIColor blackColor];
    
    

    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent=NO;

    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    //
    
    
    self.leftMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, self.view.frame.size.height)];
    self.leftMenuView.backgroundColor=[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
    [self setupLeftMenuView];
    [self.view addSubview:self.leftMenuView];
    
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mainView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:self.mainView];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMainView)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    self.tapGestureRecognizer.enabled=NO;
    [self.mainView addGestureRecognizer:self.tapGestureRecognizer];
    
    
    
    
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImageView.image=[UIImage imageNamed:@"background.png"];
    backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.mainView addSubview:backgroundImageView];
    
    
    //
    UIView * statusBarBackgroundView = [[UIView alloc] init];
    statusBarBackgroundView.frame=CGRectMake(0, 0, self.view.frame.size.width, 20);
    statusBarBackgroundView.backgroundColor=[UIColor blackColor];
    [self.mainView addSubview:statusBarBackgroundView];
    
    UILabel * navigationLabel = [[UILabel alloc] init];
    navigationLabel.frame=CGRectMake(0, 20, self.view.frame.size.width, 88.0/2.0);
    navigationLabel.backgroundColor=[UIColor blackColor];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.font=[UIFont systemFontOfSize:40.0/2.0 weight:UIFontWeightBold];
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.numberOfLines=1;
    navigationLabel.text=@"Albums";
    
    [self.mainView addSubview:navigationLabel];
    
    
    
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame=CGRectMake(14-10, 34-13/2-7-20+20, 53.0/2.0+10*2, 41.0/2.0+10*2);
    menuButton.contentEdgeInsets=UIEdgeInsetsMake(10, 10, 10, 10);
    
    [menuButton setImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(didTapMenuButton) forControlEvents:UIControlEventTouchUpInside];
    //menuButton.backgroundColor=[UIColor greenColor];
    [self.mainView addSubview:menuButton];
    
    
    
    UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame=CGRectMake(self.view.frame.size.width-(41.0/2.0+10)-17.0, 20, 41.0/2.0+10*2, 41.0/2.0+10*2);
    refreshButton.contentEdgeInsets=UIEdgeInsetsMake(10, 10, 10, 10);
    
    [refreshButton setImage:[UIImage imageNamed:@"add-button.png"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(didTapAddAlbumButton) forControlEvents:UIControlEventTouchUpInside];
    //settingsButton.backgroundColor=[UIColor greenColor];
    [self.mainView addSubview:refreshButton];
    
    

    /*
    
    
    //left menu button
    
    
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame=CGRectMake(0,0, 20+10*2, 15+10*2);
    //19-10, 75.0/2.0-13/2
    menuButton.contentEdgeInsets=UIEdgeInsetsMake(7, 10, 10-7, 10);
    
    [menuButton setImage:[UIImage imageNamed:@"menu-button@3x.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(didTapMenuButton) forControlEvents:UIControlEventTouchUpInside];
    //menuButton.backgroundColor=[UIColor greenColor];
    [self.view addSubview:menuButton];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    
    //
    
    UIBarButtonItem *addAlbumButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAddAlbumButton)];
    [addAlbumButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addAlbumButton;*/
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 89.0/2.0+20,self.view.frame.size.width, self.view.frame.size.height-89.0/2.0-20)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    //self.tableView.backgroundColor=[UIColor blackColor];
    
    [self.tableView registerClass:[AlbumsTableViewCell class] forCellReuseIdentifier:@"AlbumCell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //[self.tableView setContentInset:UIEdgeInsetsMake(0,0,9,0)];
    
    [self.mainView addSubview:self.tableView];
    
    self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2.0)];
    self.emptyLabel.text=@"To start, create an album by\nclicking the + button\n\nThen add photos to your album!";
    self.emptyLabel.textAlignment=NSTextAlignmentCenter;
    self.emptyLabel.font=[UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    self.emptyLabel.textColor=[UIColor blackColor];
    self.emptyLabel.backgroundColor=[UIColor clearColor];
    self.emptyLabel.hidden=YES;
    self.emptyLabel.numberOfLines=0;
    [self.mainView addSubview:self.emptyLabel];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];


    [self checkPasscode];
        

    self.emptyLabel.hidden=!([[[AlbumSearchManager sharedManager] getAlbums] count]==0);

}
-(void) didBecomeActive {
    
    [self checkPasscode];
    
}
/*paid
-(void) checkPasscode {
    
    
    //after user sets up the password, asks for payment.
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"session"]==nil)
    {
        
        CalculatorViewController * calculatorViewController = [[CalculatorViewController alloc] init];
        [self presentViewController:calculatorViewController animated:NO completion:nil];
    }
    //if user already paid, dismiss the view
    else if([[NSUserDefaults standardUserDefaults] objectForKey:@"receipt"]==nil)
    {
        
        
        PurchaseViewController * purchaseViewController = [[PurchaseViewController alloc] init];
        [self presentViewController:purchaseViewController animated:YES completion:nil];
        
    }
 
}*/
-(void) checkPasscode {
    
    
    //after user sets up the password, asks for payment.
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"session"]==nil)
    {
        
        CalculatorViewController * calculatorViewController = [[CalculatorViewController alloc] init];
        [self presentViewController:calculatorViewController animated:NO completion:nil];
    }

    
}
#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];

    cell.titleLabel.text=[[AlbumSearchManager sharedManager] getAlbums][indexPath.row][@"name"];
    cell.photosLabel.text=[NSString stringWithFormat:@"%@ Photos",[[AlbumSearchManager sharedManager] getAlbums][indexPath.row][@"count"]];

    cell.thumbnailImageView.image=[UIImage imageNamed:@"photo-placeholder.png"];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[AlbumSearchManager sharedManager] getAlbums] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlbumViewController * albumViewController = [[AlbumViewController alloc] init];
    albumViewController.albumID=[[AlbumSearchManager sharedManager] getAlbums][indexPath.row][@"id"];
    albumViewController.albumName=[[AlbumSearchManager sharedManager] getAlbums][indexPath.row][@"name"];
    [self.navigationController pushViewController:albumViewController animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[AlbumSearchManager sharedManager] deleteAlbum:[[AlbumSearchManager sharedManager] getAlbums][indexPath.row][@"id"]];
        
        self.emptyLabel.hidden=!([[[AlbumSearchManager sharedManager] getAlbums] count]==0);

        [self.tableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTapAddAlbumButton {
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Enter album name"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    __weak typeof(self) weakSelf = self;
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Continue"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   
                                   UITextField *nameTextField = alertController.textFields.firstObject;
                                   NSLog(@"name: %@",nameTextField.text);
                                   
                                   if(![nameTextField.text isEqualToString:@""])
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [[AlbumSearchManager sharedManager] createAlbum:nameTextField.text];
                                           
                                           weakSelf.emptyLabel.hidden=!([[[AlbumSearchManager sharedManager] getAlbums] count]==0);

                                           
                                           [weakSelf.tableView reloadData];
                                           
                                       });
                                   }
                                   
                                   
                               }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder =@"Name";
     }];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    

    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

    
    [self.tableView reloadData];
}

//menu
-(void) didTapMenuButton {
    
    self.mainView.frame=CGRectMake((self.mainView.frame.origin.x == 0) ? 270 : 0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
    
    self.tapGestureRecognizer.enabled=YES;
    
    
}
-(void) didTapMainView {
    
    NSLog(@"didTapMainView");
    
    if(self.mainView.frame.origin.x==270)
    {
        self.mainView.frame=CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
        self.tapGestureRecognizer.enabled=NO;
        
    }
    
    
    
}

-(void)setupLeftMenuView {
    
    
    
    UIView * separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(18.5, 52.5+23.0, 206, 1)];
    separatorView1.backgroundColor=[UIColor colorWithWhite:137.0/255.0 alpha:1.0];
    [self.leftMenuView addSubview:separatorView1];
    
    
    UIButton * contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactButton.frame=CGRectMake(37, 69+23.0, 170, 22);
    [contactButton setTitle:@"Contact us" forState:UIControlStateNormal];
    contactButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:34.0/2.0];
    contactButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [contactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(didTapContactButton) forControlEvents:UIControlEventTouchUpInside];
    
    //contactButton.backgroundColor=[UIColor yellowColor];
    [self.leftMenuView addSubview:contactButton];
    
    UIView * separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(18.5, 106.5+23.0, 206, 1)];
    separatorView2.backgroundColor=[UIColor colorWithWhite:137.0/255.0 alpha:1.0];
    [self.leftMenuView addSubview:separatorView2];
    
    
    
    
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame=CGRectMake(37, 122.5+23.0, 170, 22);
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    shareButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:34.0/2.0];
    shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(didTapShareButton) forControlEvents:UIControlEventTouchUpInside];
    //contactButton.backgroundColor=[UIColor yellowColor];
    [self.leftMenuView addSubview:shareButton];
    
    
    
    UIView * separatorView3 = [[UIView alloc] initWithFrame:CGRectMake(18.5, 160.5+23.0, 206, 1)];
    separatorView3.backgroundColor=[UIColor colorWithWhite:137.0/255.0 alpha:1.0];
    [self.leftMenuView addSubview:separatorView3];
    
    
    UIButton * reviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reviewButton.frame=CGRectMake(37, 177+23.0, 170, 22);
    [reviewButton setTitle:@"Write a review" forState:UIControlStateNormal];
    reviewButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:34.0/2.0];
    reviewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [reviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reviewButton addTarget:self action:@selector(didTapReviewButton) forControlEvents:UIControlEventTouchUpInside];
    
    //contactButton.backgroundColor=[UIColor yellowColor];
    [self.leftMenuView addSubview:reviewButton];
    
    
    UIView * separatorView4 = [[UIView alloc] initWithFrame:CGRectMake(18.5, 214.5+23.0, 206, 1)];
    separatorView4.backgroundColor=[UIColor colorWithWhite:137.0/255.0 alpha:1.0];
    [self.leftMenuView addSubview:separatorView4];
    
    
    //
    
    
    UIButton * privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    privacyButton.frame=CGRectMake(37, 231.5+23.0, 170, 22);
    [privacyButton setTitle:@"Privacy Policy" forState:UIControlStateNormal];
    privacyButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:34.0/2.0];
    privacyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [privacyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [privacyButton addTarget:self action:@selector(didTapPrivacyButton) forControlEvents:UIControlEventTouchUpInside];
    
    //contactButton.backgroundColor=[UIColor yellowColor];
    [self.leftMenuView addSubview:privacyButton];
    
    
    UIView * separatorView5 = [[UIView alloc] initWithFrame:CGRectMake(18.5, 268.5+23.0, 206, 1)];
    separatorView5.backgroundColor=[UIColor colorWithWhite:137.0/255.0 alpha:1.0];
    [self.leftMenuView addSubview:separatorView5];
    
    
    //
    
    
    UIButton * termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    termsButton.frame=CGRectMake(37, 286+23.0, 170, 22);
    [termsButton setTitle:@"Terms of Service" forState:UIControlStateNormal];
    termsButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:34.0/2.0];
    termsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [termsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [termsButton addTarget:self action:@selector(didTapTermsButton) forControlEvents:UIControlEventTouchUpInside];
    
    //contactButton.backgroundColor=[UIColor yellowColor];
    [self.leftMenuView addSubview:termsButton];
    
    
    UIView * separatorView6 = [[UIView alloc] initWithFrame:CGRectMake(18.5, 322.5+23.0, 206, 1)];
    separatorView6.backgroundColor=[UIColor colorWithWhite:137.0/255.0 alpha:1.0];
    [self.leftMenuView addSubview:separatorView6];
    
    
    
    
    
}

-(void) didTapContactButton {
    
    
    MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
    //set delegate
    mc.mailComposeDelegate = self;
    
    //set message body
    //[mc setMessageBody:messageBody isHTML:NO];
    //set message subject
    [mc setSubject:@"Feedback"];
    
    //set message recipients
    [mc setToRecipients:[NSArray arrayWithObject:@"info@safekeys-app.com"]];
    
    
    [self presentViewController:mc animated:YES completion:nil];
    
}


#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)didTapShareButton {
    
    
    NSString *textToShare = [NSString stringWithFormat:@"I use the SafeKeys app! You should try it: http://safekeys-app.com"];
    
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    
}

-(void) didTapReviewButton {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1276477309"]];
    
    
}

-(void) didTapPrivacyButton {
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.safekeys-app.com/privacy_policy.html"]];
    
}

-(void) didTapTermsButton {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://safekeys-app.com/terms_of_service.html"]];
    
    
}



@end
