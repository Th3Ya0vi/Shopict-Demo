//
//  SPTabMenuController.h
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTabMenuController : UITabBarController

@property (nonatomic, retain) UINavigationController *feedNavigationController;
@property (nonatomic, retain) UINavigationController *findNavigationController;
@property (nonatomic, retain) UINavigationController *newsNavigationController;
@property (nonatomic, retain) UINavigationController *meNavigationController;

@end
