//
//  TKTableViewCell.m
//  TKImageIpsumDemo
//
//  Created by Tomasz Kuźma on 6/6/13.
//  Copyright (c) 2013 mapedd. All rights reserved.
//

#import "TKTableViewCell.h"

@implementation TKTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
