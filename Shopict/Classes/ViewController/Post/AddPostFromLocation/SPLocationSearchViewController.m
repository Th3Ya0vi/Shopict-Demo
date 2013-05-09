//
//  SPLocationSearchViewController.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月4日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPLocationSearchViewController.h"
#import "SPGetFoursquareLocationsByKeywordResponseData.h"
#import "UIButton+SPButtonUtility.h"
#import "SPLocationCell.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPTableViewFooterView.h"
#import "SPUtility.h"
#import "SPLocationSelectionViewController.h"
#import "SPGetFoursquareLocationsByLatLongResponseData.h"
#import "SPFoursquareAttributionCell.h"

@interface SPLocationSearchViewController ()

@end

@implementation SPLocationSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"NEARBY";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self sendLocationRequest];
    
    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_venues release];
    [_venueTableView release];
    [_footerView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setVenueTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.venues.count) {
        static NSString *CellIdentifier = @"SPLocationCell";
        
        SPLocationCell *cell = (SPLocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SPLocationCell" owner:nil options:nil] objectAtIndex:0 ];
        }
        
        cell.venue = [self.venues objectAtIndex:indexPath.row];
        return cell;
    }else{
        static NSString *CellIdentifier = @"SPFoursquareAttributionCell";
        
        SPFoursquareAttributionCell *cell = (SPFoursquareAttributionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SPFoursquareAttributionCell" owner:nil options:nil] objectAtIndex:0 ];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.venues.count) {
        if ([self.delegate respondsToSelector:@selector(SPLocationSelectionViewControllerDidSelectLocation:)]) {
            [self.delegate SPLocationSelectionViewControllerDidSelectLocation:[self.venues objectAtIndex:indexPath.row]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)sendLocationRequest
{
    self.last = NO;
    if ([SPUtility getDeviceLatitude]==0) {
        self.isRequestFailed = YES;
        [self showErrorAlert:@"This feature requires location authorization. Please go to iOS Settings > Privacy > Location to allow Shopict to access your location."];
    }else{
        self.isLoading = YES;
        self.isRequestFailed = NO;
        [self sendGetFoursquareLocationWithKeyword:self.keyword delegate:self];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	[self sendLocationRequest];
}

- (void)SPGetFoursquareLocationsByKeywordRequestDidFinish:(SPGetFoursquareLocationsByKeywordResponseData*)response
{
    self.isLoading = NO;
    if (response.error) {
        self.isRequestFailed = YES;
        [self showErrorAlert:response.error];
    }else{
        self.last = YES;
        self.venues = response.venues;
    }
    [self.venueTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [self.venueTableView reloadData];
    [self.footerView restartLoadingAnimation];
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {
        [self.footerView restartLoadingAnimation];
    }
}

#pragma mark - TableView Delegate

#pragma mark -
#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.venues.count+1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (!self.venues) {
            return self.venueTableView.frame.size.height - self.venueTableView.tableHeaderView.frame.size.height;
        }else if (self.venues.count == 0){
            return 50;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        if (!self.venues || self.venues.count == 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.venueTableView.frame.size.width, self.venueTableView.frame.size.height - self.venueTableView.tableHeaderView.frame.size.height)];
            [self.footerView recenterSubviews];
        }
        
        if (self.venues && self.venues.count != 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.venueTableView.frame.size.width, 50)];
            [self.footerView recenterSubviews];
        }
        
        if (self.isRequestFailed) {
            [self.footerView showReloadButton];
            return self.footerView;
        }
        
        if (!self.last) {
            [self.footerView showLoading];
            if (!self.isLoading) {
                [self sendLocationRequest];
            }
            return self.footerView;
        }else{
            if (self.venues.count == 0) {
                [self.footerView showTitleLabel:@"No results. :("];
            }else{
                [self.footerView showTitleLabel:@"No more results."];
            }
            return self.footerView;
        }
    }
    return nil;
}

- (void)SPTableViewFooterViewDidSelectReload
{
    if (!self.isLoading) {
        self.isRequestFailed = NO;
        [self.venueTableView reloadData];
        [self sendLocationRequest];
    }
}

@end
