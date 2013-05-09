//
//  SPExploreViewController.h
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import "EGORefreshTableHeaderView.h"

@class SPCategory, SPTableViewFooterView;

@interface SPExploreViewController : SPBaseTabbedViewController

<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property (retain, nonatomic) IBOutlet UITableView *categoryTableView;
@property (retain, nonatomic) NSMutableArray *categories;
@property (retain, nonatomic) SPCategory *category;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, assign) BOOL isSearching;
@property (retain, nonatomic) IBOutlet UIView *searchHeaderView;
@property (retain, nonatomic) IBOutlet UIButton *searchPeopleButton;
@property (retain, nonatomic) IBOutlet UIButton *searchProductButton;
@property (retain, nonatomic) IBOutlet UIButton *searchTagButton;

@property (retain, nonatomic) NSString *searchPeopleNextKey;
@property (retain, nonatomic) NSString *searchTagNextKey;

@property (assign, nonatomic) BOOL searchPeopleLast;
@property (assign, nonatomic) BOOL searchTagLast;

@property (retain, nonatomic) NSMutableArray *searchedAccounts;
@property (retain, nonatomic) NSMutableArray *searchedTags;

@property (retain, nonatomic) SPTableViewFooterView *footerView;

@property (assign, nonatomic) BOOL isRequestFailed;

- (IBAction)searchTypeButtonPressed:(id)sender;

@end
