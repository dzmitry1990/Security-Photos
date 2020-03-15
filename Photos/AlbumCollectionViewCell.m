//
//  BubbleCell.m
//  BestBarBubblesTest
//
//  Created by Dzmitry Zhuk on 2/28/16.
//  Copyright © 2016 Fam, Inc. All rights reserved.
//

#import "AlbumCollectionViewCell.h"

@implementation AlbumCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode=UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds=NO;
        [self addSubview:self.imageView];
        
        self.clipsToBounds=YES;
        
    }
    
    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}
@end
