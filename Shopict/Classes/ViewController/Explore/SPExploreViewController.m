//
//  SPExploreViewController.m
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPExploreViewController.h"
#import "NSString+SPStringUtility.h"
#import "SPUtility.h"
#import "SPCategoryCell.h"
#import "SPCategory.h"
#import "SPPostListCell.h"
#import "SPPostGridCell.h"
#import "SPAccountCell.h"
#import "SPTagCell.h"
#import "SPProduct.h"
#import "SPProfileViewController.h"
#import "SPAccount.h"
#import "SPTableViewFooterView.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPGetCategoriesResponseData.h"
#import "SPGetAccountsResponseData.h"
#import "SPGetTagsByKeywordResponseData.h"
#import "UIColor+SPColorUtility.h"

@interface SPExploreViewController ()

@end

@implementation SPExploreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.category) {
        self.navigationItem.title = [NSString localizedStringWithKey:[self.category.name uppercaseString]];
    }else{
        self.navigationItem.title = [NSString localizedStringWithKey:@"EXPLORE"];
    }
    
    [self.searchBar setTintColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f]];
    
    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.delegate = self;
    
    [self.searchPeopleButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.searchProductButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.searchTagButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected | UIControlStateHighlighted];
//    
//    if (_refreshHeaderView == nil) {
//		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.categoryTableView.bounds.size.height, self.view.frame.size.width, self.categoryTableView.bounds.size.height)];
//		view.delegate = self;
//		[self.categoryTableView addSubview:view];
//		_refreshHeaderView = view;
//		[view release];
//	}
    
    [self sendCategoryRequest];
    
    self.searchProductButton.selected = YES;
    
    if (self.category) {
        self.searchBar.hidden = YES;
        [self.categoryTableView setFrame:self.view.frame];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    if (self.isSearching) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [self.categoryTableView reloadData];
    [_refreshHeaderView startLoadingAnimation];
    [self.footerView restartLoadingAnimation];
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {
        [self.categoryTableView reloadData];
        [_refreshHeaderView startLoadingAnimation];
        [self.footerView restartLoadingAnimation];
        if (!self.categories||[SPUtility shouldReload]) {
            [self sendCategoryRequest];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_categoryTableView release];
    [_searchBar release];
    [_searchHeaderView release];
    [_searchPeopleButton release];
    [_searchProductButton release];
    [_searchTagButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCategoryTableView:nil];
    [self setSearchBar:nil];
    [self setSearchHeaderView:nil];
    [self setSearchPeopleButton:nil];
    [self setSearchProductButton:nil];
    [self setSearchTagButton:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearching) {
        if (self.searchProductButton.selected == YES) {
            return 1;
        }
        if (self.searchPeopleButton.selected == YES) {
            if (self.searchBar.text.length == 0) {
                return 1;
            }
            return 2;
        }
        if (self.searchTagButton.selected == YES) {
            if (self.searchBar.text.length == 0) {
                return 1;
            }
            return 2;
        }
    }else{
        if (self.categories) {
            return 1;
        }else{
            return 2;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.isSearching) {
            if (self.searchProductButton.selected == YES) {
                //return [SPUtility getSearchHistoryWithType:PRODUCT].count;
            }
            if (self.searchPeopleButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    return self.searchedAccounts.count;
                }else{
                    //return [SPUtility getSearchHistoryWithType:PEOPLE].count;
                }
            }
            if (self.searchTagButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    return self.searchedTags.count;
                }else{
                    //return [SPUtility getSearchHistoryWithType:TAG].count;
                }
            }
            return 0;
        }else{
            if (self.category) {
                if (self.categories) {
                    return [self.categories count]+1;
                }
            }
            return [self.categories count];
        }
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.isSearching) {
            if (self.searchProductButton.selected == YES) {
                return [self searchedRecordCellForRowAtIndexPath:indexPath type:PRODUCT];
            }
            if (self.searchPeopleButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    
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
                    cell.hideFollowButton = YES;
                    SPAccount *account = [self.searchedAccounts objectAtIndex:indexPath.row];
                    cell.account = account;
                    return cell;
                    
                }else{
                    return [self searchedRecordCellForRowAtIndexPath:indexPath type:PEOPLE];
                }
            }
            if (self.searchTagButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    
                    static NSString *CellIdentifier = @"SPTagCell";
                    SPTagCell *cell = (SPTagCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil)
                    {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"SPTagCell" owner:nil options:nil] objectAtIndex:0 ];
                    }
                    NSString *hastTag = [self.searchedTags objectAtIndex:indexPath.row];
                    cell.hashTag = hastTag;
                    return cell;
                    
                }else{
                    return [self searchedRecordCellForRowAtIndexPath:indexPath type:TAG];
                }
            }
            return nil;
        }else{
            static NSString *CellIdentifier = @"SPCategoryCell";
            SPCategoryCell *cell = (SPCategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SPCategoryCell" owner:nil options:nil] objectAtIndex:0 ];
            }
            if (self.category) {
                if (indexPath.row == 0) {
                    cell.categoryNameLabel.text = @"All";
                }else{
                    SPCategory *category = [self.categories objectAtIndex:indexPath.row-1];
                    cell.category = category;
                }
            }else{
                SPCategory *category = [self.categories objectAtIndex:indexPath.row];
                cell.category = category;
            }
            cell.moreButton.hidden = YES;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            return cell;
        }
    }
    return nil;
}

