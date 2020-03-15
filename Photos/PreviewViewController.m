//
//  PreviewViewController.m
//  Photos
//
//  Created by Dzmitry Zhuk on 3/5/17.
//  Copyright © 2017 Fam, Inc. All rights reserved.
//

#import "PreviewViewController.h"
#import "AlbumSearchManager.h"

@import AVKit;
@import AVFoundation;

@interface PreviewViewController ()
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerViewController *playerViewController;

@property(nonatomic,strong) UIView *bottomView;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height)];
    [[AlbumSearchManager sharedManager] imageForMediaID:self.mediaID completion:^(UIImage *image) {
        imageView.image=image;
        imageView.contentMode=UIViewContentModeScaleAspectFit;
    }];
    [self.view addSubview:imageView];
    
    
    if([self.type isEqualToString:@"video"])
    {
        UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame=CGRectMake(0, 0, 112, 112);
        playButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        playButton.center=self.view.center;
        [playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(didTapPlayButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:playButton];
    }
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-89.0/2.0-64, self.view.frame.size.width, 89.0/2.0)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    [self.view addSubview:self.bottomView];
    
    UIView * separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    separatorView.backgroundColor=[UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0];
    [self.bottomView addSubview:separatorView];
    
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(self.view.frame.size.width-(38+32.0)/2.0, 9, 19, 26.4);
    [deleteButton setImage:[UIImage imageNamed:@"trash-button.png"] forState:UIControlStateNormal];
    deleteButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [deleteButton addTarget:self action:@selector(didTapDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:deleteButton];
    
    
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame=CGRectMake(16.0, 9, 38/2.0, 53/2.0);
    [shareButton setImage:[UIImage imageNamed:@"share-button.png"] forState:UIControlStateNormal];
    shareButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [shareButton addTarget:self action:@selector(didTapShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:shareButton];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

    
    
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
-(void) didTapPlayButton {
    
    if(self.playerViewController==nil)
    {
        self.playerViewController = [AVPlayerViewController new];
    }
    
    self.player = [AVPlayer playerWithURL:[[AlbumSearchManager sharedManager] videoURLforMediaID:self.mediaID]];
    self.playerViewController.player = self.player;
    
    //[self.view addSubview: self.playerViewController.view];
    
    __weak typeof(self) weakSelf = self;
    [self presentViewController:self.playerViewController animated:NO completion:^{

        [weakSelf.player play];

    }];
}
-(void)didTapDeleteButton {
    
    __weak typeof(self) weakSelf = self;

    [[AlbumSearchManager sharedManager] deleteMediaID:self.mediaID withAlbumID:self.albumID completion:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
}
-(void)didTapShareButton {
    
    
    [[AlbumSearchManager sharedManager] mediaForMediaID:self.mediaID withType:self.type completion:^(id media) {
        
        NSArray *objectsToShare = @[media];
        
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        
        NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                       UIActivityTypePrint,
                                       UIActivityTypeAssignToContact,
                                       //UIActivityTypeSaveToCameraRoll,
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
        

        

    }];
    
    
    
}
-(void) didTap {
    
    __weak typeof(self) weakSelf = self;

    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
                         
                         
                         weakSelf.bottomView.alpha=!self.bottomView.alpha;
                         weakSelf.navigationController.navigationBar.alpha = !self.navigationController.navigationBar.alpha;
    
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//        
//    self.bottomView.alpha=1;
//    self.navigationController.navigationBar.alpha = 1;
}
@end
