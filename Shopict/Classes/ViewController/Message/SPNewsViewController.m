//
//  SPNewsViewController.m
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPNewsViewController.h"
#import "NSString+SPStringUtility.h"
#import "SPPost.h"
#import "SPProduct.h"
#import "SPAccount.h"
#import "SPUtility.h"
#import "UIButton+SPButtonUtility.h"
#import "SPTableViewFooterView.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPNewsCell.h"
#import "SPNews.h"
#import "SPGetNewsResponseData.h"

@interface SPNewsViewController ()

@end

@implementation SPNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = [NSString localizedStringWithKey:@"ACTIVITY"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [self.newsTableView reloadData];
    [self.footerView restartLoadingAnimation];
    
    [self reloadAll];
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {        
        [self.newsTableView reloadData];
        [self.footerView restartLoadingAnimation];
        if (!self.news || self.isRequestFailed || [SPUtility shouldReload]) {
            [self reloadAll];
        }
    }
}

- (void)reloadAll
{
    self.news = nil;
    self.nextKey = nil;
    self.isLastPost = NO;
    self.isRequestFailed = NO;
    self.isLoading = NO;
    [self reloadTableViewDataSource];
}


- (void)dealloc {
    [_footerView release];
    [_newsTableView release];
    [_news release];
    [_nextKey release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setNewsTableView:nil];
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
    if (section == 0 && self.news) {
        return [self.news count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.news) {
        static NSString *CellIdentifier = @"SPNewsCell";
        
        SPNewsCell *cell = (SPNewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SPNewsCell" owner:nil options:nil] objectAtIndex:0 ];
            NSLog(@"Product Cell Created");
        }
        cell.delegate = self;
        cell.news = [self.news objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (!self.news || self.news.count == 0) {
            return self.newsTableView.frame.size.height - self.newsTableView.tableHeaderView.frame.size.height;
        }
        if (self.news && self.news.count != 0) {
            return 50;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SPNewsCell";
    SPNewsCell *cell = (SPNewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SPNewsCell" owner:nil options:nil] objectAtIndex:0 ];
    }
    SPNews *news = [self.news objectAtIndex:indexPath.row];
    CGSize maximumCommentLabelSize = CGSizeMake(CGRectGetWidth(cell.descriptionLabel.frame),1000);
    CGSize expectedCommentLabelSize = [news.description sizeWithFont:cell.descriptionLabel.font constrainedToSize:maximumCommentLabelSize lineBreakMode:cell.descriptionLabel.lineBreakMode];
    
    if (CGRectGetMaxY(cell.descriptionLabel.frame) > CGRectGetMaxY(cell.accountImageButton.superview.frame)) {
        return CGRectGetMaxY(cell.accountUsernameButton.frame)+expectedCommentLabelSize.height+5;
    }else{
        return CGRectGetMaxY(cell.accountUsernameButton.frame)+expectedCommentLabelSize.height+5*2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        if (!self.news || self.news.count == 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.newsTableView.frame.size.width, self.newsTableView.frame.size.height - self.newsTableView.tableHeaderView.frame.size.height)];
            [self.footerView recenterSubviews];
        }
        if (self.news && self.news.count != 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.newsTableView.frame.size.width, 50)];
            [self.footerView recenterSubviews];
        }
        
        if (self.isRequestFailed) {
            [self.footerView showReloadButton];
            return self.footerView;
        }
        
        if (!self.isLastPost) {
            [self.footerView showLoading];
            if (!self.isLoading) {
                [self sendGetNewsRequest];
            }
            return self.footerView;
        }else{
            if (self.news.count == 0) {
                [self.footerView showTitleLabel:@"No activity. :("];
            }else{
                [self.footerView showTitleLabel:@"No more activities."];
            }
            return self.footerView;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
    self.isRequestFailed = NO;
    [self.newsTableView reloadData];
    self.nextKey = nil;
	[self sendGetNewsRequest];
}

- (void)SPTableViewFooterViewDidSelectReload
{
    if (!self.isLoading) {
        self.isRequestFailed = NO;
        [self.newsTableView reloadData];
        [self sendGetNewsRequest];
    }
}

- (void)sendGetNewsRequest
{
    [self sendGetNewsRequestWithStartKey:self.nextKey delegate:self];
}

- (void)SPGetNewsRequestDidFinish:(SPGetNewsResponseData*)response startKey:(NSString *)startKey
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
        NSLog(@"Success");
        
        if (!startKey) {
            self.news = nil;
            [self.newsTableView reloadData];
        }
        
        if (self.news) {
            for (SPNews *toAddNews in response.news) {
                BOOL included = NO;
                for (SPNews *news in self.news) {
                    if ([news.newsId isEqualToString:toAddNews.newsId]) {
                        included = YES;
                    }
                }
                if (!included) {
                    [self.news addObject:toAddNews];
                }
                
            }
        }else{
            self.news = response.news;
        }
        
        self.nextKey = response.nextKey;
        
        if (!response.nextKey) {
            self.isLastPost = YES;
        }
    }
    [self.newsTableView reloadData];
    self.isLoading = NO;
}

- (void)SPNewsCellDidSelectAccount:(SPAccount *)account
{
    [self goToProfileViewControllerWithAccount:account];
}
@end
