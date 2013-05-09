//
//  SPProfileViewController.m
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPProfileViewController.h"
#import "UIButton+SPButtonUtility.h"
#import "SPUtility.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "SPAccount.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "SPPostListCell.h"
#import "SPProduct.h"
#import "SPPostGridCell.h"
#import "UIColor+SPColorUtility.h"
#import "SPTableViewFooterView.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPGetPostsResponseData.h"
#import "SPGetAccountInfoResponseData.h"
#import "SPBaseResponseData.h"
#import "SPPost.h"

@interface SPProfileViewController ()

@end

@implementation SPProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.profileTableView.bounds.size.height, self.navigationController.view.frame.size.width, self.profileTableView.bounds.size.height)];
		view.delegate = self;
		[self.profileTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    
    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.backgroundColor = self.view.backgroundColor;
    self.footerView.delegate = self;
    
    [self.editProfileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.editProfileButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.editProfileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.editProfileButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.followButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.followButton setTitle:@"Follow" forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.followButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.followButton setTitle:@"Follow'd" forState:UIControlStateSelected];
    [self.followButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [self.followButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.followButton setTitle:@"Follow'd" forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.followButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    self.websiteButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self.websiteButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    self.profileTableView.tableHeaderView = self.profileHeaderView;
    [self.profileImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.websiteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.wantedButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.wantedButton setImage:[UIImage imageNamed:@"button_grey_heart"] forState:UIControlStateNormal];
    [self.sellingButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.sellingButton setImage:[UIImage imageNamed:@"button_grey_pict"] forState:UIControlStateNormal];
    [self.wantedButton setImage:[UIImage imageNamed:@"button_red_heart"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.sellingButton setImage:[UIImage imageNamed:@"button_red_pict"] forState:UIControlStateSelected | UIControlStateHighlighted];

    self.isGridView = YES;
    
    self.isWanted = NO;
    self.sellingButton.selected = YES;
    
    if (self.isTabMe) {
        //Add setting button
        UIButton *barButton = [UIButton barButtonItemWithImage:[UIImage imageNamed:@"button_white_gear"]];
        [barButton addTarget:self action:@selector(settingMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
        [barButtonItem release];
    }else{
        if (self.account) {
            if (!self.account.me) {
                //Add report button
                UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightBarButton setFrame:CGRectMake(0, 0, 30, 31)];
                [rightBarButton setImage:[UIImage imageNamed:@"button_white_options"] forState:UIControlStateNormal];
                [rightBarButton addTarget:self action:@selector(optionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
                [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
                [rightBarButtonItem release];
            }
        }
    }
    
    [self adjustProfileHeaderView];
    
    if (self.isTabMe) {
        [self sendGetAccountInfoByUserIdRequestWithUserId:nil delegate:self];
    }
    
    if (self.account) {
        [self sendGetProductsByUIdRequestByType:(self.isWanted?WANT:SHARE)];
    }
}

- (void)dealloc {
    [_profileTableView release];
    [_profileHeaderView release];
    [_coverImageView release];
    [_profileImageButton release];
    [_followerCountLabel release];
    [_followingCountLabel release];
    [_profileInformationView release];
    [_userNameLabel release];
    [_messageButton release];
    [_editProfileButton release];
    [_descriptionLabel release];
    [_backgroundTopImageView release];
    [_sectionHeaderView release];
    [_gridViewButton release];
    [_wantedButton release];
    [_sellingButton release];
    [_account release];
    [_wantedProducts release];
    [_sellingProducts release];
    [_wantedNextKey release];
    [_sellingNextKey release];
    [_fullNameLabel release];
    [_followButton release];
    [_websiteButton release];
    [_sectionHeaderSeperator release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setProfileImageButton:nil];
    [self setFollowerCountLabel:nil];
    [self setFollowingCountLabel:nil];
    [self setUserNameLabel:nil];
    [self setProfileInformationView:nil];
    [self setDescriptionLabel:nil];
    [self setMessageButton:nil];
    [self setBackgroundTopImageView:nil];
    [self setGridViewButton:nil];
    [self setEditProfileButton:nil];
    [self setSectionHeaderView:nil];
    [self setWantedButton:nil];
    [self setSellingButton:nil];
    [self setFullNameLabel:nil];
    [self setFollowButton:nil];
    [self setWebsiteButton:nil];
    [self setSectionHeaderSeperator:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [self adjustProfileHeaderView];
    [self.profileTableView reloadData];
    [_refreshHeaderView startLoadingAnimation];
    [self.footerView restartLoadingAnimation];
    
    if (_reloading) {
        [self reloadAll];
        return;
    }
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {
        [self.profileTableView reloadData];
        [_refreshHeaderView startLoadingAnimation];
        [self.footerView restartLoadingAnimation];
        if ([SPUtility shouldReload]) {
            [self reloadAll];
            return;
        }
    }
}

#pragma mark - Button events

- (IBAction)settingMenuButtonPressed:(id)sender
{
    [self goToSettingViewController];
}

- (IBAction)optionsButtonPressed:(id)sender
{
    UIActionSheet *actionSheet;
    actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:@"Report User"
                                     otherButtonTitles:nil]
                   autorelease];
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

- (IBAction)followerButtonPressed:(id)sender {
    if (self.account) {
        if (self.account.fansCount != 0) {
            [self goToSubscriptionFeedViewControllerWithAccount:self.account type:FOLLOWED];
        }
    }
}

- (IBAction)followingButtonPressed:(id)sender {
    if (self.account) {
        if (self.account.followCount != 0) {
            [self goToSubscriptionFeedViewControllerWithAccount:self.account type:FOLLOWING];
        }
    }
}

- (IBAction)websiteButtonPressed:(id)sender {
    if (self.account.website) {
        [self goToAddPostFromURLBrowserViewControllerWithUrl:self.account.website];
    }
}

- (IBAction)storeButtonPressed:(id)sender {
}

- (IBAction)textButtonPressed:(id)sender {
    if (self.account) {
        if (!self.account.me) {
//            SBMessengerViewController *viewController = [[SBMessengerViewController alloc]initWithNibName:@"SBMessengerViewController" bundle:nil];
//            viewController.account = self.account;
//            [self.navigationController pushViewController:viewController animated:YES];
//            [viewController release];
        }else{
            [self showErrorAlert:@"You cannot send message to yourself"];
        }
    }
}

- (IBAction)editProfileButtonPressed:(id)sender {
    //if (self.account && self.account.me) {
        [self goToEditProfileViewControllerWithAccount:self.account];
    //}
}

- (IBAction)followButtonPressed:(id)sender {
    if (self.followButton.selected) {
        [self subscribeAccount:self.account follow:NO];
    }else{
        [self subscribeAccount:self.account follow:YES];
    }
}


- (IBAction)viewStyleButtonPressed:(id)sender {
    UIButton *rightButton = sender;
    if (self.isGridView) {
        self.isGridView = NO;
        [rightButton setImage:[UIImage imageNamed:@"button_red_grid"] forState:UIControlStateNormal];
    }else{
        self.isGridView = YES;
        [rightButton setImage:[UIImage imageNamed:@"button_red_list"] forState:UIControlStateNormal];
    }
    [self.profileTableView reloadData];
}

- (IBAction)wantedButtonPressed:(id)sender
{
    if (self.account) {
    }
    if ([sender isEqual:self.wantedButton]) {
        self.isWanted = YES;
        self.wantedButton.selected = YES;
        self.sellingButton.selected = NO;
    }else{
        self.isWanted = NO;
        self.wantedButton.selected = NO;
        self.sellingButton.selected = YES;
    }
    
    [self.profileTableView reloadData];
    if (self.account) {
        if ((self.isWanted && !self.wantedProducts)||(!self.isWanted && !self.sellingProducts)) {
            [self sendGetProductsByUIdRequestByType:(self.isWanted?WANT:SHARE)];
        }
    }
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.isGridView) {
            NSInteger postNumber = (IS_IPAD?4:3);
            if (self.isWanted) {
                NSInteger wholeRow = [self.wantedProducts count]/postNumber;
                if( [self.wantedProducts count]%postNumber == 0 )
                    return wholeRow;
                else {
                    return wholeRow + 1;
                }
            }else{
                NSInteger wholeRow = [self.sellingProducts count]/postNumber;
                if( [self.sellingProducts count]%postNumber == 0 )
                    return wholeRow;
                else {
                    return wholeRow + 1;
                }
            }
        }else
        {
            if (self.isWanted){
                return [self.wantedProducts count];
            }else{
                return [self.sellingProducts count];
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
                if (self.isWanted) {
                    if( cellNumber <= [self.wantedProducts count]-1 )
                    {
                        SPPost *product = [self.wantedProducts objectAtIndex:cellNumber];
                        [mutableArray addObject:product];
                    }
                    cellNumber ++;
                }else{
                    if( cellNumber <= [self.sellingProducts count]-1 )
                    {
                        SPPost *product = [self.sellingProducts objectAtIndex:cellNumber];
                        [mutableArray addObject:product];
                    }
                    cellNumber ++;
                }
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
            if (self.isWanted) {
                SPPost *post = [self.wantedProducts objectAtIndex:indexPath.row];
                cell.post = post;
            }else{
                SPPost *post = [self.sellingProducts objectAtIndex:indexPath.row];
                cell.post = post;
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.isWanted) {
            if (!self.wantedProducts || self.wantedProducts.count == 0) {
                return self.profileTableView.frame.size.height - self.profileHeaderView.frame.size.height - self.sectionHeaderView.frame.size.height;
            }
            if (self.wantedProducts && self.wantedProducts.count != 0) {
                return 50;
            }
        }else{
            if (!self.sellingProducts || self.sellingProducts.count == 0) {
                return self.profileTableView.frame.size.height - self.profileTableView.tableHeaderView.frame.size.height;
            }
            if (self.sellingProducts && self.sellingProducts.count != 0) {
                return 50;
            }
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
    
    SPPost *post = nil;
    if (self.isWanted) {
        post = [self.wantedProducts objectAtIndex:indexPath.row];
    }else{
        post = [self.sellingProducts objectAtIndex:indexPath.row];
    }
    
    SPProduct *product = post.product;
    float imageRatio = [[product.ratios objectAtIndex:0]floatValue];
    if (imageRatio < 0.7) {
        imageRatio = 0.7;
    }else if (imageRatio > 1){
        imageRatio = 1;
    }
    return 7+300*imageRatio+35+8+1-5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.sectionHeaderView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 43;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        if (self.isWanted) {
            if (!self.wantedProducts || self.wantedProducts.count == 0) {
                [self.footerView setFrame:CGRectMake(0, 0, self.profileTableView.frame.size.width, self.profileTableView.frame.size.height - self.profileHeaderView.frame.size.height - self.sectionHeaderView.frame.size.height)];
                [self.footerView recenterSubviews];
            }
            if (self.wantedProducts && self.wantedProducts.count != 0) {
                [self.footerView setFrame:CGRectMake(0, 0, self.profileTableView.frame.size.width, 50)];
                [self.footerView recenterSubviews];
            }
            
            if (self.isRequestFailed) {
                [self.footerView showReloadButton];
                return self.footerView;
            }
            
            if (!self.wantedLastProduct) {
                [self.footerView showLoading];
                if (!self.isLoading) {
                    if (self.account) {
                        [self sendGetProductsByUIdRequestByType:(self.isWanted?WANT:SHARE)];
                    }
                }
                return self.footerView;
            }else{
                if (self.wantedProducts.count == 0) {
                    [self.footerView showTitleLabel:@"No want'd picts yet. :("];
                }else{
                    [self.footerView showTitleLabel:@"No more picts."];
                }
                return self.footerView;
            }
        }else{
            if (!self.sellingProducts || self.sellingProducts.count == 0) {
                [self.footerView setFrame:CGRectMake(0, 0, self.profileTableView.frame.size.width, self.profileTableView.frame.size.height - self.profileHeaderView.frame.size.height - self.sectionHeaderView.frame.size.height)];
                [self.footerView recenterSubviews];
            }
            if (self.sellingProducts && self.sellingProducts.count != 0) {
                [self.footerView setFrame:CGRectMake(0, 0, self.profileTableView.frame.size.width, 50)];
                [self.footerView recenterSubviews];
            }
            
            if (self.isRequestFailed) {
                [self.footerView showReloadButton];
                return self.footerView;
            }
            
            if (!self.sellingLastProduct) {
                [self.footerView showLoading];
                if (!self.isLoading) {
                    if (self.account) {
                        [self sendGetProductsByUIdRequestByType:(self.isWanted?WANT:SHARE)];
                    }
                }
                return self.footerView;
            }else{
                if (self.sellingProducts.count == 0) {
                    if (self.account.me) {
                        [self.footerView showTitleLabel:@"Pict something now. :)"];
                    }else{
                        [self.footerView showTitleLabel:@"No picts yet."];
                    }
                }else{
                    [self.footerView showTitleLabel:@"No more picts"];
                }
                return self.footerView;
            }
        }

    }
    return nil;
}

- (void)SPTableViewFooterViewDidSelectReload
{
    self.isRequestFailed = NO;
    [self.profileTableView reloadData];
    [self reloadTableViewDataSource];
}

#pragma mark - Scroll view methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    CGPoint offset = scrollView.contentOffset;
    CGRect frame = self.coverImageView.frame;
    CGFloat factor;
    if (offset.y < 0) {
        factor = 0.5;
    } else {
        factor = 1;
    }
    if (IS_IPAD) {
        frame.origin.y = -171-offset.y*factor;
    }else{
        frame.origin.y = -80-offset.y*factor;
    }
    self.coverImageView.frame = frame;
    
//    if (offset.y > 50 && self.profileTableView.contentSize.height > self.navigationController.view.frame.size.height*2) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }else{
//        [self.navigationController setNavigationBarHidden:NO animated:YES] ;
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark - Request methods

- (void)sendSubscribeAccountRequestWithFollow:(BOOL)follow
{
    [self sendSubscribeAccountRequestWithAccount:self.account subscribe:follow delegate:self];
}

- (void)sendGetProductsByUIdRequestByType:(PostType)type
{
    self.isLoading = YES;
    self.isRequestFailed = NO;
    
    [self sendGetPostsByUserIdRequestWithUserId:self.account.accountId type:type startKey:(self.isWanted?self.wantedNextKey:self.sellingNextKey) delegate:self];
}

- (void)SPGetPostsByUserIdRequestDidFinish:(SPGetPostsResponseData*)response type:(PostType)type startKey:(NSString *)startKey
{
    if (_reloading) {
        self.wantedLastProduct = NO;
        self.sellingLastProduct = NO;
        self.wantedProducts = nil;
        self.sellingProducts = nil;
        [self.profileTableView reloadData];
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
        NSLog(@"Success");
        
        NSLog(@"%@",response.responseString);
        
        if (type == WANT) {
            if (!startKey) {
                self.wantedProducts = nil;
                [self.profileTableView reloadData];
            }
            if (self.wantedProducts) {
                for (SPPost *toAddPost in response.posts) {
                    BOOL included = NO;
                    for (SPPost *post in self.wantedProducts) {
                        if ([post.postId isEqualToString:toAddPost.postId]) {
                            included = YES;
                        }
                    }
                    if (!included) {
                        [self.wantedProducts addObject:toAddPost];
                    }
                }
            }else{
                self.wantedProducts = response.posts;
            }
            self.wantedNextKey = response.nextKey;
            if (!response.nextKey) {
                self.wantedLastProduct = YES;
            }
        }else{
            if (!startKey) {
                self.sellingProducts = nil;
                [self.profileTableView reloadData];
            }
            if (self.sellingProducts) {
                for (SPPost *toAddPost in response.posts) {
                    BOOL included = NO;
                    for (SPPost *post in self.wantedProducts) {
                        if ([post.postId isEqualToString:toAddPost.postId]) {
                            included = YES;
                        }
                    }
                    if (!included) {
                        [self.sellingProducts addObject:toAddPost];
                    }
                }
            }else{
                self.sellingProducts = response.posts;
            }
            self.sellingNextKey = response.nextKey;
            if (!response.nextKey) {
                self.sellingLastProduct = YES;
            }
        }
    }
    [self.profileTableView reloadData];
    self.isLoading = NO;
}

- (void)sendAccountInfoRequest
{
    if (self.isTabMe) {
        [self sendGetAccountInfoByUserIdRequestWithUserId:nil delegate:self];
    }else{
        [self sendGetAccountInfoByUserIdRequestWithUserId:self.account.accountId delegate:self];
    }
}

- (void)SPGetAccountInfoByUserIdRequestDidFinish:(SPGetAccountInfoResponseData*)response
{
    
    if (!self.account && _reloading) {
        self.wantedNextKey = nil;
        self.sellingNextKey = nil;
        self.wantedProducts = nil;
        self.sellingProducts = nil;
        self.wantedLastProduct = NO;
        self.sellingLastProduct = NO;
        [self.profileTableView reloadData];
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
        NSLog(@"Success");
        
        if (self.isTabMe && !self.account) {
            self.account = response.account;
            [self adjustProfileHeaderView];
            [self sendGetProductsByUIdRequestByType:(self.isWanted?WANT:SHARE)];
        }
        
        self.account = response.account;
        [self adjustProfileHeaderView];
    }
    [self.profileTableView reloadData];
}

- (void)sendReportUserRequest
{
    [self showHUDLoadingViewWithTitle:@"Reporting"];
    [self sendReportProfileRequestWithReportUId:self.account.accountId delegate:self];
}

- (void)SPReportProfileRequestDidFinish:(SPBaseResponseData*)response
{
    [self hideHUDLoadingView];
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
        NSLog(@"Success");
        [self showHUDTickViewWithMessage:@"Report'd. Thanks!"];
    }
}

#pragma mark - SBEditProfileViewController delegate

- (void)SBEditProfileViewControllerDelegateDidUpdateProfile
{
    [self reloadTableViewDataSource];
}

#pragma mark - SBAddProductViewController delegate

//- (void)SBAddProductViewControllerDidUploadNewProduct:(ProductType)productType
//{
//    if (productType == WANT) {
//        self.isWanted = YES;
//        self.wantedButton.selected = YES;
//        self.sellingButton.selected = NO;
//    }else{
//        self.isWanted = NO;
//        self.wantedButton.selected = NO;
//        self.sellingButton.selected = YES;
//    }
//}

#pragma mark - SBProductGridCell Delegate Methods

- (void)SPPostGridCellDidSelectPost:(SPPost *)post
{
    [self goToPostViewControllerWithPost:post];
}

#pragma mark - Customized methods

- (void)adjustProfileHeaderView
{
    if (self.isTabMe) {
        self.followButton.hidden = YES;
        self.messageButton.hidden = YES;
        if (self.account) {
            self.editProfileButton.hidden = NO;
        }else{
            self.editProfileButton.hidden = YES;
        }
    }else{
        
        if (self.account) {
            self.followButton.hidden = NO;
            self.messageButton.hidden = NO;
            self.editProfileButton.hidden = YES;
            
            if (self.account.me) {
                self.followButton.hidden = YES;
                self.messageButton.hidden = YES;
                self.editProfileButton.hidden = NO;
            }else{
                self.followButton.hidden = NO;
                self.messageButton.hidden = NO;
                self.editProfileButton.hidden = YES;
            }
            
        }else{
            self.followButton.hidden = YES;
            self.messageButton.hidden = YES;
            self.editProfileButton.hidden = YES;
            self.backgroundTopImageView.hidden = YES;
        }
        
    }
    
    if (self.account) {
        
        self.navigationItem.title = [self.account.username uppercaseString];
        
        [self.profileImageButton setImageWithURL:[NSURL URLWithString:self.account.profileImgURL] forState:UIControlStateNormal];
        [self.coverImageView setImageWithURL:[NSURL URLWithString:self.account.coverImgURL]];
        
        [self.followerCountLabel setText:[NSString stringWithFormat:@"%d",self.account.fansCount]];
        [self.followingCountLabel setText:[NSString stringWithFormat:@"%d",self.account.followCount]];
        [self.userNameLabel setText:[NSString stringWithFormat:@"@%@",self.account.username]];
        [self.fullNameLabel setText:self.account.name];
        [self.descriptionLabel setText:self.account.description];
        [self.websiteButton setTitle:self.account.website forState:UIControlStateNormal];
        
        self.followButton.selected = self.account.subscribed;
    }
    
    CGSize maximumFullNameLabelSize = CGSizeMake(CGRectGetWidth(self.fullNameLabel.frame),40);
    CGSize expectedFullNameLabelSize = [self.fullNameLabel.text sizeWithFont:self.fullNameLabel.font constrainedToSize:maximumFullNameLabelSize lineBreakMode:self.fullNameLabel.lineBreakMode];
    [self.fullNameLabel setFrame:CGRectMake(self.fullNameLabel.frame.origin.x, self.fullNameLabel.frame.origin.y, CGRectGetWidth(self.fullNameLabel.frame), (expectedFullNameLabelSize.height<20?20:40))];
    
    CGSize maximumUsernameLabelSize = CGSizeMake(CGRectGetWidth(self.userNameLabel.frame),40);
    CGSize expectedUsernameLabelSize = [self.userNameLabel.text sizeWithFont:self.userNameLabel.font constrainedToSize:maximumUsernameLabelSize lineBreakMode:self.userNameLabel.lineBreakMode];
    [self.userNameLabel setFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.fullNameLabel.frame), CGRectGetWidth(self.userNameLabel.frame), (expectedUsernameLabelSize.height<20?20:40))];
    
    if (self.account.description || self.account.website) {
        self.backgroundTopImageView.hidden = NO;
        [self.backgroundTopImageView setFrame:CGRectMake(self.backgroundTopImageView.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+5, CGRectGetWidth(self.backgroundTopImageView.frame), CGRectGetHeight(self.backgroundTopImageView.frame))];
        
        CGSize maximumDescriptionLabelSize = CGSizeMake(CGRectGetWidth(self.descriptionLabel.frame),1000);
        CGSize expectedDescriptionLabelSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:maximumDescriptionLabelSize lineBreakMode:self.descriptionLabel.lineBreakMode];
        [self.descriptionLabel setFrame:CGRectMake(self.descriptionLabel.frame.origin.x, CGRectGetMinY(self.backgroundTopImageView.frame)+10, CGRectGetWidth(self.descriptionLabel.frame), expectedDescriptionLabelSize.height)];
        
        CGSize maximumWebsiteLabelSize = CGSizeMake(CGRectGetWidth(self.websiteButton.frame),40);
        CGSize expectedWebsiteLabelSize = [self.self.websiteButton.titleLabel.text sizeWithFont:self.self.websiteButton.titleLabel.font constrainedToSize:maximumWebsiteLabelSize lineBreakMode:self.self.websiteButton.titleLabel.lineBreakMode];
        if (self.account.description) {
            [self.websiteButton setFrame:CGRectMake(self.websiteButton.frame.origin.x, CGRectGetMaxY(self.descriptionLabel.frame), CGRectGetWidth(self.descriptionLabel.frame), expectedWebsiteLabelSize.height)];
        }else{
            [self.websiteButton setFrame:CGRectMake(self.websiteButton.frame.origin.x, CGRectGetMinY(self.descriptionLabel.frame), CGRectGetWidth(self.descriptionLabel.frame), expectedWebsiteLabelSize.height)];
        }
        
        if (self.account.website) {
            [self.profileInformationView setFrame:CGRectMake(self.profileInformationView.frame.origin.x, self.profileInformationView.frame.origin.y, self.profileInformationView.frame.size.width, CGRectGetMaxY(self.websiteButton.frame)+10)];
        }else{
            [self.profileInformationView setFrame:CGRectMake(self.profileInformationView.frame.origin.x, self.profileInformationView.frame.origin.y, self.profileInformationView.frame.size.width, CGRectGetMinY(self.websiteButton.frame)+10)];
        }
        
        [self.profileHeaderView setFrame:CGRectMake(self.profileHeaderView.frame.origin.x, self.profileHeaderView.frame.origin.y, self.profileHeaderView.frame.size.width, CGRectGetMaxY(self.profileInformationView.frame))];
        
    }else{
        self.backgroundTopImageView.hidden = YES;
        
        [self.profileInformationView setFrame:CGRectMake(self.profileInformationView.frame.origin.x, self.profileInformationView.frame.origin.y, self.profileInformationView.frame.size.width, CGRectGetMaxY(self.userNameLabel.frame)+5)];
        
        [self.profileHeaderView setFrame:CGRectMake(self.profileHeaderView.frame.origin.x, self.profileHeaderView.frame.origin.y, self.profileHeaderView.frame.size.width, CGRectGetMaxY(self.profileInformationView.frame))];
    }
    
    self.profileTableView.tableHeaderView = self.profileHeaderView;
    
    if (self.account) {
        [self.wantedButton setTitle:[NSString stringWithFormat:@"%d Want'd",self.account.wantCount] forState:UIControlStateNormal];
        [self.sellingButton setTitle:[NSString stringWithFormat:@"%d %@",self.account.postCount,(self.account.postCount>1?@"Picts":@"Pict")] forState:UIControlStateNormal];
        self.sectionHeaderSeperator.hidden = NO;
        self.wantedButton.hidden = NO;
        self.sellingButton.hidden = NO;
    }
    
}

#pragma mark - Actionsheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Report User"]){
        [self sendReportUserRequest];
    }else if ([title isEqualToString:@"Repict"]){
        SPPost *post = [self.wantedProducts objectAtIndex:actionSheet.tag];
        [self showHUDViewWithRepost];
        [self repostPost:post repost:YES];
    }else if ([title isEqualToString:@"Repict With Comment"]){
        SPPost *post = [self.wantedProducts objectAtIndex:actionSheet.tag];
        [self showRepostViewControllerWithPost:post];
    }else if ([title isEqualToString:@"Undo Repict"]){
        SPPost *post = [self.wantedProducts objectAtIndex:actionSheet.tag];
        [self repostPost:post repost:NO];\
    }

}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    self.sellingNextKey = nil;
    self.wantedNextKey = nil;
    [self sendAccountInfoRequest];
    if (self.account) {
        [self sendGetProductsByUIdRequestByType:(self.isWanted?WANT:SHARE)];
    }
}

- (void)doneLoadingTableViewData{

    _reloading = NO;
    if (_refreshHeaderView && self.profileTableView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.profileTableView];
    }
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

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

//- (void)productDidAdd:(NSNotification *)notification
//{
//    if (self.account.me) {
//        _reloading = YES;
//    }
//}
//
//- (void)productDidWant:(NSNotification *)notification
//{
//    if (self.account.me) {
//        _reloading = YES;
//    }
//    NSDictionary *dictionary = [notification userInfo];
//    SPProduct *changedProduct = [dictionary objectForKey:@"product"];
//    if (self.account.me) {
//        if (changedProduct.isWanted) {
//            self.account.wantCount++;
//        }else{
//            self.account.wantCount--;
//        }
//        [self adjustProfileHeaderView];
//    }
//    
//    if (self.sellingProducts) {
//        NSMutableArray *includedChangedProducts = [NSMutableArray array];
//        for (SPProduct *product in self.sellingProducts) {
//            if ([product.productId isEqualToString:changedProduct.productId]) {
//                [includedChangedProducts addObject:product];
//            }
//        }
//        
//        if (includedChangedProducts.count > 0) {
//            for (SPProduct *product in includedChangedProducts) {
//                [self.sellingProducts replaceObjectAtIndex:[self.sellingProducts indexOfObject:product] withObject:changedProduct];
//            }
//            [self.profileTableView reloadData];
//        }
//    }
//    if (self.wantedProducts) {
//        NSMutableArray *includedChangedProducts = [NSMutableArray array];
//        for (SPProduct *product in self.wantedProducts) {
//            if ([product.productId isEqualToString:changedProduct.productId]) {
//                [includedChangedProducts addObject:product];
//            }
//        }
//        
//        if (includedChangedProducts.count > 0) {
//            for (SPProduct *product in includedChangedProducts) {
//                    [self.wantedProducts replaceObjectAtIndex:[self.wantedProducts indexOfObject:product] withObject:changedProduct];
//            }
//            [self.profileTableView reloadData];
//        }
//    }
//}
//
//- (void)productDidChange:(NSNotification *)notification
//{
//    NSDictionary *dictionary = [notification userInfo];
//    SPProduct *changedProduct = [dictionary objectForKey:@"product"];
//    
//    if (self.sellingProducts) {
//        NSMutableArray *includedChangedProducts = [NSMutableArray array];
//        for (SPProduct *product in self.sellingProducts) {
//            if ([product.productId isEqualToString:changedProduct.productId]) {
//                [includedChangedProducts addObject:product];
//            }
//        }
//        
//        if (includedChangedProducts.count > 0) {
//            for (SPProduct *product in includedChangedProducts) {
//                [self.sellingProducts replaceObjectAtIndex:[self.sellingProducts indexOfObject:product] withObject:changedProduct];
//            }
//            [self.profileTableView reloadData];
//        }
//    }
//    
//    if (self.wantedProducts) {
//        NSMutableArray *includedChangedProducts = [NSMutableArray array];
//        for (SPProduct *product in self.wantedProducts) {
//            if ([product.productId isEqualToString:changedProduct.productId]) {
//                [includedChangedProducts addObject:product];
//            }
//        }
//        
//        if (includedChangedProducts.count > 0) {
//            for (SPProduct *product in includedChangedProducts) {
//                [self.wantedProducts replaceObjectAtIndex:[self.wantedProducts indexOfObject:product] withObject:changedProduct];
//            }
//            [self.profileTableView reloadData];
//        }
//    }
//}
//
//- (void)productDidDelete:(NSNotification *)notification
//{
//    if (self.account.me) {
//        _reloading = YES;
//    }
//    
//    NSDictionary *dictionary = [notification userInfo];
//    SPProduct *deletedProduct = [dictionary objectForKey:@"product"];
//    
//    if (self.sellingProducts) {
//        NSMutableArray *includedDeletedProducts = [NSMutableArray array];
//        for (SPProduct *product in self.sellingProducts) {
//            if ([product.productId isEqualToString:deletedProduct.productId]) {
//                [includedDeletedProducts addObject:product];
//            }
//        }
//        if (includedDeletedProducts.count > 0) {
//            for (SPProduct *product in includedDeletedProducts) {
//                [self.sellingProducts removeObject:product];
//                if (self.account.sellingCount-1>=0) {
//                    self.account.sellingCount--;
//                }
//                [self adjustProfileHeaderView];
//            }
//            [self.profileTableView reloadData];
//        }
//    }
//    if (self.wantedProducts) {
//        NSMutableArray *includedDeletedProducts = [NSMutableArray array];
//        for (SPProduct *product in self.wantedProducts) {
//            if ([product.productId isEqualToString:deletedProduct.productId]) {
//                [includedDeletedProducts addObject:product];
//            }
//        }
//        
//        if (includedDeletedProducts.count > 0) {
//            for (SPProduct *product in includedDeletedProducts) {
//                [self.wantedProducts removeObject:product];
//                if (self.account.wantCount-1>=0) {
//                    self.account.wantCount--;
//                }
//                [self adjustProfileHeaderView];
//            }
//            [self.profileTableView reloadData];
//        }
//    }
//    
//}
//
//- (void)accountDidChange:(NSNotification *)notification
//{
//    NSDictionary *dictionary = [notification userInfo];
//    SPAccount *changedAccount = [dictionary objectForKey:@"account"];
//    
//    if (changedAccount.accountId == self.account.accountId) {
//        _reloading = YES;
//        return;
//    }
//    
//    for (SPProduct *product in self.wantedProducts) {
//        if (product.account.accountId==changedAccount.accountId) {
//            product.account = changedAccount;
//        }
//        
//    }
//    for (SPProduct *product in self.sellingProducts) {
//        if (product.account.accountId==changedAccount.accountId) {
//            product.account = changedAccount;
//        }
//    }
//    
//    if (self.account.accountId == changedAccount.accountId) {
//        self.account = changedAccount;
//        [self adjustProfileHeaderView];
//    }
//    
//    if (self.account.me) {
//        if (changedAccount.subscribed) {
//            self.account.followCount++;
//        }else{
//            self.account.followCount--;
//        }
//        [self adjustProfileHeaderView];
//    }
//    
//    [self.profileTableView reloadData];
//}

- (void)postDidAdd:(NSNotification *)notification
{
    if ([self isShown]) {
        if (!self.isWanted) {
            [self reloadAll];
        }else{
            self.sellingProducts = nil;
            self.sellingNextKey = nil;
            self.sellingLastProduct = NO;
            [self.profileTableView reloadData];
        }
    }else{
        _reloading = YES;
    }
}

- (void)reloadAll
{
    self.wantedLastProduct = NO;
    self.sellingLastProduct = NO;
    self.wantedProducts = nil;
    self.sellingProducts = nil;
    self.sellingNextKey = nil;
    self.wantedNextKey = nil;
    self.isLoading = NO;
    [self.profileTableView reloadData];
    [self reloadTableViewDataSource];
}

- (void)postDidWant:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    
    if (self.account.me) {
        self.account.wantCount++;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
        [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
        [self adjustProfileHeaderView];
        [self matchPost:post wantType:NO];
        
        self.wantedProducts = nil;
        self.wantedNextKey = nil;
        self.wantedLastProduct = NO;
        
        [self.profileTableView reloadData];
        
    }else{
        [self matchPost:post wantType:NO];
        [self matchPost:post wantType:YES];
        [self.profileTableView reloadData];
    }
}

- (void)postDidUnwant:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    
    if (self.account.me) {
        
        self.account.wantCount--;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
        [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
        [self adjustProfileHeaderView];
        [self matchPost:post wantType:NO];
        NSMutableArray *includedUnwantedProducts = [NSMutableArray array];
        for (SPPost *originalPost in self.wantedProducts) {
            if ([originalPost.postId isEqualToString:post.postId]) {
                [includedUnwantedProducts addObject:originalPost];
            }
        }
        if (includedUnwantedProducts.count > 0) {
            for (SPPost *toUnwantPost in includedUnwantedProducts) {
                [self.wantedProducts removeObject:toUnwantPost];
            }
        }
        
        [self.profileTableView reloadData];

    }else{
        [self matchPost:post wantType:NO];
        [self matchPost:post wantType:YES];
        [self.profileTableView reloadData];
    }
}

- (void)matchPost:(SPPost *)post wantType:(BOOL)wantType
{
    if (wantType) {
        NSMutableArray *includedChangedPosts = [NSMutableArray array];
        for (SPPost *originalPost in self.wantedProducts) {
            if ([originalPost.postId isEqualToString:post.postId]) {
                [includedChangedPosts addObject:originalPost];
            }
        }
        
        if (includedChangedPosts.count > 0) {
            for (SPPost *toChangePost in includedChangedPosts) {
                [self.wantedProducts replaceObjectAtIndex:[self.wantedProducts indexOfObject:toChangePost] withObject:post];
            }
        }
        
        [self.profileTableView reloadData];
    }else{
        NSMutableArray *includedChangedPosts = [NSMutableArray array];
        for (SPPost *originalPost in self.sellingProducts) {
            if ([originalPost.postId isEqualToString:post.postId]) {
                [includedChangedPosts addObject:originalPost];
            }
        }
        
        if (includedChangedPosts.count > 0) {
            for (SPPost *toChangePost in includedChangedPosts) {
                [self.sellingProducts replaceObjectAtIndex:[self.sellingProducts indexOfObject:toChangePost] withObject:post];
            }
        }
        [self.profileTableView reloadData];
    }
}


- (void)matchRepost:(SPPost *)post isPosted:(BOOL)isPosted wantType:(BOOL)wantType
{
    if (wantType) {
        for (SPPost *originalPost in self.wantedProducts) {
            if ([originalPost.product.productId isEqualToString:post.product.productId]) {
                originalPost.isReposted = isPosted;
            }
        }
    }else{
        for (SPPost *originalPost in self.sellingProducts) {
            if ([originalPost.product.productId isEqualToString:post.product.productId]) {
                originalPost.isReposted = isPosted;
            }
        }
    }
    [self.profileTableView reloadData];
}

- (void)postDidRepost:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    if (self.account.me) {
         self.account.postCount++;
        [self adjustProfileHeaderView];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
        [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
        self.sellingProducts = nil;
        self.sellingNextKey = nil;
        self.sellingLastProduct = NO;
        if ([self isShown]) {
            [self matchRepost:post isPosted:YES wantType:YES];
        }
    }else{
        [self matchRepost:post isPosted:YES wantType:YES];
        [self matchRepost:post isPosted:YES wantType:NO];
    }
    [self.profileTableView reloadData];
}

- (void)postDidUnrepost:(NSNotification *)notification
{
    if (self.account) {
        if (self.account.me) {
            self.account.postCount--;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
            [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
        }
    }
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    [self matchRepost:post isPosted:NO wantType:YES];
    [self matchRepost:post isPosted:NO wantType:NO];
    [self.profileTableView reloadData];
    
    if (YES){
        NSMutableArray *includedChangedPosts = [NSMutableArray array];
        for (SPPost *originalPost in self.sellingProducts) {
            if ([originalPost.product.productId isEqualToString:post.product.productId]) {
                [includedChangedPosts addObject:originalPost];
            }
        }
        if (includedChangedPosts.count > 0) {
            for (SPPost *toChangePost in includedChangedPosts) {
                [self.sellingProducts removeObject:toChangePost];
            }
            self.account.wantCount -= includedChangedPosts.count;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
            [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
            
        }
        [self.profileTableView reloadData];
    }
}


- (void)SPPostListCellDidRepostPost:(SPPost *)post repost:(BOOL)repost
{
    NSInteger tag;
    for (SPPost *repost in self.wantedProducts) {
        if ([repost.postId isEqualToString:post.postId]) {
            tag = [self.wantedProducts indexOfObject:repost];
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

- (void)accountDidUpdate:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    if (self.account.me) {
        self.account = account;
        [self adjustProfileHeaderView];
    }
    for (SPPost *post in self.wantedProducts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
    for (SPPost *post in self.sellingProducts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
    [self adjustProfileHeaderView];
    [self.profileTableView reloadData];
}

- (void)postDidComment:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    [self matchPost:post wantType:YES];
    [self matchPost:post wantType:NO];
}

- (void)accountDidFollow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    if (self.account) {
        if (self.account.me) {
            self.account.followCount++;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
            [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
        }
    }
    for (SPPost *post in self.wantedProducts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
    for (SPPost *post in self.sellingProducts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
    [self adjustProfileHeaderView];
    [self.profileTableView reloadData];
}

- (void)accountDidUnfollow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    if (self.account) {
        if (self.account.me) {
            self.account.followCount--;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
            [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
        }
    }
    for (SPPost *post in self.wantedProducts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
    for (SPPost *post in self.sellingProducts) {
        if ([post.author.accountId isEqualToString:account.accountId]) {
            post.author = account;
        }
        if ([post.product.account.accountId isEqualToString:account.accountId]) {
            post.product.account = account;
        }
    }
    [self adjustProfileHeaderView];
    [self.profileTableView reloadData];
}

- (void)postDidDelete:(NSNotification *)notification
{
    if (self.account) {
        if (self.account.me) {
            self.account.postCount--;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
            [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
        }
    }
    
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    
    if (YES) {
        NSMutableArray *includedChangedPosts = [NSMutableArray array];
        for (SPPost *originalPost in self.wantedProducts) {
            if ([originalPost.postId isEqualToString:post.postId]) {
                [includedChangedPosts addObject:originalPost];
            }
        }
        
        if (includedChangedPosts.count > 0) {
            for (SPPost *toChangePost in includedChangedPosts) {
                [self.wantedProducts removeObject:toChangePost];
            }
            
            self.account.wantCount -= includedChangedPosts.count;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.account forKey:@"account"];
            [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATEFORPOST dictionary:userInfo];
            
        }
        
        [self.profileTableView reloadData];
    }
    if (YES){
        NSMutableArray *includedChangedPosts = [NSMutableArray array];
        for (SPPost *originalPost in self.sellingProducts) {
            if ([originalPost.postId isEqualToString:post.postId]) {
                [includedChangedPosts addObject:originalPost];
            }
        }
        
        if (includedChangedPosts.count > 0) {
            for (SPPost *toChangePost in includedChangedPosts) {
                [self.sellingProducts removeObject:toChangePost];
            }
        }
        [self.profileTableView reloadData];
    }
}



@end