- (UITableViewCell *)searchedRecordCellForRowAtIndexPath:(NSIndexPath *)indexPath type:(SearchType)searchType
{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = (UITableViewCell *)[self.categoryTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor colorWithRed:208/255.0 green:35/255.0 blue:28/255.0 alpha:1]];
        [cell setSelectedBackgroundView:bgColorView];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[[SPUtility getSearchHistoryWithType:searchType]objectAtIndex:indexPath.row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSearching) {
        if (self.searchProductButton.selected == YES) {
            [SPUtility addSearchHistory:[[SPUtility getSearchHistoryWithType:PRODUCT]objectAtIndex:indexPath.row] type:PRODUCT];
        }
        if (self.searchPeopleButton.selected == YES) {
            if (self.searchBar.text.length != 0) {
                SPAccount *account = [self.searchedAccounts objectAtIndex:indexPath.row];
                SPProfileViewController *profileViewController = [[SPProfileViewController alloc]initWithNibName:(IS_IPAD?@"SPProfileViewController_iPad":@"SPProfileViewController") bundle:nil];
                profileViewController.account = account;
                [self.navigationController pushViewController:profileViewController animated:YES];
                [profileViewController release];
            }else{
                self.searchBar.text = [[SPUtility getSearchHistoryWithType:PEOPLE]objectAtIndex:indexPath.row];
                [SPUtility addSearchHistory:self.searchBar.text type:PEOPLE];
                [self.categoryTableView reloadData];
                [self sendGetAccountsByKeywordRequest];
            }
        }
        if (self.searchTagButton.selected == YES) {
            if (self.searchBar.text.length != 0) {
                NSString *hastTag = [self.searchedTags objectAtIndex:indexPath.row];
                [self goToPostHashTagFeedViewControllerWithHashTag:hastTag];
            }else{
                self.searchBar.text = [[SPUtility getSearchHistoryWithType:PEOPLE]objectAtIndex:indexPath.row];
                [SPUtility addSearchHistory:self.searchBar.text type:TAG];
                [self.categoryTableView reloadData];
                [self sendGetTagsByKeywordRequest];
            }
        }
        }else{
            if (self.category) {
                if (indexPath.row == 0) {
                    
                    [self goToPostCategoryFeedViewController:self.category];
                    
                }else{
                    SPCategory *category = [self.categories objectAtIndex:indexPath.row-1];
                    NSLog(@"%@ Selected",category.name);
                    if (!category.isLeave) {
                        
                        [self goToExploreViewControllerWithCategory:category];
                        
                    }else{
                        
                        [self goToPostCategoryFeedViewController:category];
                    
                    }
                }
            }else{
                SPCategory *category = [self.categories objectAtIndex:indexPath.row];
                NSLog(@"%@ Selected",category.name);
                if (!category.isLeave) {
                    
                    [self goToExploreViewControllerWithCategory:category];
                    
                }else{
                    
                    [self goToPostCategoryFeedViewController:category];
                    
                }
            }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.isSearching) {
            
            if (self.searchProductButton.selected == YES) {
                return 45;
            }
            if (self.searchPeopleButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    if (IS_IPAD) {
                        return 76;
                    }
                    return 55;
                }else{
                    return 45;
                }
            }
            if (self.searchTagButton.selected == YES) {
                return 45;
            }
            return 0;
        }else{
            return 45;
        }
        
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.isSearching) {
            if (section == 0) {
                return self.searchHeaderView;
            }
        }
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.isSearching) {
            if (section == 0) {
                return 35;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.isSearching) {
            if (self.searchProductButton.selected == YES) {
                return 0;
            }
            if (self.searchPeopleButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    if (!self.searchedAccounts || self.searchedAccounts.count == 0) {
                        return self.categoryTableView.frame.size.height - self.categoryTableView.tableHeaderView.frame.size.height - self.searchBar.frame.size.height;
                    }
                    if (self.searchedAccounts && self.searchedAccounts.count != 0) {
                        return 50;
                    }
                }else{
                    return 0;
                }
            }
            if (self.searchTagButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    if (!self.searchedTags || self.searchedTags.count == 0) {
                        return self.categoryTableView.frame.size.height - self.categoryTableView.tableHeaderView.frame.size.height - self.searchBar.frame.size.height;
                    }
                    if (self.searchedTags && self.searchedTags.count != 0) {
                        return 50;
                    }
                }else{
                    return 0;
                }
            }
            return 0;
        }else{
            if (!self.categories) {
                return self.categoryTableView.frame.size.height - self.searchBar.frame.size.height;
            }
            if (self.categories) {
                return 0;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.isSearching) {
            if (self.searchProductButton.selected == YES) {
                return nil;
            }
            if (self.searchPeopleButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    if (!self.searchedAccounts || self.searchedAccounts.count == 0) {
                        [self.footerView setFrame:CGRectMake(0, 0, self.categoryTableView.frame.size.width, self.categoryTableView.frame.size.height - self.categoryTableView.tableHeaderView.frame.size.height - self.searchBar.frame.size.height)];
                        [self.footerView recenterSubviews];
                    }
                    if (self.searchedAccounts && self.searchedAccounts.count != 0) {
                        [self.footerView setFrame:CGRectMake(0, 0, self.categoryTableView.frame.size.width, 50)];
                        [self.footerView recenterSubviews];
                    }
                    
                    if (self.isRequestFailed) {
                        [self.footerView showReloadButton];
                        return self.footerView;
                    }else{
                        if (!self.searchPeopleLast) {
                            [self.footerView showLoading];
                            [self sendGetAccountsByKeywordRequest];
                            return self.footerView;
                        }else{
                            if (self.searchedAccounts.count == 0) {
                                [self.footerView showTitleLabel:@"No result. :("];
                            }else{
                                [self.footerView showTitleLabel:@"No more result."];
                            }
                            return self.footerView;
                        }
                    }
                }else{
                    return nil;
                }
            }
            if (self.searchTagButton.selected == YES) {
                if (self.searchBar.text.length != 0) {
                    if (!self.searchedTags || self.searchedTags.count == 0) {
                        [self.footerView setFrame:CGRectMake(0, 0, self.categoryTableView.frame.size.width, self.categoryTableView.frame.size.height - self.categoryTableView.tableHeaderView.frame.size.height - self.searchBar.frame.size.height)];
                        [self.footerView recenterSubviews];
                    }
                    if (self.searchedTags && self.searchedTags.count != 0) {
                        [self.footerView setFrame:CGRectMake(0, 0, self.categoryTableView.frame.size.width, 50)];
                        [self.footerView recenterSubviews];
                    }
                    
                    if (self.isRequestFailed) {
                        [self.footerView showReloadButton];
                        return self.footerView;
                    }else{
                        if (!self.searchTagLast) {
                            [self.footerView showLoading];
                            [self sendGetTagsByKeywordRequest];
                            return self.footerView;
                        }else{
                            if (self.searchedTags.count == 0) {
                                [self.footerView showTitleLabel:@"No result. :("];
                            }else{
                                [self.footerView showTitleLabel:@"No more result."];
                            }
                            return self.footerView;
                        }
                    }
                }else{
                    return nil;
                }
            }
            return nil;
        }else{
            if (!self.categories) {
                [self.footerView setFrame:CGRectMake(0, 0, self.categoryTableView.frame.size.width, self.categoryTableView.frame.size.height - self.searchBar.frame.size.height)];
                [self.footerView recenterSubviews];
            }
            if (self.categories) {
                [self.footerView setFrame:CGRectMake(0, 0, self.categoryTableView.frame.size.width, 50)];
                [self.footerView recenterSubviews];
            }
            
            if (self.isRequestFailed) {
                [self.footerView showReloadButton];
                return self.footerView;
            }else{
                [self.footerView showLoading];
                return self.footerView;
            }
        }
    }
    return nil;
}

