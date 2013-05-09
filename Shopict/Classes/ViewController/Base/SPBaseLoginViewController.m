//
//  SPBaseLoginViewController.m
//  SP
//
//  Created by bichenkk on 13年2月19日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseLoginViewController.h"
#import "SPTabMenuController.h"

#import "SPSplitViewController.h"
#import "SPSideMenuViewController.h"
#import "SPPostMainFeedViewController.h"

@interface SPBaseLoginViewController ()

@end

@implementation SPBaseLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushTabMenuController{
    if (IS_IPAD) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        SPSplitViewController *splitViewController = [[SPSplitViewController alloc]init];
        [self.navigationController pushViewController:splitViewController animated:NO];
        [splitViewController release];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        SPTabMenuController *tabBarViewController = [[SPTabMenuController alloc]init];
        [self.navigationController pushViewController:tabBarViewController animated:NO];
        [tabBarViewController release];
    }
}


@end
