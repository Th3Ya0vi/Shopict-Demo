//
//  SPPostListCell.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月25日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPPostListCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SPProduct.h"
#import "SPAccount.h"
#import "SPUtility.h"
#import "SPPost.h"
#import <QuartzCore/QuartzCore.h>

@implementation SPPostListCell

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
    
	self.loadingLabel.backgroundColor = [UIColor clearColor];
	self.loadingLabel.font = [UIFont fontWithName:@"Blanch-Caps" size:35.0];
	self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.textColor = [UIColor colorWithRed:208/255.0 green:35/255.0 blue:28/255.0 alpha:1];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [singleTapGestureRecognizer requireGestureRecognizerToFail: doubleTapGestureRecognizer];
    [self.tapView addGestureRecognizer:singleTapGestureRecognizer];
    [self.tapView addGestureRecognizer:doubleTapGestureRecognizer];
    [singleTapGestureRecognizer release];
    [doubleTapGestureRecognizer release];
    
    [self.wantItButton setImage:[UIImage imageNamed:@"button_list_heart_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.wantItButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.wantItButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.wantItButton setTitle:@"Want" forState:UIControlStateNormal];
    [self.wantItButton setTitle:@"Want'd" forState:UIControlStateSelected];
    [self.wantItButton setTitle:@"Want'd" forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.repostButton setImage:[UIImage imageNamed:@"button_list_repost_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.repostButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.repostButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.repostButton setTitle:@"Repict" forState:UIControlStateNormal];
    [self.repostButton setTitle:@"Repict'd" forState:UIControlStateSelected];
    [self.repostButton setTitle:@"Repict'd" forState:UIControlStateSelected|UIControlStateHighlighted];
    
//    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
//    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
//    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.productImageView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4.0, 4.0)].CGPath;
//    self.productImageView.layer.masksToBounds = YES;
//    self.productImageView.layer.mask = shapeLayer;
//    shapeLayer.frame = self.productImageView.layer.bounds;

    [self.productImageView.layer setCornerRadius:4.0f];
    [self.productImageView.layer setMasksToBounds:YES];

}

-(IBAction)handleSingleTap:(id)sender
{
    if (self.post) {
        if ([self.delegate respondsToSelector:@selector(SPPostListCellDidSelectPost:)]) {
            [self.delegate SPPostListCellDidSelectPost:self.post];
        }
    }
}

- (void)dealloc{
    [_productImageView release];
    [_commentButton release];
    [_productNameLabel release];
    [_productPriceLabel release];
    [_accountNameLabel release];
    [_wantItButton release];
    [_commentCountLabel release];
    [_wantCountLabel release];
    [_loadingLabel release];
    [_tapView release];
    [_repostButton release];
    [_buttonSeperator release];
    [_editorsPictView release];
    [_midBackgroundImageView release];
    [_productContentView release];
    [_accountImageView release];
    [super dealloc];
}

- (void)setPost:(SPPost *)post
{
    if (_post != post)
    {
        [_post release];
        _post = [post retain];
    }
    SPAccount *account = post.author;
    SPProduct *product = post.product;
    
    [self.loadingLabel setText:nil];
    
    [self.productImageView setContentMode:UIViewContentModeScaleAspectFill];
    float imageRatio = [[product.ratios objectAtIndex:0]floatValue];
    if (imageRatio < 0.7) {
        imageRatio = 0.7;
    }else if (imageRatio > 1){
        [self.productImageView setContentMode:UIViewContentModeScaleAspectFit];
        imageRatio = 1;
    }
    
    [self.productImageView setFrame:CGRectMake(10, 8, 300, 300*imageRatio-7)];
    [self.tapView setFrame:self.productImageView.frame];
    [self.midBackgroundImageView setFrame:CGRectMake(7, 13, 306, 35+300*imageRatio-15)];
    [self.productContentView setFrame:CGRectMake(0, CGRectGetMaxY(self.productImageView.frame)-143, 320, 185)];
    [self setFrame:CGRectMake(0, 0, 320, 7+300*imageRatio+35+8+1)];
    
    [self.productImageView setImageWithURL:[NSURL URLWithString:[product.imgURLs objectAtIndex:0]]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            [self.loadingLabel setText:@"The image gets some problems."];
        }
    }];
    [self.productNameLabel setText:product.name];
    
    NSString *currencyCode = self.post.product.currency;
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    [self.productPriceLabel setText:[NSString stringWithFormat:@"%@%.2f",currencySymbol,self.post.product.price]];
    
    if (self.post.repost) {
        [self.accountNameLabel setText:[NSString stringWithFormat:@"Repict'd by %@",account.name]];
    }else{
        [self.accountNameLabel setText:[NSString stringWithFormat:@"Pict'd by %@",account.name]];
    }
    [self.commentButton setTitle:[NSString stringWithFormat:@"%d",post.commentCount] forState:(UIControlStateNormal)];
    [self.wantCountLabel setText:[NSString stringWithFormat:@"%d",post.wantCount]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%d",post.commentCount]];
    
    CGSize maximumLabelSize = CGSizeMake(self.productNameLabel.frame.size.width,40);
    
    CGSize expectedLabelSize = [self.productNameLabel.text sizeWithFont:self.productNameLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.productNameLabel.lineBreakMode];
    
    
    [self.productNameLabel setFrame:CGRectMake(CGRectGetMinX(self.productNameLabel.frame), CGRectGetMinY(self.accountNameLabel.frame)-expectedLabelSize.height+2, self.productNameLabel.frame.size.width, expectedLabelSize.height)];
    
    if (self.post.product.account.me || self.post.author.me) {
        self.repostButton.hidden = YES;
        self.buttonSeperator.hidden = YES;
        [self.wantItButton setFrame:CGRectMake(80, 144, 151, 35)];
    }else{
        self.repostButton.hidden = NO;
        self.buttonSeperator.hidden = NO;
        [self.wantItButton setFrame:CGRectMake(159, 144, 151, 35)];
    }
    
    self.editorsPictView.hidden = !self.post.isEditorPick;
    self.wantItButton.selected = self.post.isWanted;
    self.repostButton.selected = self.post.isReposted;
    
    if (IS_IPAD) {
        [self.accountImageView setImageWithURL:[NSURL URLWithString:self.post.author.profileImgURL]];
    }
}

- (IBAction)wantButtonPressed:(id)sender {
    if (self.wantItButton.selected) {
        if ([self.delegate respondsToSelector:@selector(SPPostListCellDidWantPost:want:already:)]) {
            [self.delegate SPPostListCellDidWantPost:self.post want:NO already:NO];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(SPPostListCellDidWantPost:want:already:)]) {
            [self.delegate SPPostListCellDidWantPost:self.post want:YES already:NO];
        }
    }
}

-(IBAction)handleDoubleTap:(id)sender
{
    if (self.post.product) {
        BOOL already = self.post.isWanted;
        if ([self.delegate respondsToSelector:@selector(SPPostListCellDidWantPost:want:already:)]) {
            [self.delegate SPPostListCellDidWantPost:self.post want:YES already:already];
        }
    }
}

- (IBAction)repostButtonPressed:(id)sender {
    if (self.repostButton.selected) {
        if ([self.delegate respondsToSelector:@selector(SPPostListCellDidRepostPost:repost:)]) {
            [self.delegate SPPostListCellDidRepostPost:self.post repost:NO];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(SPPostListCellDidRepostPost:repost:)]) {
            [self.delegate SPPostListCellDidRepostPost:self.post repost:YES];
        }
    }
}


@end