- (void)SPTableViewFooterViewDidSelectReload
{
    self.isRequestFailed = NO;
    [self.categoryTableView reloadData];
    if (self.isSearching) {
        if (self.searchProductButton.selected == YES) {
        }
        if (self.searchPeopleButton.selected == YES) {
            [self sendGetAccountsByKeywordRequest];
        }
        if (self.searchTagButton.selected == YES) {
            [self sendGetTagsByKeywordRequest];
        }
    }else{
        [self sendCategoryRequest];
    }
}


- (void)sendCategoryRequest
{
    self.isRequestFailed = NO;
    
    [self sendGetCategoriesRequestWithCategoryId:self.category.categoryId delegate:self];

}

- (void)SPGetCategoriesRequestDidFinish:(SPGetCategoriesResponseData*)response
{
    if (_reloading) {
        [self.categoryTableView reloadData];
        [self doneLoadingTableViewData];
    }
    if (response.error) {
        self.isRequestFailed = YES;
        if (response.errorType == SPRequestConnectionTokenExpired) {
            [self presentLoginViewController];
            return;
        }else if (response.errorType == SPRequestConnectionFailure){
            [self showHUDErrorViewWithMessage:response.error];
        }else if (response.errorType == SPRequestConnectionJSONError){
            [self showHUDErrorViewWithMessage:@"Please Try Later"];
        }else if (response.errorType == SPRequestConnectionServerError){
            [self showErrorAlert:response.error];
        }
    }else{
        self.categories = response.categories;
    }
    [self.categoryTableView reloadData];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    self.isRequestFailed = NO;
    [self.categoryTableView reloadData];
    if (self.isSearching) {
    }else{
        _reloading = YES;
        [self sendCategoryRequest];
    }
}

