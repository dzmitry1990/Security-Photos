//
//  EBSearchManager.m
//  BeatBar
//
//  Created by Dzmitry Zhuk on 2/29/16.
//  Copyright © 2016 Fam, Inc. All rights reserved.
//

#import "AlbumSearchManager.h"

@interface AlbumSearchManager()

@property(nonatomic,strong) NSString * albumsFilePath;

@end
@implementation AlbumSearchManager


+ (id)sharedManager {
    static AlbumSearchManager *sharedSearchManager = nil;
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
        //create albums file if it doesn't exist
        [self createAlbumsFile];
        
    }
    return self;
}

-(NSArray*)getAlbums {
    
    
    NSData *fileContent = [[NSData alloc] initWithContentsOfFile:self.albumsFilePath];
    
    NSArray * jsonResponse = [NSJSONSerialization JSONObjectWithData:fileContent options:kNilOptions error:nil];

    NSLog(@"albums %@",jsonResponse);
    return jsonResponse;
    
    //return @[@{@"id":@"1",@"name":@"Album name 1",@"thumbnailID":@"1",@"count":@2},@{@"id":@"2",@"name":@"Album name 2",@"thumbnailID":@"2",@"count":@3}];
}
-(NSArray*)getAlbum:(NSString*)albumID
{
    
    NSData *fileContent = [[NSData alloc] initWithContentsOfFile:[self filePathForAlbumID:albumID]];
    
    NSArray * jsonResponse = [NSJSONSerialization JSONObjectWithData:fileContent options:kNilOptions error:nil];
    
    NSLog(@"album %@",jsonResponse);
    
    return jsonResponse;
}

-(void)createAlbum:(NSString*)albumName {
    
    NSString * albumID=[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    
    NSMutableArray * currentAlbums=[[NSMutableArray alloc] initWithArray:[self getAlbums]];
    [currentAlbums addObject:@{@"name":albumName,@"id":albumID,@"count":@0,@"timestamp":[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]]}];
    
    //update albums file
    [self updateAlbumsFile:currentAlbums];
    
    //initialize new album's file
    [self createAlbumFile:albumID];
}

-(void)addMediaToAlbum:(NSString*)albumID withMedia:(NSString*)mediaID type:(NSString*)type;
{
    
    
    NSMutableArray * currentMedias=[[NSMutableArray alloc] initWithArray:[self getAlbum:albumID]];
    [currentMedias addObject:@{@"id":mediaID,@"type":type,@"timestamp":[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]]}];
    
    //update albums file
    [self updateAlbumID:albumID withArray:currentMedias];
    
    [self updateCount:currentMedias.count forAlbum:albumID];

}
-(void)createAlbumsFile {

    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.albumsFilePath]) { // if file is not exist, create it.
        //NSString *initialContents = @"[{\"id\":\"1\",\"name\":\"Album name 3\",\"thumbnailID\":\"1\",\"count\":2}]";
        NSString *initialContents = @"[]";
        NSError *error;
        [initialContents writeToFile:self.albumsFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
    if ([[NSFileManager defaultManager] isWritableFileAtPath:self.albumsFilePath]) {
        NSLog(@"Writable");
    }else {
        NSLog(@"Not Writable");
    }

    
}
-(void)createAlbumFile:(NSString*)albumID {
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self filePathForAlbumID:albumID]]) { // if file is not exist, create it.
        //NSString *initialContents = @"[{\"id\":\"1\",\"name\":\"Album name 3\",\"thumbnailID\":\"1\",\"count\":2}]";
        NSString *initialContents = @"[]";
        NSError *error;
        [initialContents writeToFile:[self filePathForAlbumID:albumID] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
    if ([[NSFileManager defaultManager] isWritableFileAtPath:[self filePathForAlbumID:albumID]]) {
        NSLog(@"Writable");
    }else {
        NSLog(@"Not Writable");
    }
    
    
}
-(void)updateAlbumsFile:(NSArray*)array {
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    [jsonData writeToFile:self.albumsFilePath atomically:YES];
    
    
    
}


-(void)updateAlbumID:(NSString*)albumID withArray:(NSArray*)array {
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    [jsonData writeToFile:[self filePathForAlbumID:albumID] atomically:YES];
    
    
    
}

-(void)deleteAlbum:(NSString*)albumID {
    
    NSMutableArray * updatedAlbums=[[NSMutableArray alloc] init];
    
    NSArray * currentAlbums=[[NSMutableArray alloc] initWithArray:[self getAlbums]];

    for(NSDictionary * entry in currentAlbums)
    {
        if(![entry[@"id"] isEqualToString:albumID])
            [updatedAlbums addObject:entry];
    }
    
    NSLog(@"updatedAlbums %@",updatedAlbums);
    [self updateAlbumsFile:updatedAlbums];

    
    
}

-(NSString*)albumsFilePath {
    
    if(_albumsFilePath==nil)
    {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"albums.json"];
        NSLog(@"filePath %@", filePath);
        
        _albumsFilePath=filePath;

    }
    return _albumsFilePath;
    
}
-(NSString*)filePathForAlbumID:(NSString*) albumID {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.json", documentsDirectory, albumID];
    NSLog(@"filePath %@", filePath);
    
    return filePath;
}

