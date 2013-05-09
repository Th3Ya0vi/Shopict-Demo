//
//  SPProductFeedViewController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPPostFeedViewController.h"
#import "SPPostGridCell.h"
#import "SPPostListCell.h"
#import "SPPost.h"
#import "SPProduct.h"
#import "SPAccount.h"
#import "SPUtility.h"
#import "UIButton+SPButtonUtility.h"
#import "SPTableViewFooterView.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPBaseResponseData.h"
#import "SPGetPostInfoResponseData.h"

@interface SPPostFeedViewController ()

@end

@implementation SPPostFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.productTableView.bounds.size.height, self.navigationController.view.frame.size.width, self.productTableView.bounds.size.height)];
		view.delegate = self;
		[self.productTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
    
    [self setIsGridViewButton:NO];
    
    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.delegate = self;
}

- (void)setIsGridViewButton:(BOOL)isGridView
{
    if (!isGridView) {
        UIButton *barButton = [UIButton barButtonItemWithImage:[UIImage imageNamed:@"button_white_grid"]];
        [barButton addTarget:self action:@selector(viewStyleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
        [barButtonItem release];
        self.isGridView = NO;
    }else{
        UIButton *barButton = [UIButton barButtonItemWithImage:[UIImage imageNamed:@"button_white_list"]];
        [barButton addTarget:self action:@selector(viewStyleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
        [barButtonItem release];
        self.isGridView = YES;
    }
    [self.productTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];

    [self.productTableView reloadData];
    [_refreshHeaderView startLoadingAnimation];
    [self.footerView restartLoadingAnimation];
    
    if (_reloading) {
        [self reloadAll];
        return;
    }
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {
        
        [self.productTableView reloadData];
        [_refreshHeaderView startLoadingAnimation];
        [self.footerView restartLoadingAnimation];
        if (!self.posts) {
            [self reloadAll];
            return;
        }
        if ([SPUtility shouldReload]) {
            [self reloadAll];
            return;
        }
    }
}

- (void)dealloc {
    [_footerView release];
    [_productTableView release];
    [_posts release];
    [_nextKey release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setProductTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.posts) {
        if (self.isGridView) {
            NSInteger postNumber = (IS_IPAD?4:3);
            NSInteger wholeRow = [self.posts count]/postNumber;
            if( [self.posts count]%postNumber == 0 )
                return wholeRow;
            else {
                return wholeRow + 1;
            }
        }else
        {
            return [self.posts count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.posts) {
        if (self.isGridView) {
            static NSString *CellIdentifier = @"SPPostGridCell";
            
            SPPostGridCell *cell = (SPPostGridCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                if (IS_IPAD) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SPPostGridCell_iPad" owner:nil options:nil] objectAtIndex:0 ];
                    NSLog(@"Grid Cell Created");
                }else{
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SPPostGridCell" owner:nil options:nil] objectAtIndex:0 ];
                    NSLog(@"Grid Cell Created");
                }
            }
            cell.delegate = self;
            NSInteger postNumber = (IS_IPAD?4:3);
            NSInteger cellNumber = indexPath.row * postNumber;
            NSMutableArray *mutableArray = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
            for( int i=0; i<postNumber; i++ )
            {
                if( cellNumber <= [self.posts count]-1 )
                {
                    SPPost *product = [self.posts objectAtIndex:cellNumber];
                    [mutableArray addObject:product];
                }
                cellNumber ++;
            }
            [cell setPosts:mutableArray];
            return cell;
        }else{
            static NSString *CellIdentifier = @"SPPostListCell";
            
            SPPostListCell *cell = (SPPostListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                if (IS_IPAD) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SPPostListCell_iPad" owner:nil options:nil] objectAtIndex:0 ];
                    NSLog(@"Product Cell Created");
                }else{
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SPPostListCell" owner:nil options:nil] objectAtIndex:0 ];
                    NSLog(@"Product Cell Created");
                }
            }
            cell.delegate = self;
            SPPost *post = [self.posts objectAtIndex:indexPath.row];
            cell.post = post;
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (!self.posts || self.posts.count == 0) {
            return self.productTableView.frame.size.height - self.productTableView.tableHeaderView.frame.size.height;
        }
        if (self.posts && self.posts.count != 0) {
            return 50;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isGridView) {
        if (IS_IPAD) {
            return 168;
        }
        return 106;
    }
    
    SPPost *post = [self.posts objectAtIndex:indexPath.row];
    SPProduct *product = post.product;
    float imageRatio = [[product.ratios objectAtIndex:0]floatValue];
    if (imageRatio < 0.7) {
        imageRatio = 0.7;
    }else if (imageRatio > 1){
        imageRatio = 1;
    }
    return 7+300*imageRatio+35+8+1-10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        if (!self.posts || self.posts.count == 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.productTableView.frame.size.width, self.productTableView.frame.size.height - self.productTableView.tableHeaderView.frame.size.height)];
            [self.footerView recenterSubviews];
        }
        if (self.posts && self.posts.count != 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.productTableView.frame.size.width, 50)];
            [self.footerView recenterSubviews];
        }
        
        if (self.isRequestFailed) {
            [self.footerView showReloadButton];
            return self.footerView;
        }
        
        if (!self.isLastPost) {
            [self.footerView showLoading];
            if (!self.isLoading) {
                [self sendGetPostsRequest];
            }
            return self.footerView;
        }else{
            if (self.posts.count == 0) {
                [self.footerView showTitleLabel:@"No picts yet. :("];
            }else{
                [self.footerView showTitleLabel:@"No more picts"];
            }
            return self.footerView;
        }
    }
    return nil;
}

#pragma mark - Request Methods

- (void)sendGetPostsRequest
{
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//    if (IS_IPAD) {
//        return;
//    }
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y > 50 && self.productTableView.contentSize.height > self.navigationController.view.frame.size.height*2) {
//    }else{
//        [self.navigationController setNavigationBarHidden:NO animated:YES] ;
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    if (IS_IPAD) {
//        return;
//    }
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y > 50 && self.productTableView.contentSize.height > self.navigationController.view.frame.size.height*2) {
//        if (velocity.y != 0) {
//            if (velocity.y < 0) {
//                [self.navigationController setNavigationBarHidden:NO animated:YES];
//            }else{
//                [self.navigationController setNavigationBarHidden:YES animated:YES];
//            }
//        }
//    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadAll{
    _reloading = YES;
    self.isRequestFailed = NO;
    self.isLoading = NO;
    self.posts = nil;
    self.nextKey = nil;
    self.isLastPost = NO;
    [self.productTableView reloadData];
	[self sendGetPostsRequest];
}

- (void)reloadTableViewDataSource{
	_reloading = YES;
    self.isRequestFailed = NO;
    [self.productTableView reloadData];
    self.nextKey = nil;
	[self sendGetPostsRequest];
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
    if (self.productTableView && _refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.productTableView];
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

- (IBAction)viewStyleButtonPressed:(id)sender{
    UIButton *rightButton = sender;
    if (self.isGridView) {
        self.isGridView = NO;
        [rightButton setImage:[UIImage imageNamed:@"button_white_grid"] forState:UIControlStateNormal];
    }else{
        self.isGridView = YES;
        [rightButton setImage:[UIImage imageNamed:@"button_white_list"] forState:UIControlStateNormal];
    }
    [self.productTableView reloadData];
    [self.productTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)SPTableViewFooterViewDidSelectReload
{
    if (!self.isLoading) {
        self.isRequestFailed = NO;
        [self.productTableView reloadData];
        [self sendGetPostsRequest];
    }
}

#pragma mark - SBProductListCell Delegate Methods

- (void)SPPostListCellDidWantPost:(SPPost *)post want:(BOOL)want already:(BOOL)already
{
    if (want) {
        [self showHUDViewWithHeart];
    }
    
    if (!already) {
        [self wantPost:post want:want];
    }
}

- (void)SPPostListCellDidSelectPost:(SPPost *)post
{
    [self goToPostViewControllerWithPost:post];
}

#pragma mark - SBProductGridCell Delegate Methods

- (void)SPPostGridCellDidSelectPost:(SPPost *)post
{
    [self goToPostViewControllerWithPost:post];
}

//#pragma mark - Notification-
//
//- (void)productDidAdd:(NSNotification *)notification
//{
//}
//
//- (void)productDidDelete:(NSNotification *)notification
//{
//    NSDictionary *dictionary = [notification userInfo];
//    SPProduct *deletedProduct = [dictionary objectForKey:@"product"];
//    NSMutableArray *includedDeletedProducts = [NSMutableArray array];
//    for (SPPost *post in self.posts) {
//        if ([post.productId isEqualToString:deletedProduct.productId]) {
//            [includedDeletedProducts addObject:product];
//        }
//    }
//    
//    if (includedDeletedProducts.count > 0) {
//        for (SPProduct *product in includedDeletedProducts) {
//            [self.posts removeObject:product];
//        }
//        [self.productTableView reloadData];
//    }
//}
//
//- (void)productDidWant:(NSNotification *)notification
//{
//    NSDictionary *dictionary = [notification userInfo];
//    SPProduct *changedProduct = [dictionary objectForKey:@"product"];
//    NSMutableArray *includedChangedProducts = [NSMutableArray array];
//    for (SPProduct *product in self.posts) {
//        if ([product.productId isEqualToString:changedProduct.productId]) {
//            [includedChangedProducts addObject:product];
//        }
//    }
//    
//    if (includedChangedProducts.count > 0) {
//        for (SPProduct *product in includedChangedProducts) {
//            [self.posts replaceObjectAtIndex:[self.posts indexOfObject:product] withObject:changedProduct];
//        }
//        [self.productTableView reloadData];
//    }
//}
//
//- (void)productDidChange:(NSNotification *)notification
//{
//    NSDictionary *dictionary = [notification userInfo];
//    SPProduct *changedProduct = [dictionary objectForKey:@"product"];
//    NSMutableArray *includedChangedProducts = [NSMutableArray array];
//    for (SPProduct *product in self.posts) {
//        if ([product.productId isEqualToString:changedProduct.productId]) {
//            [includedChangedProducts addObject:product];
//        }
//    }
//    
//    if (includedChangedProducts.count > 0) {
//        for (SPProduct *product in includedChangedProducts) {
//            [self.posts replaceObjectAtIndex:[self.posts indexOfObject:product] withObject:changedProduct];
//        }
//        [self.productTableView reloadData];
//    }
//}
//
//- (void)accountDidChange:(NSNotification *)notification
//{
//    NSDictionary *dictionary = [notification userInfo];
//    SPAccount *changedAccount = [dictionary objectForKey:@"account"];
//    for (SPProduct *product in self.posts) {
//        if (product.account.accountId==changedAccount.accountId) {
//            product.account = changedAccount;
//        }
//        
//    }
//    [self.productTableView reloadData];
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SPPost *post = [self.posts objectAtIndex:actionSheet.tag];
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Repict"]){
        [self showHUDViewWithRepost];
        [self repostPost:post repost:YES];
    }else if ([title isEqualToString:@"Repict With Comment"]){
        [self showRepostViewControllerWithPost:post];
    }else if ([title isEqualToString:@"Undo Repict"]){
        [self repostPost:post repost:NO];
    }
}

- (void)SPPostListCellDidRepostPost:(SPPost *)post repost:(BOOL)repost
{
    NSInteger tag;
    for (SPPost *repost in self.posts) {
        if ([repost.postId isEqualToString:post.postId]) {
            tag = [self.posts indexOfObject:repost];
        }
    }
    
    if (!repost) {
        UIActionSheet *actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Undo Repict"
                                                        otherButtonTitles:nil]
                                      autorelease];
        actionSheet.tag = tag;
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }else{
        [self showRepostViewControllerWithPost:post];
    }
}

