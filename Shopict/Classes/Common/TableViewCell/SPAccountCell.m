//
//  SPAccountCell.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月30日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPAccountCell.h"
#import "SPAccount.h"
#import "UIImageView+WebCache.h"
#import "SPUtility.h"

@implementation SPAccountCell

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
    [_account release];
    [_profileImageView release];
    [_profileNameLabel release];
    [_subscribeButton release];
    [_usernameLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.subscribeButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.subscribeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.subscribeButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.subscribeButton setTitle:@"Follow" forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.subscribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.subscribeButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.subscribeButton setTitle:@"Follow'd" forState:UIControlStateSelected];
    [self.subscribeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [self.subscribeButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.subscribeButton setTitle:@"Follow'd" forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.subscribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.subscribeButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void)setAccount:(SPAccount *)account
{
    if (_account != account) {
        [_account release];
        _account = [account retain];
    }

    [self.profileImageView setImageWithURL:[NSURL URLWithString:account.profileImgURL]];
    [self.profileNameLabel setText:account.name];
    [self.usernameLabel setText:[NSString stringWithFormat:@"@%@",account.username]];
    
    self.subscribeButton.selected = account.subscribed;
    
    if (self.hideFollowButton == YES) {
        self.subscribeButton.hidden = YES;
    }else{
        self.subscribeButton.hidden = NO;
    }
    
    if (account.me) {
        self.subscribeButton.hidden = YES;
    }else{
        self.subscribeButton.hidden = NO;
    }
}

- (IBAction)followButtonPressed:(id)sender {
    if (self.subscribeButton.selected) {
        if ([self.delegate respondsToSelector:@selector(SPAccountCellDidFollowAccount:follow:)]) {
            [self.delegate SPAccountCellDidFollowAccount:self.account follow:NO];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(SPAccountCellDidFollowAccount:follow:)]) {
            [self.delegate SPAccountCellDidFollowAccount:self.account follow:YES];
        }
    }
}




@end
