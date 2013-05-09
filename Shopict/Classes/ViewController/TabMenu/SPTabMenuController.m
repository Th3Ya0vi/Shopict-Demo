//
//  SPTabMenuController.m
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPTabMenuController.h"
#import "SPBaseNavigationController.h"
#import "SPPostMainFeedViewController.h"
#import "SPExploreViewController.h"
#import "SPNewsViewController.h"
#import "SPProfileViewController.h"

#define TABBARHEIGHT 44

@interface SPTabMenuController ()

@end

@implementation SPTabMenuController

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
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.viewControllers = [NSArray arrayWithObjects:self.feedNavigationController ,self.findNavigationController,self.newsNavigationController,self.meNavigationController, nil];
    [self.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-TABBARHEIGHT, 320, TABBARHEIGHT)];
    [[self.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-TABBARHEIGHT)];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"background_tab"]];
    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"background_tabselection"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_feedNavigationController release];
    [_findNavigationController release];
    [_newsNavigationController release];
    [_meNavigationController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Object Init

- (UINavigationController *)feedNavigationController
{
    if (!_feedNavigationController) {
        SPPostMainFeedViewController *viewController = [[SPPostMainFeedViewController alloc]initWithNibName:@"SPPostMainFeedViewController" bundle:nil];
        _feedNavigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        [viewController release];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"tab_shop"] tag:0];
        [tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
        _feedNavigationController.tabBarItem = tabBarItem;
        [tabBarItem release];
        
    }
    return _feedNavigationController;
}

- (UINavigationController *)findNavigationController
{
    if (!_findNavigationController) {
        SPExploreViewController *viewController = [[SPExploreViewController alloc]initWithNibName:@"SPExploreViewController" bundle:nil];
        _findNavigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        [viewController release];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"tab_explore"] tag:1];
        [tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
        _findNavigationController.tabBarItem = tabBarItem;
        [tabBarItem release];
    }
    return _findNavigationController;
}

- (UINavigationController *)newsNavigationController
{
    if (!_newsNavigationController) {
        SPNewsViewController *viewController = [[SPNewsViewController alloc]initWithNibName:@"SPNewsViewController" bundle:nil];
        _newsNavigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        [viewController release];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"tab_news"] tag:2];
        [tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
        _newsNavigationController.tabBarItem = tabBarItem;
        [tabBarItem release];
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
        UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"tab_profile"] tag:3];
        [tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
        _meNavigationController.tabBarItem = tabBarItem;
        [tabBarItem release];
    }
    return _meNavigationController;
}
@end
