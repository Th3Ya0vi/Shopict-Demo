//
//  SPTagCell.m
//  SHOPBOOK
//
//  Created by bichenkk on 13年2月2日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPTagCell.h"
#import "UIColor+SPColorUtility.h"

@implementation SPTagCell

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor themeColor]];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)dealloc {
    [_hashTag release];
    [_tagLabel release];
    [super dealloc];
}

- (void)setHashTag:(NSString *)hashTag
{
    if (_hashTag != hashTag)
    {
        [_hashTag release];
        _hashTag = [hashTag retain];
    }
    [self.tagLabel setText:self.hashTag];
}

@end
