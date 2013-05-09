//
//  SPFacebookAccountCell.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPFacebookAccountCell.h"
#import "SPFacebookAccount.h"
#import "UIImageView+WebCache.h"

@implementation SPFacebookAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_nameLabel release];
    [_profileImageView release];
    [super dealloc];
}

- (void)setAccount:(SPFacebookAccount *)account
{
    if (_account != account) {
        [_account release];
        _account = [account retain];
    }
    NSString *profilePictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",account.userId];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:profilePictureUrl]];
    [self.nameLabel setText:account.username];
}

- (IBAction)inviteButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SPFacebookAccountCellDidInviteAccount:)]) {
        [self.delegate SPFacebookAccountCellDidInviteAccount:self.account];
    }
}


@end
