//
//  SPCategoryCell.m
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月14日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPCategoryCell.h"
#import "UIColor+SPColorUtility.h"
#import "SPCategory.h"
#import "UIFont+SPFontUtility.h"
#import "UIButton+WebCache.h"

@implementation SPCategoryCell

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
    [self.categoryNameLabel setFont:[UIFont themeFontWithSize:17]];
    [self.categoryImageView.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)dealloc {
    [_category release];
    [_categoryNameLabel release];
    [_moreButton release];
    [_categoryImageView release];
    [super dealloc];
}

- (void)setCategory:(SPCategory *)category
{
    if (_category != category)
    {
        [_category release];
        _category = [category retain];
    }
    
    if (self.category) {
        [self.categoryNameLabel setText:category.name];
        if (self.category.isLeave) {
            [self.moreButton setHidden:YES];
        }else{
            [self.moreButton setHidden:NO];
        }
    }else{
        [self.moreButton setHidden:YES];
    }
    
    [self.categoryImageView setImageWithURL:[NSURL URLWithString:category.blackImageURL] forState:UIControlStateNormal];
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *whiteImageURL = category.whiteImageURL;
    [manager downloadWithURL:[NSURL URLWithString:whiteImageURL] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image) {
            if ([self.category.whiteImageURL isEqualToString:whiteImageURL]) {
                [self.categoryImageView setImage:image forState:UIControlStateHighlighted];
            }
        }
    }];
}

- (IBAction)moreButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SPCategoryCellDidSelectMoreCategory:)]) {
        [self.delegate SPCategoryCellDidSelectMoreCategory:self.category];
    }
}


@end
