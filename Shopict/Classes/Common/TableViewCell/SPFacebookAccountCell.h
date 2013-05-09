//
//  SPFacebookAccountCell.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPFacebookAccount;
@protocol SPFacebookAccountCellDelegate <NSObject>

- (void)SPFacebookAccountCellDidInviteAccount:(SPFacebookAccount *)account;

@end

@interface SPFacebookAccountCell : UITableViewCell

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) SPFacebookAccount *account;

@end
