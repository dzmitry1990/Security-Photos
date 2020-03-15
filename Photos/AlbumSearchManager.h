//
//  EBSearchManager.h
//  BeatBar
//
//  Created by Dzmitry Zhuk on 2/29/16.
//  Copyright © 2016 Fam, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlbumSearchManager : NSObject

+ (id)sharedManager;

//album
-(void)createAlbum:(NSString*)albumName;
-(void)deleteAlbum:(NSString*)albumID;
-(NSArray*)getAlbums;

-(void)addPhotoToAlbum;


-(NSArray*)getAlbum:(NSString*)albumID;
-(void)addMediaToAlbum:(NSString*)albumID withMedia:(NSString*)mediaID type:(NSString*)type;


-(void)imageForMediaID:(NSString*)mediaID completion:(void(^)(UIImage * image))completionBlock;
-(NSURL*)videoURLforMediaID:(NSString*)mediaID;

-(void)deleteMediaID:(NSString*)mediaID withAlbumID:(NSString*)albumID completion:(void(^)(void))completionBlock;

-(void)mediaForMediaID:(NSString*)mediaID withType:(NSString*)type completion:(void(^)(id media))completionBlock;

    
@end
