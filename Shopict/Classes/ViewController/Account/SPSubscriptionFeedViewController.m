//
//  SPSubscriptionFeedViewController.m
//  SP
//
//  Created by bichenkk on 20/2/13.
//  Copyright (c) 2013 biworks. All rights reserved.
//

#import "SPSubscriptionFeedViewController.h"
#import "SPUtility.h"
#import "SPAccount.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPGetAccountsResponseData.h"

@interface SPSubscriptionFeedViewController ()

@end

@implementation SPSubscriptionFeedViewController

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
    switch (self.type) {
        case FOLLOWED:
            self.title = @"FOLLORWERS";
            break;
        case FOLLOWING:
        default:
            self.title = @"FOLLOWING";
            break;
    }
}

#pragma mark - Request Methods

- (void)sendGetAccountsRequest
{
    switch (self.type) {
        case FOLLOWED:
            [self sendSubscriptionAccountsRequestWithType:FOLLOWED];
            break;
        case FOLLOWING:
        default:
            [self sendSubscriptionAccountsRequestWithType:FOLLOWING];
            break;
    }
}

- (void)sendSubscriptionAccountsRequestWithType:(FollowType)type
{
    self.isLoading = YES;
    self.isRequestFailed = NO;
    
    [self sendGetSubscriptionAccountsRequestWithUserId:self.account.accountId follow:type startKey:self.nextKey delegate:self];
}

- (void)SPGetSubscriptionAccountsRequestDidFinish:(SPGetAccountsResponseData*)response
{
    if (_reloading) {
        self.isLastAccount = NO;
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
        
        //if (!request.requestData.startKey) {
            self.accounts = nil;
            [self.accountTableView reloadData];
        //}
        
        if (self.accounts) {
            for (SPAccount *toAddAccount in response.accounts) {
                BOOL included = NO;
                for (SPAccount *account in self.accounts) {
                    if (account.accountId == toAddAccount.accountId) {
                        included = YES;
                    }
                }
                if (!included) {
                    [self.accounts addObject:toAddAccount];
                }
                
            }
        }else{
            self.accounts = response.accounts;
        }
        
        self.nextKey = response.nextKey;
        
        //if (!response.nextKey) {
            self.isLastAccount = YES;
        //}
    }
    [self.accountTableView reloadData];
    self.isLoading = NO;
}

- (void)dealloc {
    [_account release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
