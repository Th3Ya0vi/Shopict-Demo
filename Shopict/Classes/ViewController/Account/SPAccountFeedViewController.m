//
//  SPAccountFeedViewController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPAccountFeedViewController.h"
#import "SPAccountCell.h"
#import "SPAccount.h"
#import "SPUtility.h"
#import "SPTableViewFooterView.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPGetAccountsResponseData.h"

@interface SPAccountFeedViewController ()

@end

@implementation SPAccountFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.accountTableView.bounds.size.height, self.navigationController.view.frame.size.width, self.accountTableView.bounds.size.height)];
		view.delegate = self;
		[self.accountTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
    
    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [self.accountTableView reloadData];
    [_refreshHeaderView startLoadingAnimation];
    [self.footerView restartLoadingAnimation];
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if (self.isViewLoaded && self.view.window)
    {
        if (!self.accounts || self.isRequestFailed) {
            [self reloadTableViewDataSource];
        }
        
        [self.accountTableView reloadData];
        [_refreshHeaderView startLoadingAnimation];
        [self.footerView restartLoadingAnimation];
    }
}


- (void)dealloc {
    [_footerView release];
    [_accountTableView release];
    [_accounts release];
    [_nextKey release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setAccountTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark TableView Methods

#pragma mark -
#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.accounts) {
        return [self.accounts count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.accounts) {
        static NSString *CellIdentifier = @"SPAccountCell";
        
        SPAccountCell *cell = (SPAccountCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            if (IS_IPAD) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SPAccountCell_iPad" owner:nil options:nil] objectAtIndex:0 ];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SPAccountCell" owner:nil options:nil] objectAtIndex:0 ];
            }
        }
        cell.delegate = self;
        cell.hideFollowButton = NO;
        [cell setAccount:[self.accounts objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (!self.accounts || self.accounts.count == 0) {
            return self.accountTableView.frame.size.height - self.accountTableView.tableHeaderView.frame.size.height;
        }
        if (self.accounts && self.accounts.count != 0) {
            return 50;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 76;
    }
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self goToProfileViewControllerWithAccount:[self.accounts objectAtIndex:indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        if (!self.accounts || self.accounts.count == 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.accountTableView.frame.size.width, self.accountTableView.frame.size.height - self.accountTableView.tableHeaderView.frame.size.height)];
            [self.footerView recenterSubviews];
        }
        if (self.accounts && self.accounts.count != 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.accountTableView.frame.size.width, 50)];
            [self.footerView recenterSubviews];
        }
        
        if (self.isRequestFailed) {
            [self.footerView showReloadButton];
            return self.footerView;
        }
        
        if (!self.isLastAccount) {
            [self.footerView showLoading];
            if (!self.isLoading) {
                [self sendGetAccountsRequest];
            }
            return self.footerView;
        }else{
            if (self.accounts.count == 0) {
                [self.footerView showTitleLabel:@"No user."];
            }else{
                [self.footerView showTitleLabel:@"No more user."];
            }
            return self.footerView;
        }
    }
    return nil;
}

#pragma mark - Request Methods

- (void)sendGetAccountsRequest
{
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y < 100) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
    self.isRequestFailed = NO;
    [self.accountTableView reloadData];
    self.nextKey = nil;
	[self sendGetAccountsRequest];
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
    if (_refreshHeaderView && self.accountTableView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.accountTableView];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading;
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date];
	
}

#pragma mark - Button Events

- (void)SPTableViewFooterViewDidSelectReload
{
    if (!self.isLoading) {
        self.isRequestFailed = NO;
        [self.accountTableView reloadData];
        [self sendGetAccountsRequest];
    }
}

#pragma mark - SBProductListCell Delegate Methods

- (void)SBAccountCellDidFollowAccount:(SPAccount *)account
{
    [self sendSubscribeAccountRequestWithAccount:account subscribe:account.subscribed delegate:self];
}

#pragma mark - Notification-

- (void)accountDidChange:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *changedAccount = [dictionary objectForKey:@"account"];
    NSMutableArray *includedChangedAccounts = [NSMutableArray array];
    for (SPAccount *account in self.accounts) {
        if (account.accountId == changedAccount.accountId) {
            [includedChangedAccounts addObject:account];
        }
    }
    
    if (includedChangedAccounts.count > 0) {
        for (SPAccount *account in includedChangedAccounts) {
            [self.accounts replaceObjectAtIndex:[self.accounts indexOfObject:account] withObject:changedAccount];
        }
        [self.accountTableView reloadData];
    }
}

- (void)accountDidFollow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    [self matchAccount:account];
}

- (void)accountDidUnfollow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    [self matchAccount:account];
}

- (void)accountDidUpdate:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    [self matchAccount:account];
}

- (void)matchAccount:(SPAccount *)account
{
    NSMutableArray *includedChangedAccounts = [NSMutableArray array];
    for (SPAccount *originalAccount in self.accounts) {
        if ([originalAccount.accountId isEqualToString:account.accountId]) {
            [includedChangedAccounts addObject:originalAccount];
        }
    }
    if (includedChangedAccounts.count > 0) {
        for (SPAccount *toChangeAccount in includedChangedAccounts) {
            [self.accounts replaceObjectAtIndex:[self.accounts indexOfObject:toChangeAccount] withObject:account];
        }
    }
    [self.accountTableView reloadData];
}

- (void)SPAccountCellDidFollowAccount:(SPAccount *)account follow:(BOOL)follow
{
    if (follow) {
        [self subscribeAccount:account follow:YES];
    }else{
        [self subscribeAccount:account follow:NO];
    }
}

@end
