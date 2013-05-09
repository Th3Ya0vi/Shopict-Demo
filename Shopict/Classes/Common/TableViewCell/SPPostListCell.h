//
//  SPPostListCell.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月25日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPPost, SPAccount;

@protocol SPPostListCellDelegate <NSObject>

- (void)SPPostListCellDidRepostPost:(SPPost *)post repost:(BOOL)repost;
- (void)SPPostListCellDidWantPost:(SPPost *)post want:(BOOL)want already:(BOOL)already;
- (void)SPPostListCellDidSelectPost:(SPPost *)post;
- (void)SPPostListCellDidSelectAccount:(SPPost *)post;

@end

@interface SPPostListCell : UITableViewCell

@property (assign, nonatomic) id delegate;

@property (retain, nonatomic) IBOutlet UIImageView *productImageView;
@property (retain, nonatomic) IBOutlet UILabel *productNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *wantCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *loadingLabel;
@property (retain, nonatomic) IBOutlet UIButton *wantItButton;
@property (retain, nonatomic) IBOutlet UIButton *commentButton;
@property (retain, nonatomic) IBOutlet UIButton *repostButton;
@property (retain, nonatomic) IBOutlet UIView *tapView;
@property (retain, nonatomic) SPPost *post;
@property (retain, nonatomic) IBOutlet UILabel *buttonSeperator;
@property (retain, nonatomic) IBOutlet UIView *editorsPictView;

@property (retain, nonatomic) IBOutlet UIImageView *midBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIView *productContentView;

@property (retain, nonatomic) IBOutlet UIImageView *accountImageView;

- (IBAction)wantButtonPressed:(id)sender;

@end
