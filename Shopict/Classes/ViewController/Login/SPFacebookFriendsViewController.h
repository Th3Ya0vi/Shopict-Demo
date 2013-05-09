//
//  SPFacebookFriendsViewController.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseViewController.h"

@class SPTableViewFooterView;
@interface SPFacebookFriendsViewController : SPBaseViewController

@property (nonatomic, retain) NSMutableArray *facebookAccounts;
@property (retain, nonatomic) IBOutlet UITableView *accountTableView;
@property (nonatomic, retain) SPTableViewFooterView *footerView;
@property (retain, nonatomic) IBOutlet UIView *facebookHeaderView;
@property (nonatomic, assign) BOOL isRequestFailed;
@property (nonatomic, assign) BOOL noMatchedAccounts;

@end
