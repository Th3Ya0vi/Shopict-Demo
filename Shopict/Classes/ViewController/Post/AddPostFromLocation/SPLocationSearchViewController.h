//
//  SPLocationSearchViewController.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月4日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@class SPVenue, SPTableViewFooterView;
@protocol SPLocationSelectionViewControllerDelegate;

@interface SPLocationSearchViewController : SPBaseTabbedViewController
{
	BOOL _reloading;
}

@property (nonatomic, retain) NSString *keyword;

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UITableView *venueTableView;
@property (retain, nonatomic) NSMutableArray *venues;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) BOOL isRequestFailed;

@property (nonatomic, retain) SPTableViewFooterView *footerView;


@end
