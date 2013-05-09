//
//  SPInterestSelectionViewController.m
//  SP
//
//  Created by Bi Chen Ka Kit on 13年3月6日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPInterestSelectionViewController.h"
#import "SPUtility.h"
#import "SPCategory.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPGetCategoriesResponseData.h"
#import "SPTableViewFooterView.h"
#import "SPInterestButton.h"
#import "UIButton+WebCache.h"
#import "UIButton+SPButtonUtility.h"
#import "SPTabMenuController.h"

@interface SPInterestSelectionViewController ()

@end

@implementation SPInterestSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationItem setTitle:[@"INTERESTS" uppercaseString]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SPTableViewFooterView *loadingView = [SPTableViewFooterView footerView];
    self.loadingView = loadingView;
    [self.loadingView setFrame:self.view.frame];
    [self.view addSubview:self.loadingView];
    self.loadingView.delegate = self;
    [self sendCategoryRequest];
    
    self.scollView.pagingEnabled = YES;
    
    if ([UIScreen mainScreen].bounds.size.height > 500) {
        [self.scollView setFrame:CGRectMake(0, 93, 320, 320)];
    }
    
    [self.navigationItem setBackBarButtonItem:nil];
    [self.navigationItem setLeftBarButtonItem:nil];
    
    UIButton *rightBarButton = [UIButton barButtonItemWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:rightBarButton]autorelease];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScollView:nil];
    [self setLoadingView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

- (void)sendCategoryRequest
{
    [self.loadingView recenterSubviews];
    [self.loadingView showLoading];
    
    [self sendGetCategoriesRequestWithCategoryId:nil delegate:self];
    
}

- (void)SPGetCategoriesRequestDidFinish:(SPGetCategoriesResponseData*)response
{
    if (response.error) {
        [self.loadingView showReloadButton];
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
        self.loadingView.hidden = YES;
        self.categories = [NSMutableArray array];
        for (SPCategory *category in response.categories) {
            if ([category.categoryId integerValue]!=-1) {
                [self.categories addObject:category];
            }
        }
        [self adjustSelectorLayout];
    }
}

- (void)dealloc
{
    [_categories release];
    [_scollView release];
    [_loadingView release];
    [_pageControl release];
    [super dealloc];
}

- (void)adjustSelectorLayout;
{
    self.buttons = [NSMutableArray array];
    NSInteger pageNumber = self.categories.count/9;
    if (self.categories.count%9!=0) {
        pageNumber++;
    }
    [self.scollView setContentSize:CGSizeMake(320*pageNumber, 320)];
    [self.pageControl setNumberOfPages:pageNumber];
    NSInteger page = 0;
    for(SPCategory *category in self.categories){
        if([self.categories indexOfObject:category]%9==0 && [self.categories indexOfObject:category]!=0)
        {
            page++;
        }
        [self addInterestButtonOnScrollViewWithPage:page category:category];
    }
}

- (void)addInterestButtonOnScrollViewWithPage:(NSInteger)page category:(SPCategory *)category
{
    NSInteger pageCoordinate = page*320;
    SPInterestButton *button = [SPInterestButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(interestButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = [self.categories indexOfObject:category];
    
    if([self.categories indexOfObject:category]%9==0){
        [button setFrame:CGRectMake(pageCoordinate+10, 10, 95, 95)];
    }
    
    if([self.categories indexOfObject:category]%9==1){
        [button setFrame:CGRectMake(pageCoordinate+113, 10, 95, 95)];
    }
    
    if([self.categories indexOfObject:category]%9==2){
        [button setFrame:CGRectMake(pageCoordinate+216, 10, 95, 95)];
    }
    
    if([self.categories indexOfObject:category]%9==3){
        [button setFrame:CGRectMake(pageCoordinate+10, 113, 95, 95)];
    }
    
    if([self.categories indexOfObject:category]%9==4){
        [button setFrame:CGRectMake(pageCoordinate+113, 113, 95, 95)];
    }
    
    if([self.categories indexOfObject:category]%9==5){
        [button setFrame:CGRectMake(pageCoordinate+216, 113, 95, 95)];
    }
    
    if([self.categories indexOfObject:category]%9==6){
        [button setFrame:CGRectMake(pageCoordinate+10, 216, 95, 95)];
    }
    
    if([self.categories indexOfObject:category]%9==7){
        [button setFrame:CGRectMake(pageCoordinate+113, 216, 95, 95)];
    }
    
    if([self.categories indexOfObject:category]%9==8){
        [button setFrame:CGRectMake(pageCoordinate+216, 216, 95, 95)];
    }
    
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_interest"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_interest"] forState:UIControlStateNormal|UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_interest_highlighted"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateNormal];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_interest_highlighted"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:category.whiteImageURL] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image) {
            [button setImage:image forState:UIControlStateSelected];
            [button setImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
        }
    }];
    [manager downloadWithURL:[NSURL URLWithString:category.greyImageURL] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image) {
            [button setImage:image forState:UIControlStateNormal];
        }
    }];
    
    [button setTitle:category.name forState:UIControlStateNormal];
    
    button.selected = category.isBined;
    
    [self.scollView addSubview:button];
    [self.buttons addObject:button];
}

- (void)SPTableViewFooterViewDidSelectReload
{
    [self sendCategoryRequest];
}

-(IBAction)interestButtonPressed:(id)sender
{
    SPInterestButton *button = sender;
    if (button.selected) {
        button.selected = NO;
    }else{
        button.selected = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.pageControl setCurrentPage:page];
}

- (IBAction)saveButtonPressed:(id)sender
{
    if (self.buttons && self.categories) {
        NSMutableArray *selectedTags = [NSMutableArray array];
        for (UIButton *button in self.buttons) {
            if (button.selected) {
                NSNumber *selectedTag = [NSNumber numberWithInt:button.tag];
                [selectedTags addObject:selectedTag];
            }
        }
        if (selectedTags.count < 3) {
            [self showHUDErrorViewWithMessage:@"Please Select at least 3"];
        }else{
            NSMutableArray *categoryIds = [NSMutableArray array];
            for (NSNumber *tag in selectedTags) {
                SPCategory *category = [self.categories objectAtIndex:[tag integerValue]];
                [categoryIds addObject:category.categoryId];
            }
            NSLog(@"categoryIds %@",categoryIds);
            [self showHUDLoadingViewWithTitle:@"Saving"];
            [self sendBindAccountToCategoriesRequestWithCategoryIds:categoryIds delegate:self];
        }
    }else{
        [self showHUDErrorViewWithMessage:@"Please reload first!"];
    }
}

- (void)SPBindAccountToCategoriesRequestDidFinish:(SPBaseResponseData*)response
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
        [self showHUDTickViewWithMessage:@"Saved"];
        [self performSelector:@selector(goToTabMenuController) withObject:nil afterDelay:1.0f];
    }
}

- (void)goToTabMenuController
{
    if (IS_IPAD) {
        
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        SPTabMenuController *tabBarViewController = [[SPTabMenuController alloc]init];
        [self.navigationController pushViewController:tabBarViewController animated:NO];
        [tabBarViewController release];
    }
}



@end
