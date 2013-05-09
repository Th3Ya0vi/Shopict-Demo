//
//  SPProductFeedViewController.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import "EGORefreshTableHeaderView.h"

@class SPTableViewFooterView;
@interface SPPostFeedViewController : SPBaseTabbedViewController

<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

//Product feed table
@property (retain, nonatomic) IBOutlet UITableView *productTableView;

//Products from server
@property (retain, nonatomic) NSMutableArray *posts;

//Key to get the next products
@property (retain, nonatomic) NSString *nextKey;

//No more products to get
@property (assign, nonatomic) BOOL isLastPost;

//Products show in list or grid
@property (assign, nonatomic) BOOL isGridView;

//Is waiting for a request to response
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isRequestFailed;

@property (nonatomic, retain) SPTableViewFooterView *footerView;

- (void)doneLoadingTableViewData;
- (void)reloadAll;
- (void)setIsGridViewButton:(BOOL)isGridView;
- (IBAction)viewStyleButtonPressed:(id)sender;

@end
