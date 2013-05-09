//
//  SPSideMenuViewController.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseViewController.h"

@class SPSplitViewController;
@interface SPSideMenuViewController : SPBaseViewController

@property (nonatomic, retain) SPSplitViewController *splitViewController;

@property (nonatomic, retain) UINavigationController *feedNavigationController;
@property (nonatomic, retain) UINavigationController *findNavigationController;
@property (nonatomic, retain) UINavigationController *newsNavigationController;
@property (nonatomic, retain) UINavigationController *meNavigationController;

@end
