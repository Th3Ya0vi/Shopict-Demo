//
//  SBCategorySelectionViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import "EGORefreshTableHeaderView.h"

@class SPCategory;

@protocol SPCategorySelectionViewControllerDelegate <NSObject>

- (void)SPCategorySelectionViewControllerDidSelectCategory:(SPCategory *)category;

@end

@interface SPCategorySelectionViewController : SPBaseTabbedViewController
<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UITableView *categoryTableView;
@property (retain, nonatomic) NSMutableArray *categories;
@property (retain, nonatomic) SPCategory *category;

@end
