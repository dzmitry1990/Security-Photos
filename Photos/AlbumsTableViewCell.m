//
//  TableViewCell.m
//  UberLyft
//
//  Created by Dzmitry Zhuk on 5/8/16.
//  Copyright © 2016 Fam, Inc. All rights reserved.
//

#import "AlbumsTableViewCell.h"

@interface AlbumsTableViewCell()

@property(nonatomic, strong) UIView * sepatorView;
@property(nonatomic, strong) UIImageView * arrowImageView;


@end

@implementation AlbumsTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.text=@"Lisa Simpson";
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:32.0/2.0];
        self.titleLabel.numberOfLines=1;
        //self.titleLabel.backgroundColor=[UIColor greenColor];
        
        [self addSubview:self.titleLabel];
        
        
        self.photosLabel = [[UILabel alloc] init];
        self.photosLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        self.photosLabel.text=@"Lisa Simpson";
        self.photosLabel.textAlignment=NSTextAlignmentLeft;
        self.photosLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
        self.photosLabel.numberOfLines=1;
        //self.photosLabel.backgroundColor=[UIColor yellowColor];
        
        [self addSubview:self.photosLabel];
        
        self.thumbnailImageView = [[UIImageView alloc] init];
        self.thumbnailImageView.backgroundColor=[UIColor colorWithRed:215.0/255.0 green:218.0/255.0 blue:223.0/255.0 alpha:1.0];
        self.thumbnailImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.thumbnailImageView.clipsToBounds=YES;
        [self addSubview:self.thumbnailImageView];
        
        
        
        self.arrowImageView = [[UIImageView alloc] init];
        self.arrowImageView.image=[UIImage imageNamed:@"arrow.png"];
        self.arrowImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.arrowImageView.clipsToBounds=YES;
        [self addSubview:self.arrowImageView];
        
        
        self.sepatorView = [[UIView alloc] init];
        self.sepatorView.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        [self addSubview:self.sepatorView];
        
    }
    return self;
    
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(102.5, 31.5-5, self.frame.size.width-102.5-40,13+10);
    self.photosLabel.frame = CGRectMake(102.5, 51-5, self.frame.size.width-102.5-40,11+10);
    self.thumbnailImageView.frame = CGRectMake(16, 10, 70, 70);
    //self.thumbnailImageView.layer.cornerRadius=10;

    self.sepatorView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);

    self.arrowImageView.frame = CGRectMake(self.frame.size.width-24, 77/2, 16/2, 26/2);

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
