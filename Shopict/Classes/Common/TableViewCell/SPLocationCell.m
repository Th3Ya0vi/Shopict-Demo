//
//  SPLocationCell.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPLocationCell.h"
#import "SPVenue.h"
#import "UIColor+SPColorUtility.h"

@implementation SPLocationCell

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

- (void)dealloc {
    [_nameLabel release];
    [_addressLabel release];
    [_venue release];
    [super dealloc];
}

- (void)setVenue:(SPVenue *)venue
{
    if (_venue != venue)
    {
        [_venue release];
        _venue = [venue retain];
    }
    self.nameLabel.text = venue.name;
    self.addressLabel.text = venue.address;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor themeColor]];
    [self setSelectedBackgroundView:bgColorView];
}

@end
