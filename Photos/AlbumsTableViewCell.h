//
//  CustomTableViewCell.h
//  Brainstorm
//
//  Created by Dzmitry Zhuk on 9/6/16.
//  Copyright © 2016 Fam, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumsTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel * titleLabel;
@property(nonatomic, strong) UILabel * photosLabel;
@property(nonatomic,strong) UIImageView * thumbnailImageView;

- (void)setUpImageView;

@end
