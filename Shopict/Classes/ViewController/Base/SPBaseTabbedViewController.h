//
//  SPBaseTabbedViewController.h
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseViewController.h"

@class SPPost, SPAccount;
@interface SPBaseTabbedViewController : SPBaseViewController

- (void)setNavigationBarWithLogo;

- (void)wantPost:(SPPost *)post want:(BOOL)want;
- (void)repostPost:(SPPost *)post repost:(BOOL)repost;
- (void)subscribeAccount:(SPAccount *)account follow:(BOOL)follow;

@end
