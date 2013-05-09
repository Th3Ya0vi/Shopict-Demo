//
//  SPTwitterAccountFeedViewController.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseViewController.h"
#import <Accounts/Accounts.h>

@protocol SPTwitterAccountFeedViewControllerDelegate <NSObject>

- (void)SPTwitterAccountFeedViewControllerDidSelectAccount:(ACAccount *)account;

@end

@interface SPTwitterAccountFeedViewController : SPBaseViewController

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UITableView *accountTableView;
@property (retain, nonatomic) NSArray *accounts;

@end
