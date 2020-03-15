//
//  AlbumViewController.m
//  Photos
//
//  Created by Dzmitry Zhuk on 3/5/17.
//  Copyright © 2017 Fam, Inc. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumCollectionViewCell.h"

#import "AlbumSearchManager.h"

#import <MobileCoreServices/MobileCoreServices.h>

@import MediaPlayer;

#import "UIImage+fixOrientation.h"

#import "PreviewViewController.h"

@import Photos;

@interface AlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate>

@property(nonatomic,strong) UICollectionView * collectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout * collectionViewFlowLayout;
@property(nonatomic,strong) PHFetchResult<PHAsset *> *assets;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=self.albumName;
    
    self.view.backgroundColor=[UIColor whiteColor];
    

    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAddButton)];
    [addButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    // Configure layout
    self.collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    //    [self.collectionViewFlowLayout setItemSize:CGSizeMake(191, 160)];
    [self.collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionViewFlowLayout.minimumInteritemSpacing = 1;
    self.collectionViewFlowLayout.minimumLineSpacing = 1;
    //[self.collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    //Collection view
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.collectionViewFlowLayout];
    self.collectionView.collectionViewLayout=self.collectionViewFlowLayout;
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[AlbumCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.alwaysBounceVertical = YES;
    //self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 1);
    //self.collectionView.pagingEnabled = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:self.collectionView];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[AlbumSearchManager sharedManager] getAlbum:self.albumID] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(floor((self.view.frame.size.width-3)/4),floor((self.view.frame.size.width-3)/4));

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    AlbumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    //cell.imageView.image=[UIImage imageNamed:@"photo-placeholder.png"];
    
    NSString * mediaID = [[AlbumSearchManager sharedManager] getAlbum:self.albumID][indexPath.row][@"id"];
    
    cell.mediaID=mediaID;
    
    [[AlbumSearchManager sharedManager] imageForMediaID:mediaID completion:^(UIImage *image) {
        
        if([cell.mediaID isEqualToString:mediaID])
        {
            //dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.imageView.image=image;
                cell.imageView.contentMode=UIViewContentModeScaleAspectFill;
                
            //});
        }

    }];
    
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"did tap %d",(int)indexPath.row);
    
    PreviewViewController * previewViewController = [[PreviewViewController alloc] init];
    previewViewController.mediaID= [[AlbumSearchManager sharedManager] getAlbum:self.albumID][indexPath.row][@"id"];
    previewViewController.type= [[AlbumSearchManager sharedManager] getAlbum:self.albumID][indexPath.row][@"type"];
    previewViewController.albumID=self.albumID;
    [self.navigationController pushViewController:previewViewController animated:YES];
    
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

-(void)didTapAddButton {
    
    
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)  ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        [weakSelf selectPhoto];

        
    }]];
    
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        [weakSelf
         takePhoto];
        
        
    }]];
    
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
}

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.mediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];

    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString * mediaID=[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];

    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    BOOL isMovie = UTTypeConformsTo((__bridge CFStringRef)mediaType,
                                    kUTTypeMovie) != 0;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.%@",
                          documentsDirectory,mediaID,isMovie ? @"mp4":@"png"];

    
    
    
    if(isMovie)
    {
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        BOOL success = [videoData writeToFile:fileName atomically:YES];
        
        
        MPMoviePlayerController *theMovie = [[MPMoviePlayerController alloc] initWithContentURL:[info objectForKey:@"UIImagePickerControllerMediaURL"]];
        theMovie.view.frame = self.view.bounds;
        theMovie.controlStyle = MPMovieControlStyleNone;
        theMovie.shouldAutoplay=NO;
        UIImage *thumbImage = [theMovie thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionExact];
 
        
        
        NSString *thumbFileName = [NSString stringWithFormat:@"%@/%@.png",
                                   documentsDirectory,mediaID];
        [UIImagePNGRepresentation(thumbImage) writeToFile:thumbFileName atomically:YES];

        
        
        //save thumbnail
        /*[[ALAssetsLibrary new] assetForURL:info[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            
            
            UIImage * thumbImage = [UIImage imageWithCGImage:asset.thumbnail];
            NSString *thumbFileName = [NSString stringWithFormat:@"%@/%@.png",
                                  documentsDirectory,mediaID];
            [UIImagePNGRepresentation(thumbImage) writeToFile:thumbFileName atomically:YES];

            
        } failureBlock:^(NSError *error) {
            // handle error
        }];*/
        
        

    }
    else {
        
        
        
        UIImage *chosenImage = [info[UIImagePickerControllerOriginalImage] fixOrientation];
        //    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        [UIImagePNGRepresentation(chosenImage) writeToFile:fileName atomically:YES];

    }
    
    
    
    NSLog(@"fileName %@",fileName);
    
    
    
    [[AlbumSearchManager sharedManager] addMediaToAlbum:self.albumID withMedia:mediaID type:isMovie ? @"video" : @"photo"];
    
    
    __weak typeof(self) weakSelf = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (picker.sourceType != UIImagePickerControllerSourceTypeCamera)
            {
                [weakSelf deleteFromCameraRoll:[info objectForKey:UIImagePickerControllerReferenceURL]];
            }
            [weakSelf.collectionView reloadData];
                
            
        });
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;

    [self.collectionView reloadData];
}
-(void) deleteFromCameraRoll:(NSURL*)url {
    
    

    
    
    
    
    
    __weak typeof(self) weakSelf = self;


    
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Delete this media from Camera Roll after importing it?"
                                      message:@"To keep this media protected inside SafeKeys we need to delete it from your camera roll. After that you'll need to manually delete it from your phone's Recently Deleted photo album to permanently delete it from your Camera Roll immediately"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Delete it"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                               
                                 
                                 
                                 weakSelf.assets = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
                                 
                                 
                                 PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
                                 [library performChanges:^{
                                     [PHAssetChangeRequest deleteAssets:weakSelf.assets];
                                 } completionHandler:^(BOOL success, NSError *error)
                                  {
                                      //do something here
                                  }];
                                 

                                     
                                     
                                 
                             }];
                                 
    
    
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Don't delete it"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        

        
    

    
}

@end