- (void)doneLoadingTableViewData{
	
    _reloading = NO;
    if (_refreshHeaderView && self.categoryTableView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.categoryTableView];
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

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.searchBar resignFirstResponder];
    for (UIView *v in self.searchBar.subviews) {
        if ([v isKindOfClass:[UIControl class]]) {
            ((UIControl *)v).enabled = YES;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
    [_refreshHeaderView removeFromSuperview];
    _refreshHeaderView = nil;
    
    [self.categoryTableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self removeAllSearchRecords];
    
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    self.isSearching = NO;
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.categoryTableView.bounds.size.height, self.navigationController.view.frame.size.width, self.categoryTableView.bounds.size.height)];
		view.delegate = self;
		[self.categoryTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
    self.searchBar.text = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.categoryTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self removeAllSearchRecords];
    if (self.searchProductButton.selected == YES) {
        [SPUtility addSearchHistory:self.searchBar.text type:PRODUCT];
        [self goToPostSearchFeedViewController:self.searchBar.text];
    }
    if (self.searchPeopleButton.selected == YES) {
        [SPUtility addSearchHistory:self.searchBar.text type:PEOPLE];
        [self sendGetAccountsByKeywordRequest];
    }
    if (self.searchTagButton.selected == YES) {
        [SPUtility addSearchHistory:self.searchBar.text type:TAG];
        [self sendGetTagsByKeywordRequest];
    }
    
    for (UIView *v in searchBar.subviews) {
        if ([v isKindOfClass:[UIControl class]]) {
            ((UIControl *)v).enabled = YES;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self removeAllSearchRecords];
}

- (IBAction)searchTypeButtonPressed:(id)sender {
    
    UIButton *button = sender;
    if (button.selected == NO) {
        [self removeAllSearchRecords];
    }
    
    [self.searchBar becomeFirstResponder];
    
    self.searchPeopleButton.selected = NO;
    self.searchProductButton.selected = NO;
    self.searchTagButton.selected = NO;
    
    if ([self.searchPeopleButton isEqual:sender]) {
        self.searchPeopleButton.selected = YES;
    }
    if ([self.searchProductButton isEqual:sender]) {
        self.searchProductButton.selected = YES;
    }
    if ([self.searchTagButton isEqual:sender]) {
        self.searchTagButton.selected = YES;
    }
    
    [self.categoryTableView reloadData];
}

