//
//  SPBaseNavigationController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface SPBaseNavigationController ()

@end

@implementation SPBaseNavigationController

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
    self.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 2);
    self.navigationBar.layer.shadowOpacity = 0.25;
    self.navigationBar.layer.masksToBounds = NO;
    self.navigationBar.layer.shouldRasterize = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
