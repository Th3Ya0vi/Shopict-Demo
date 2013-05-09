//
//  SPSubscriptionFeedViewController.h
//  SP
//
//  Created by bichenkk on 20/2/13.
//  Copyright (c) 2013 biworks. All rights reserved.
//

#import "SPAccountFeedViewController.h"
#import "SPEnum.h"

@class SPAccount;
@interface SPSubscriptionFeedViewController : SPAccountFeedViewController

@property (nonatomic, assign) FollowType type;
@property (nonatomic, retain) SPAccount *account;

@end
