//
//  SPCategoryCell.h
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月14日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPCategory;
@protocol SPCategoryCellDelegate <NSObject>

- (void)SPCategoryCellDidSelectMoreCategory:(SPCategory *)category;

@end
@interface SPCategoryCell : UITableViewCell


@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (retain, nonatomic) SPCategory *category;
@property (retain, nonatomic) IBOutlet UIButton *moreButton;
@property (retain, nonatomic) IBOutlet UIButton *categoryImageView;


@end
