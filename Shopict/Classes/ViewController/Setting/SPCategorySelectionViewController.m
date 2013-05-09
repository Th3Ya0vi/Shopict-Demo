//
//  SBCategorySelectionViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPCategorySelectionViewController.h"
#import "SPUtility.h"
#import "SPCategoryCell.h"
#import "SPCategory.h"
#import "UIButton+SPButtonUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPGetCategoriesResponseData.h"

@implementation SPCategorySelectionViewController

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
        [self.navigationItem setTitle:[self.category.name uppercaseString]];
    }else{
        [self.navigationItem setTitle:@"SELECT"];
    }
    
    UIButton *rightBarButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
    [rightBarButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setLeftBarButtonItem:rightBarButtonItem];
    [rightBarButtonItem release];
    
    [self sendCategoryRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_categoryTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCategoryTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SPCategoryCell";
    
    SPCategoryCell *cell = (SPCategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SPCategoryCell" owner:nil options:nil] objectAtIndex:0 ];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.moreButton.hidden = NO;
    SPCategory *category = [self.categories objectAtIndex:indexPath.row];
    cell.category = category;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SPCategory *category = [self.categories objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(SPCategorySelectionViewControllerDidSelectCategory:)]) {
        [self.delegate SPCategorySelectionViewControllerDidSelectCategory:category];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendCategoryRequest
{
    [self sendGetCategoriesRequestWithCategoryId:self.category.categoryId delegate:self];
}

- (void)SPGetCategoriesRequestDidFinish:(SPGetCategoriesResponseData*)response
{
    if (_reloading) {
        [self.categoryTableView reloadData];
        [self doneLoadingTableViewData];
    }
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
    }else{
        self.categories = response.categories;
        [self.categoryTableView reloadData];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	[self sendCategoryRequest];
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
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)SPCategoryCellDidSelectMoreCategory:(SPCategory *)category
{
    if (!category.isLeave) {
        SPCategorySelectionViewController *viewController = [[SPCategorySelectionViewController alloc]initWithNibName:@"SPCategorySelectionViewController" bundle:nil];
        viewController.delegate = self.delegate;
        viewController.category = category;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

@end
