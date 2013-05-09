//
//  SBProductViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月25日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import "EGORefreshTableHeaderView.h"

@class SPPost, SPTableViewFooterView, IFTweetLabel;

@interface SPPostViewController : SPBaseTabbedViewController
<UIScrollViewDelegate,EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property (retain, nonatomic) SPPost *post;

@property (retain, nonatomic) IBOutlet UITableView *productCommentTableView;
@property (retain, nonatomic) IBOutlet UIView *productMainContentView;

//featured image
@property (retain, nonatomic) IBOutlet UIScrollView *productFeaturedImagesScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControlView;
@property (retain, nonatomic) NSMutableArray *productFeaturedImageActivityIndicators;
@property (retain, nonatomic) NSMutableArray *productFeaturedImageViews;
@property (retain, nonatomic) NSMutableArray *productFeaturedImageButtons;
@property (retain, nonatomic) IBOutlet UILabel *productFeaturedImageSeperator;

@property (retain, nonatomic) IBOutlet UIView *productDescriptionView;
@property (retain, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *productPriceLabel;

@property (retain, nonatomic) IFTweetLabel *productSellerStatusLabel;
@property (retain, nonatomic) IBOutlet UILabel *productSellerLabel;
@property (retain, nonatomic) IBOutlet UIButton *productSellerButton;
@property (retain, nonatomic) IBOutlet UIView *productSellerImageView;
@property (retain, nonatomic) IBOutlet UIButton *productSellerImageButton;
@property (retain, nonatomic) IBOutlet UILabel *productPostTimeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *productPostTimeImageView;


@property (retain, nonatomic) IBOutlet UIView *editorsPictView;

@property (retain, nonatomic) IBOutlet UIButton *repostButton;
@property (retain, nonatomic) IBOutlet UIButton *wantItButton;
@property (retain, nonatomic) IBOutlet UIButton *buyItButton;
@property (retain, nonatomic) IBOutlet UIImageView *wantItButtonSeperator;

@property (retain, nonatomic) IBOutlet UILabel *productDescLabel;
@property (retain, nonatomic) NSMutableArray *tagButtons;
@property (retain, nonatomic) IBOutlet UIButton *productURLButton;
@property (retain, nonatomic) IBOutlet UIImageView *productInfoSeperator;

@property (retain, nonatomic) IBOutlet UIView *wantCountView;
@property (retain, nonatomic) IBOutlet UILabel *wantCountLabel;
@property (retain, nonatomic) IBOutlet UIView *commentCountView;
@property (retain, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (retain, nonatomic) IBOutlet UIView *commentInputView;
@property (retain, nonatomic) IBOutlet UITextField *commentField;
@property (retain, nonatomic) IBOutlet UIButton *commentButton;


@property (retain, nonatomic) IBOutlet UIImageView *commentViewSeperator;

@property (retain, nonatomic) UIView *buyItOptionView;
@property (retain, nonatomic) UIView *buyItView;
@property (retain, nonatomic) NSString *selectedBuyItOption;

@property (assign, nonatomic) BOOL isKeyboardShowAnimated;

@property (retain, nonatomic) NSString *nextKey;
@property (retain, nonatomic) NSMutableArray *comments;

@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isLastComment;
@property (assign, nonatomic) BOOL isRequestFailed;

@property (nonatomic, retain) SPTableViewFooterView *footerView;


@property (assign, nonatomic) float lastContentOffsetY;

- (IBAction)sellerButtonPressed:(id)sender;

@end
