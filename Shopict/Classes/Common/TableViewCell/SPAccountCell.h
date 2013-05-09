//
//  SPAccountCell.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月30日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPAccount;

@protocol SPAccountCellDelegate <NSObject>

- (void)SPAccountCellDidFollowAccount:(SPAccount *)account follow:(BOOL)follow;

@end

@interface SPAccountCell : UITableViewCell

@property (assign, nonatomic) id delegate;

@property (retain, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UIButton *subscribeButton;

@property (retain, nonatomic) SPAccount *account;
@property (assign, nonatomic) BOOL hideFollowButton;

@end