-(void)imageForMediaID:(NSString*)mediaID completion:(void(^)(UIImage * image))completionBlock
{

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.png", documentsDirectory, mediaID];
    NSLog(@"filePath %@", filePath);

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        UIImage *image = [[UIImage alloc] initWithData:imgData];
        
        //Do background work
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            completionBlock(image);

        });
    });
    
}

-(void)updateCount:(NSInteger)count forAlbum:(NSString*)albumID {
    
    
    NSMutableArray * updatedAlbums=[[NSMutableArray alloc] init];
    
    NSArray * currentAlbums=[[NSMutableArray alloc] initWithArray:[self getAlbums]];
    
    for(NSDictionary * entry in currentAlbums)
    {
        if([entry[@"id"] isEqualToString:albumID])
        {
            NSMutableDictionary * updatedEntry = [[NSMutableDictionary alloc] initWithDictionary:entry];
            updatedEntry[@"count"]=[NSNumber numberWithInt:count];
            
            [updatedAlbums addObject:updatedEntry];

        }
        else {
            
            [updatedAlbums addObject:entry];

            
        }
    }
    
    NSLog(@"updatedAlbums %@",updatedAlbums);
    [self updateAlbumsFile:updatedAlbums];
    

}

-(NSURL*)videoURLforMediaID:(NSString*)mediaID
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, mediaID];
    NSLog(@"filePath %@", filePath);
    
    
    return [NSURL fileURLWithPath:filePath];
}
-(void)deleteMediaID:(NSString*)mediaID withAlbumID:(NSString*)albumID completion:(void(^)(void))completionBlock {
    
    //delete image in album
    
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSMutableArray * updatedMedias=[[NSMutableArray alloc] init];
        
        NSArray * currentMedias=[[NSMutableArray alloc] initWithArray:[self getAlbum:albumID]];
        
        for(NSDictionary * entry in currentMedias)
        {
            if(![entry[@"id"] isEqualToString:mediaID])
                [updatedMedias addObject:entry];
        }
        
        NSLog(@"updatedAlbum %@",updatedMedias);
        [weakSelf updateAlbumID:albumID withArray:updatedMedias];
        
        
        [weakSelf updateCount:updatedMedias.count forAlbum:albumID];
        
        
        //adjust count for album
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock();
        });
    });
}
-(void)mediaForMediaID:(NSString*)mediaID withType:(NSString*)type completion:(void(^)(id media))completionBlock
{

    if(![type isEqualToString:@"video"])
    {
        [[AlbumSearchManager sharedManager] imageForMediaID:mediaID completion:^(UIImage *image) {
            completionBlock(image);
        }];
    }
    else {
        
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, mediaID];
        NSLog(@"filePath %@", filePath);
        dispatch_async(dispatch_get_main_queue(), ^{
            //completionBlock([NSData dataWithContentsOfFile:filePath]);
            completionBlock([NSURL fileURLWithPath:filePath]);
        });

    }

}

@end
