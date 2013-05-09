//
//  SPSplitViewController.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPSplitViewController.h"
#import "SPProfileViewController.h"
#import "SPSideMenuViewController.h"

@interface SPSplitViewController ()

@end

@implementation SPSplitViewController

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
    SPSideMenuViewController *menuViewController = [[SPSideMenuViewController alloc]initWithNibName:@"SPSideMenuViewController" bundle:nil];
    menuViewController.splitViewController = self;
    self.showsMasterInPortrait = YES;
    self.masterBeforeDetail = YES;
    self.masterViewController = menuViewController;
    self.detailViewController = menuViewController.feedNavigationController;
    [menuViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
