//
//  SPPostListCell.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月25日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPPost;
@protocol SPPostGridCellDelegate <NSObject>

- (void)SPPostGridCellDidSelectPost:(SPPost *)post;

@end

@interface SPPostGridCell : UITableViewCell

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) IBOutletCollection(UIView) NSArray *gridViews;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *productImageButtons;
@property (nonatomic, retain) IBOutletCollection(UILabel) NSArray *productNameLabels;
@property (nonatomic, retain) IBOutletCollection(UILabel) NSArray *productPriceLabels;
@property (nonatomic, retain) NSMutableArray *posts;

- (IBAction)imageButtonPressed:(id)sender;

@end
