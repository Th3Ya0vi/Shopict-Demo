//
//  SPPostListCell.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月25日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPPostGridCell.h"
#import "SPProduct.h"
#import "SPAccount.h"
#import "SPPost.h"
#import "UIButton+WebCache.h"

@implementation SPPostGridCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.gridViews = [self.gridViews sortedArrayWithOptions:NSSortStable
                                                  usingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
                                                      if (obj1.tag > obj2.tag) {
                                                          return NSOrderedDescending;
                                                      } else if (obj1.tag < obj2.tag) {
                                                          return NSOrderedAscending;
                                                      }
                                                      return NSOrderedSame;
                                                  }];
    self.productImageButtons = [self.productImageButtons sortedArrayWithOptions:NSSortStable
                                                  usingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
                                                      if (obj1.tag > obj2.tag) {
                                                          return NSOrderedDescending;
                                                      } else if (obj1.tag < obj2.tag) {
                                                          return NSOrderedAscending;
                                                      }
                                                      return NSOrderedSame;
                                                  }];
    self.productNameLabels = [self.productNameLabels sortedArrayWithOptions:NSSortStable
                                                  usingComparator:^NSComparisonResult(UILabel *obj1, UILabel *obj2) {
                                                      if (obj1.tag > obj2.tag) {
                                                          return NSOrderedDescending;
                                                      } else if (obj1.tag < obj2.tag) {
                                                          return NSOrderedAscending;
                                                      }
                                                      return NSOrderedSame;
                                                  }];
    self.productPriceLabels = [self.productPriceLabels sortedArrayWithOptions:NSSortStable
                                                  usingComparator:^NSComparisonResult(UILabel *obj1, UILabel *obj2) {
                                                      if (obj1.tag > obj2.tag) {
                                                          return NSOrderedDescending;
                                                      } else if (obj1.tag < obj2.tag) {
                                                          return NSOrderedAscending;
                                                      }
                                                      return NSOrderedSame;
                                                  }];
    for (UIButton *button in self.productImageButtons) {
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
}

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

- (void)dealloc
{
    [_posts release];
    [_gridViews release];
    [_productImageButtons release];
    [_productNameLabels release];
    [_productPriceLabels release];
    [super dealloc];
}

- (void) setPosts:(NSMutableArray *)posts
{
    if (_posts!= posts)
    {
        [_posts release];
        _posts = [posts retain];
    }
    
    for (UIView *view in self.gridViews) {
        view.hidden = YES;
    }
    
    for (NSInteger i = 0;i < self.posts.count; i++) {
        SPPost *post = [self.posts objectAtIndex:i];
        SPProduct *product = post.product;
        UIView *view = [self.gridViews objectAtIndex:i];
        UIButton *button = [self.productImageButtons objectAtIndex:i];
        UILabel *nameLabel = [self.productNameLabels objectAtIndex:i];
        UILabel *descLabel = [self.productPriceLabels objectAtIndex:i];
        nameLabel.hidden = YES;
        descLabel.hidden = YES;
        SPAccount *account = post.author;
        
        view.hidden = NO;
        if (product.thumbnailURLs.count > 0) {
            [button setImageWithURL:[NSURL URLWithString:[product.thumbnailURLs objectAtIndex:0]] forState:UIControlStateNormal];
        }
        [nameLabel setText:product.name];
        [descLabel setText:[NSString stringWithFormat:@"%@",account.name]];
    }
}

- (IBAction)imageButtonPressed:(id)sender {
    UIButton *button = sender;
    if ([self.delegate respondsToSelector:@selector(SPPostGridCellDidSelectPost:)]) {
        [self.delegate SPPostGridCellDidSelectPost:[self.posts objectAtIndex:button.tag]];
    }
}


@end
