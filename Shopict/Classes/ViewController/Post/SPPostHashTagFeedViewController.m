 //
//  SPProductHashTagFeedViewController.m
//  SP
//
//  Created by bichenkk on 13年2月22日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPPostHashTagFeedViewController.h"
#import "NSString+SPStringUtility.h"
#import "SPUtility.h"
#import "SPProduct.h"
#import "SPPost.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPGetPostsResponseData.h"

@interface SPPostHashTagFeedViewController ()

@end

@implementation SPPostHashTagFeedViewController

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
    self.navigationItem.title = self.hashTag;
    
//    [self.trackButton setTitle:@"Track" forState:UIControlStateNormal];
//    [self.trackButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self.trackButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.trackButton setTitle:@"Track" forState:UIControlStateNormal|UIControlStateHighlighted];
//    [self.trackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateHighlighted];
//    [self.trackButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
//    [self.trackButton setTitle:@"Track'd" forState:UIControlStateSelected];
//    [self.trackButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
//    [self.trackButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [self.trackButton setTitle:@"Track'd" forState:UIControlStateSelected|UIControlStateHighlighted];
//    [self.trackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
//    [self.trackButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
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
    
    [self sendGetPostsByTagRequestWithTag:self.hashTag startKey:self.nextKey delegate:self];
}

- (void)SPGetPostsByTagRequestDidFinish:(SPGetPostsResponseData*)response startKey:(NSString *)startKey
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
    [_hashTag release];
    [_trackHeaderView release];
    [_trackButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTrackHeaderView:nil];
    [self setTrackButton:nil];
    [super viewDidUnload];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return self.trackHeaderView.frame.size.height;
//    }
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return self.trackHeaderView;
//    }
//    return nil;
//}

- (IBAction)trackButtonPressed:(id)sender {
    if (self.trackButton.selected == YES) {
        self.trackButton.selected = NO;
    }else{
        self.trackButton.selected = YES;
    }
}


@end
