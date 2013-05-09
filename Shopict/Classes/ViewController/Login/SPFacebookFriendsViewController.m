//
//  SPFacebookFriendsViewController.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPFacebookFriendsViewController.h"
#import "SPSocialManager.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseResponseData.h"
#import "SPFacebookAccount.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SPGetAccountsResponseData.h"
#import "SPTableViewFooterView.h"
#import "NSString+SBJSON.h"
#import "SPAccountCell.h"
#import "SPFacebookAccountCell.h"

@interface SPFacebookFriendsViewController ()

@end

@implementation SPFacebookFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {
        // viewController is visible
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"FACEBOOK";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view from its nib.
    
    //100004567533425?fields=friends&access_token=AAACEdEose0cBAPYjoXF3OZCVy5GuzKAoZBYHkiGHM8zkBW34axOrPnDXEQ62fdqwHPPDmZBKyIoPZAwA7VQlzZBlGPyo5bZCH4u6umt6DWgv8L32stVZClJ

    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.delegate = self;
    
    self.accountTableView.tableHeaderView = self.facebookHeaderView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_accountTableView release];
    [_facebookHeaderView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAccountTableView:nil];
    [self setFacebookHeaderView:nil];
    [super viewDidUnload];
}

- (IBAction)findFacebookFriendsButtonPressed:(id)sender {
    if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
        [self sendFacebookFriendsListRequest];
    }else{
        [self showHUDLoadingViewWithTitle:@"Authorizing"];
        [SPSocialManager sharedManager].delegate = self;
        [[SPSocialManager sharedManager]connectToThirdParty:FACEBOOK];
    }
}

- (void)SPSocialManagerDelegateDidFinishConnectedToThirdParty:(ThirdPartyPath)thirdParty userId:(NSString *)userId errorMessage:(NSString *)errorMessage
{
    if (!errorMessage) {
        if (userId) {
            [self sendBindAccountToThirdPartyRequestWithThirdPartyId:userId path:thirdParty delegate:self];
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
            [self showHUDLoadingViewWithTitle:@"Connecting"];
        }
    }else{
        [self showErrorAlert:errorMessage];
        [self performSelectorOnMainThread:@selector(hideHUDLoadingView) withObject:nil waitUntilDone:YES];
    }
}

- (void)SPBindAccountToThirdPartyRequestDidFinish:(SPBaseResponseData*)response path:(ThirdPartyPath)path
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
        switch (path) {
            case FACEBOOK:
                [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
                break;
            default:
                break;
        }
    }else{
        [self sendFacebookFriendsListRequest];
    }
}

- (void)sendFacebookFriendsListRequest{
    NSURL *friendsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=friends&access_token=%@",[SPSocialManager getConnectedFacebookUserId],[FBSession activeSession].accessTokenData.accessToken]];
    NSError **error = nil;
    NSString *responseString = [NSString stringWithContentsOfURL:friendsUrl encoding:NSUTF8StringEncoding error:error];
    NSLog(@"%@",responseString);
    if (responseString) {
        NSDictionary *friendsData = [responseString JSONValue];
        if (friendsData) {
            NSArray *friendsArray = [[friendsData objectForKey:@"friends"]objectForKey:@"data"];
            if (friendsArray) {
                self.facebookAccounts = [NSMutableArray array];
                NSMutableArray *facebookAccountIds = [NSMutableArray array];
                for (NSDictionary *dictionary in friendsArray) {
                    SPFacebookAccount *account = [SPFacebookAccount facebookAccountWithUserId:[dictionary objectForKey:@"id"] username:[dictionary objectForKey:@"name"]];
                    [self.facebookAccounts addObject:account];
                    [facebookAccountIds addObject:[dictionary objectForKey:@"id"]];
                    NSLog(@"%@",facebookAccountIds);
                }
                [self sendFindFriendsRequestWithPath:FACEBOOK thirdPartyIds:facebookAccountIds delegate:self];
            }
        }
    }
}

- (void)SPFindFriendsRequestDidFinish:(SPGetAccountsResponseData*)response
{
    if (response.error) {
        self.isRequestFailed = NO;
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
        if (response.accounts.count == 0) {
            self.noMatchedAccounts = YES;
        }else{
            self.facebookAccounts = response.accounts;
        }
        [self.facebookHeaderView setFrame:CGRectMake(0, 0, 320, 70)];
        self.accountTableView.tableHeaderView = self.facebookHeaderView;
        [self.accountTableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.facebookAccounts.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.facebookAccounts) {
        if (self.noMatchedAccounts) {
            static NSString *CellIdentifier = @"SPFacebookAccountCell";
            
            SPFacebookAccountCell *cell = (SPFacebookAccountCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SPFacebookAccountCell" owner:nil options:nil] objectAtIndex:0 ];
                NSLog(@"Product Cell Created");
            }
            SPFacebookAccount *account = [self.facebookAccounts objectAtIndex:indexPath.row];
            cell.account = account;
            cell.delegate = self;
            return cell;
        }else{
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
            [cell setAccount:[self.facebookAccounts objectAtIndex:indexPath.row]];
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 76;
    }
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)SPFacebookAccountCellDidInviteAccount:(SPFacebookAccount *)account
{
    // Display the requests dialog
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:account.userId forKey:@"to"];
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:[FBSession activeSession]
     message:@"Discover interesting stuff, collect the things you want'd, join Shopict now!"
     title:nil
     parameters:parameters
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         [self showHUDTickViewWithMessage:@"Request Sent"];
     }];
}



@end
