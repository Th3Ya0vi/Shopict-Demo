//
//  SPSideMenuViewController.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPSideMenuViewController.h"
#import "SPSplitViewController.h"
#import "SPBaseNavigationController.h"
#import "SPPostMainFeedViewController.h"
#import "SPExploreViewController.h"
#import "SPNewsViewController.h"
#import "SPProfileViewController.h"

@interface SPSideMenuViewController ()

@end

@implementation SPSideMenuViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_splitViewController release];
    [_feedNavigationController release];
    [_findNavigationController release];
    [_newsNavigationController release];
    [_meNavigationController release];
    [super dealloc];
}

- (IBAction)mainFeedButtonPressed:(id)sender {
    self.splitViewController.detailViewController = self.feedNavigationController;
}

- (IBAction)exploreButtonPressed:(id)sender {
    self.splitViewController.detailViewController = self.findNavigationController;
}

- (IBAction)newButtonPressed:(id)sender {
    self.splitViewController.detailViewController = self.newsNavigationController;
}

- (IBAction)profileButtonPressed:(id)sender {
    self.splitViewController.detailViewController = self.meNavigationController;
}

#pragma mark -
#pragma mark Object Init

- (UINavigationController *)feedNavigationController
{
    if (!_feedNavigationController) {
        SPPostMainFeedViewController *viewController = [[SPPostMainFeedViewController alloc]initWithNibName:@"SPPostMainFeedViewController" bundle:nil];
        _feedNavigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        [viewController release];
    }
    return _feedNavigationController;
}

- (UINavigationController *)findNavigationController
{
    if (!_findNavigationController) {
        SPExploreViewController *viewController = [[SPExploreViewController alloc]initWithNibName:@"SPExploreViewController" bundle:nil];
        _findNavigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        [viewController release];
    }
    return _findNavigationController;
}

- (UINavigationController *)newsNavigationController
{
    if (!_newsNavigationController) {
        SPNewsViewController *viewController = [[SPNewsViewController alloc]initWithNibName:@"SPNewsViewController" bundle:nil];
        _newsNavigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        [viewController release];
    }
    return _newsNavigationController;
}

- (UINavigationController *)meNavigationController
{
    if (!_meNavigationController) {
        SPProfileViewController *viewController = [[SPProfileViewController alloc]initWithNibName:(IS_IPAD?@"SPProfileViewController_iPad":@"SPProfileViewController") bundle:nil];
        viewController.isTabMe = YES;
        _meNavigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        [viewController release];
    }
    return _meNavigationController;
}



@end
