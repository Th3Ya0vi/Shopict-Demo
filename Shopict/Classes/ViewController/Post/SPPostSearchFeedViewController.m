//
//  SPProductSearchFeedViewController.m
//  SP
//
//  Created by bichenkk on 13年2月24日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPPostSearchFeedViewController.h"
#import "SPUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPGetPostsResponseData.h"
#import "SPPost.h"

@interface SPPostSearchFeedViewController ()

@end

@implementation SPPostSearchFeedViewController

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
    self.navigationItem.title = [self.keyword uppercaseString];
    
    [self setIsGridViewButton:YES];
}

#pragma mark - Request Methods

- (void)sendGetPostsRequest
{
    self.isLoading = YES;
    self.isRequestFailed = NO;
    [self sendGetPostsByKeywordRequestWithKeyword:self.keyword startKey:self.nextKey delegate:self];
}

- (void)SPGetPostsByKeywordRequestDidFinish:(SPGetPostsResponseData*)response startKey:(NSString *)startKey
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
                for (SPPost *post in self.posts) {
                    if ([toAddPost.postId isEqualToString:post.postId]) {
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
    [_keyword release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
