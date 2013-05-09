//
//  SPProfileViewController.h
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import "EGORefreshTableHeaderView.h"

@class SPAccount,SPTableViewFooterView;
@interface SPProfileViewController : SPBaseTabbedViewController
<UITabBarControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property (retain, nonatomic) IBOutlet UITableView *profileTableView;
//Header upper part
@property (retain, nonatomic) IBOutlet UIView *profileHeaderView;
@property (nonatomic, strong) IBOutlet UIImageView *coverImageView;
@property (retain, nonatomic) IBOutlet UIButton *profileImageButton;
@property (retain, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *followingCountLabel;
//Header lower part
@property (retain, nonatomic) IBOutlet UIView *profileInformationView;
@property (retain, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *messageButton;
@property (retain, nonatomic) IBOutlet UIButton *followButton;
@property (retain, nonatomic) IBOutlet UIButton *editProfileButton;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UIButton *websiteButton;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundTopImageView;
//Header section bar
@property (retain, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (retain, nonatomic) IBOutlet UIButton *gridViewButton;
@property (retain, nonatomic) IBOutlet UIButton *wantedButton;
@property (retain, nonatomic) IBOutlet UIButton *sellingButton;
@property (retain, nonatomic) IBOutlet UILabel *sectionHeaderSeperator;

@property (assign, nonatomic) BOOL isTabMe;
@property (retain, nonatomic) SPAccount *account;
@property (assign, nonatomic) BOOL isGridView;
@property (assign, nonatomic) BOOL isWanted;
@property (retain, nonatomic) NSMutableArray *wantedProducts;
@property (retain, nonatomic) NSMutableArray *sellingProducts;
//TableView parameters
@property (retain, nonatomic) NSString *wantedNextKey;
@property (assign, nonatomic) BOOL wantedLastProduct;
@property (retain, nonatomic) NSString *sellingNextKey;
@property (assign, nonatomic) BOOL sellingLastProduct;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isRequestFailed;

@property (nonatomic, retain) SPTableViewFooterView *footerView;

@end
