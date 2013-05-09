//
//  SPLocationSelectionViewController.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@class SPVenue, SPTableViewFooterView;
@protocol SPLocationSelectionViewControllerDelegate <NSObject>

- (void)SPLocationSelectionViewControllerDidSelectLocation:(SPVenue *)location;

@end


@interface SPLocationSelectionViewController : SPBaseTabbedViewController
{
	BOOL _reloading;
}

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UITableView *venueTableView;
@property (retain, nonatomic) NSMutableArray *venues;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) BOOL isRequestFailed;

@property (nonatomic, retain) SPTableViewFooterView *footerView;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearching;

@end
