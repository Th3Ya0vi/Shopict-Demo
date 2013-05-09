//
//  SPWantedCountViewController.m
//  SP
//
//  Created by Bi Chen Ka Kit on 13年3月1日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPWantedCountViewController.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPGetAccountsResponseData.h"
#import "SPProduct.h"
#import "SPUtility.h"
#import "SPAccount.h"

@interface SPWantedCountViewController ()

@end

@implementation SPWantedCountViewController

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
}

#pragma mark - Request Methods

- (void)sendGetAccountsRequest
{
    [self sendWantedAccountsRequest];
}

- (void)sendWantedAccountsRequest
{
    self.isLoading = YES;
    self.isRequestFailed = NO;
    
//    SPGetWantedAccountsRequestData *requestData = [SPGetWantedAccountsRequestData dataWithToken:[SPUtility getStoredToken] productId:self.product.productId startKey:self.nextKey];
//    SPGetWantedAccountsRequest *request = [SPGetWantedAccountsRequest requestWithRequestData:requestData delegate:self];
//    [request retrieve];
}

//- (void)SPGetWantedAccountsRequestDidResponse:(SPGetWantedAccountsRequest*)request
//{
//    if (_reloading) {
//        self.isLastAccount = NO;
//        [self doneLoadingTableViewData];
//    }
//    
//    SPGetWantedAccountsResponseData *response = request.response;
//    if (response.error) {
//        
//        self.isRequestFailed = YES;
//        
//        if (response.errorCode == 2) {
//            [self presentLoginViewController];
//            return;
//        }
//        
//        NSLog(@"%@",response.error);
//        [self showHUDErrorViewWithMessage:response.error];
//    }else{
//        NSLog(@"Success");
//        
//        //if (!request.requestData.startKey) {
//        self.accounts = nil;
//        [self.accountTableView reloadData];
//        //}
//        
//        if (self.accounts) {
//            for (SPAccount *toAddAccount in response.accounts) {
//                BOOL included = NO;
//                for (SPAccount *account in self.accounts) {
//                    if (account.accountId == toAddAccount.accountId) {
//                        included = YES;
//                    }
//                }
//                if (!included) {
//                    [self.accounts addObject:toAddAccount];
//                }
//                
//            }
//        }else{
//            self.accounts = response.accounts;
//        }
//        
//        self.nextKey = response.nextKey;
//        
//        //if (!response.nextKey) {
//        self.isLastAccount = YES;
//        //}
//    }
//    [self.accountTableView reloadData];
//    self.isLoading = NO;
//}

- (void)dealloc {
    [_post release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
