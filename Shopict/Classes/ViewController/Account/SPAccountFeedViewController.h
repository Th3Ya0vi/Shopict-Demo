//
//  SPAccountFeedViewController.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import "EGORefreshTableHeaderView.h"

@class SPTableViewFooterView;
@interface SPAccountFeedViewController : SPBaseTabbedViewController
<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property (retain, nonatomic) IBOutlet UITableView *accountTableView;
@property (retain, nonatomic) NSMutableArray *accounts;
@property (retain, nonatomic) NSString *nextKey;
@property (assign, nonatomic) BOOL isLastAccount;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isRequestFailed;
@property (nonatomic, retain) SPTableViewFooterView *footerView;

- (void)doneLoadingTableViewData;

@end
