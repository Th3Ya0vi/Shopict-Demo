//
//  SPInterestButton.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月22日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPInterestButton.h"

@implementation SPInterestButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    // Allow default layout, then adjust image and label positions
    [super layoutSubviews];
    
    UIImageView *imageView = [self imageView];
    UILabel *label = [self titleLabel];
    
    imageView.frame = CGRectMake(22, 15, 50, 50);
    label.frame = CGRectMake(0, 75, 95, 20);
}

@end
