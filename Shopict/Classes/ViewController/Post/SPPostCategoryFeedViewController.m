//
//  SPProductCategoryFeedViewController.m
//  SP
//
//  Created by bichenkk on 13年2月22日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPPostCategoryFeedViewController.h"
#import "SPCategory.h"
#import "SPUtility.h"
#import "SPProduct.h"
#import "SPPost.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPGetPostsResponseData.h"

@interface SPPostCategoryFeedViewController ()

@end

@implementation SPPostCategoryFeedViewController

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
    self.navigationItem.title = [self.category.name uppercaseString];
    
    [self setIsGridViewButton:YES];
}

#pragma mark - Request Methods

- (void)sendGetPostsRequest
{
    [self sendGetAllProductsRequest];
}

- (void)sendGetAllProductsRequest
{
    self.isLoading = YES;
    self.isRequestFailed = NO;
    
    [self sendGetPostsByCategoryRequestWithCategoryId:self.category.categoryId startKey:self.nextKey delegate:self];
}

- (void)SPGetPostsByCategoryRequestDidFinish:(SPGetPostsResponseData*)response startKey:(NSString *)startKey
{
    if (_reloading) {
        self.isLastPost = NO;
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
        
        if (!startKey) {
            self.posts = nil;
            [self.productTableView reloadData];
        }
        
        if (self.posts) {
            for (SPPost *toAddPost in response.posts) {
                BOOL included = NO;
                for (SPPost *product in self.posts) {
                    if ([product.postId isEqualToString:toAddPost.postId]) {
                        included = YES;
                    }
                }
                if (!included) {
                    [self.posts addObject:toAddPost];
                }
                
            }
        }else{
            self.posts = response.posts;
        }
        
        self.nextKey = response.nextKey;
        
        if (!response.nextKey) {
            self.isLastPost = YES;
        }
    }
    [self.productTableView reloadData];
    self.isLoading = NO;
}

- (void)dealloc {
    [_category release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