- (void)sendGetAccountsByKeywordRequest{
    
    [self sendGetAccountsByKeywordRequestWithKeyword:self.searchBar.text startKey:self.searchPeopleNextKey delegate:self];
}

- (void)SPGetAccountsByKeywordRequestDidFinish:(SPGetAccountsResponseData*)response startKey:(NSString *)startKey
{
    if (response.error) {
        if (response.errorType == SPRequestConnectionTokenExpired) {
            [self presentLoginViewController];
            return;
        }else if (response.errorType == SPRequestConnectionFailure){
            [self showHUDErrorViewWithMessage:response.error];
        }else if (response.errorType == SPRequestConnectionJSONError){
            [self showHUDErrorViewWithMessage:@"Please Try Later"];
        }else if (response.errorType == SPRequestConnectionServerError){
            [self showErrorAlert:response.error];
        }
        self.isRequestFailed = YES;
    }else{
        
        if (!startKey) {
            self.searchedAccounts = nil;
            [self.categoryTableView reloadData];
        }
        
        self.searchPeopleNextKey = response.nextKey;
        
        if (!response.nextKey) {
            self.searchPeopleLast = YES;
        }
        
        if (!self.searchedAccounts) {
            self.searchedAccounts = response.accounts;
        }else{
            for (SPAccount *toAddAccount in response.accounts) {
                BOOL included = NO;
                for (SPAccount *account in self.searchedAccounts) {
                    if ([account.accountId isEqualToString:toAddAccount.accountId]) {
                        included = YES;
                    }
                }
                if (!included) {
                    [self.searchedAccounts addObject:toAddAccount];
                }
                
            }
        }
        [self.categoryTableView reloadData];
    }
}

- (void)sendGetTagsByKeywordRequest{
    
    [self sendGetTagsByKeywordRequestWithKeyword:self.searchBar.text startKey:self.searchTagNextKey delegate:self];
}

- (void)SPGetTagsByKeywordRequestDidFinish:(SPGetTagsByKeywordResponseData*)response startKey:(NSString *)startKey
{
    if (response.error) {
        self.isRequestFailed = YES;
        if (response.errorType == SPRequestConnectionTokenExpired) {
            [self presentLoginViewController];
            return;
        }else if (response.errorType == SPRequestConnectionFailure){
            [self showHUDErrorViewWithMessage:response.error];
        }else if (response.errorType == SPRequestConnectionJSONError){
            [self showHUDErrorViewWithMessage:@"Please Try Later"];
        }else if (response.errorType == SPRequestConnectionServerError){
            [self showErrorAlert:response.error];
        }
    }else{
        
        if (!startKey) {
            self.searchedTags = nil;
            [self.categoryTableView reloadData];
        }
        
        self.searchTagNextKey = response.nextKey;
        
        if (!response.nextKey) {
            self.searchTagLast = YES;
        }
        
        if (!self.searchedTags) {
            self.searchedTags = response.tags;
        }else{
            for (NSString *toAddTag in response.tags) {
                BOOL included = NO;
                for (NSString *tag in self.searchedTags) {
                    if ([toAddTag isEqualToString:tag]) {
                        included = YES;
                    }
                }
                if (!included) {
                    [self.searchedTags addObject:toAddTag];
                }
                
            }
        }
        [self.categoryTableView reloadData];
    }
}

- (void)removeAllSearchRecords
{
    self.searchPeopleNextKey = nil;
    self.searchTagNextKey = nil;
    self.searchedAccounts = nil;
    self.searchPeopleLast = NO;
    self.searchTagLast = NO;
    self.searchedTags = nil;
    self.isRequestFailed = NO;
    [self.categoryTableView reloadData];
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
    for (SPAccount *originalAccount in self.searchedAccounts) {
        if ([originalAccount.accountId isEqualToString:account.accountId]) {
            [includedChangedAccounts addObject:originalAccount];
        }
    }
    if (includedChangedAccounts.count > 0) {
        for (SPAccount *toChangeAccount in includedChangedAccounts) {
            [self.searchedAccounts replaceObjectAtIndex:[self.searchedAccounts indexOfObject:toChangeAccount] withObject:account];
        }
    }
    [self.categoryTableView reloadData];
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