-(void)SPRepostRequestDidFinish:(SPGetPostInfoResponseData*)response
{
    
}

- (void)postDidWant:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    [self matchPost:post];
}

- (void)postDidUnwant:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    [self matchPost:post];
}

- (void)matchPost:(SPPost *)post
{   
    NSMutableArray *includedChangedPosts = [NSMutableArray array];
    for (SPPost *originalPost in self.posts) {
        if ([originalPost.postId isEqualToString:post.postId]) {
            [includedChangedPosts addObject:originalPost];
        }
    }
    
    if (includedChangedPosts.count > 0) {
        for (SPPost *toChangePost in includedChangedPosts) {
            [self.posts replaceObjectAtIndex:[self.posts indexOfObject:toChangePost] withObject:post];
        }
    }
    
    [self.productTableView reloadData];
}

- (void)matchRepost:(SPPost *)post isPosted:(BOOL)isPosted
{
    for (SPPost *originalPost in self.posts) {
        if ([originalPost.product.productId isEqualToString:post.product.productId]) {
            originalPost.isReposted = isPosted;
        }
    }
    [self.productTableView reloadData];
}

- (void)postDidRepost:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    [self matchRepost:post isPosted:YES];
}

- (void)postDidUnrepost:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    [self matchRepost:post isPosted:NO];
    if (YES){
        NSMutableArray *includedChangedPosts = [NSMutableArray array];
        for (SPPost *originalPost in self.posts) {
            if ([originalPost.product.productId isEqualToString:post.product.productId]&&originalPost.author.me) {
                [includedChangedPosts addObject:originalPost];
            }
        }
        
        if (includedChangedPosts.count > 0) {
            for (SPPost *toChangePost in includedChangedPosts) {
                [self.posts removeObject:toChangePost];
            }
        }
        [self.productTableView reloadData];
    }
}

- (void)accountDidUpdate:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    for (SPPost *post in self.posts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
}

- (void)accountDidUpdateForPost:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    for (SPPost *post in self.posts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
}


- (void)postDidComment:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    [self matchPost:post];
}

- (void)accountDidFollow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    for (SPPost *post in self.posts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
}

- (void)accountDidUnfollow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    for (SPPost *post in self.posts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
}

- (void)postDidDelete:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    
    NSMutableArray *includedChangedPosts = [NSMutableArray array];
    for (SPPost *originalPost in self.posts) {
        if ([originalPost.postId isEqualToString:post.postId]) {
            [includedChangedPosts addObject:originalPost];
        }
    }
    if (includedChangedPosts.count > 0) {
        for (SPPost *toChangePost in includedChangedPosts) {
            [self.posts removeObject:toChangePost];
        }
    }
    [self.productTableView reloadData];
}



@end
