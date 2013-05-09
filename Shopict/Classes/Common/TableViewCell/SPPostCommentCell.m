//
//  SBProductCommentCell.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年12月18日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPPostCommentCell.h"
#import "SPComment.h"
#import "SPAccount.h"
#import "UIButton+WebCache.h"
#import "NSDate+TimeAgo.h"
#import "IFTweetLabel.h"

#define LAYOUTMARGIN 5

@implementation SPPostCommentCell

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
    [_accountImageButton release];
    [_accountNameButton release];
    [_commentLabel release];
    [_dateTimeLabel release];
    [_commentWithTagLabel release];
    [super dealloc];
}

- (IBAction)accountButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SPPostCommentCellDidSelectAccount:)]) {
        [self.delegate SPPostCommentCellDidSelectAccount:self.comment.account];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.accountImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)setComment:(SPComment *)comment
{
    if (_comment != comment)
    {
        [_comment release];
        _comment = [comment retain];
    }
    SPAccount *account = comment.account;
    [self.accountImageButton setImageWithURL:[NSURL URLWithString:account.profileImgURL] forState:UIControlStateNormal];
    [self.accountNameButton setTitle:account.name forState:UIControlStateNormal];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *date = [dateFormatter dateFromString:comment.dateTime];
    [dateFormatter release];
    NSString *ago = [date timeAgo];
    [self.dateTimeLabel setText:ago];
    
    CGSize maximumAccountNameButtonSize = CGSizeMake(CGRectGetWidth(self.accountNameButton.frame),CGRectGetHeight(self.accountNameButton.frame));
    CGSize expectedAccountNameButtonSize = [account.name sizeWithFont:self.accountNameButton.titleLabel.font constrainedToSize:maximumAccountNameButtonSize lineBreakMode:self.accountNameButton.titleLabel.lineBreakMode];
    [self.accountNameButton setFrame:CGRectMake(CGRectGetMinX(self.accountNameButton.frame), CGRectGetMinY(self.accountNameButton.frame), expectedAccountNameButtonSize.width+LAYOUTMARGIN, CGRectGetHeight(self.accountNameButton.frame))];
    
    CGSize maximumCommentLabelSize = CGSizeMake(CGRectGetWidth(self.commentLabel.frame),1000);
    CGSize expectedCommentLabelSize = [self.comment.comment sizeWithFont:self.commentLabel.font constrainedToSize:maximumCommentLabelSize lineBreakMode:self.commentLabel.lineBreakMode];
    [self.commentLabel setFrame:CGRectMake(CGRectGetMinX(self.commentLabel.frame), CGRectGetMinY(self.commentLabel.frame), CGRectGetWidth(self.commentLabel.frame), expectedCommentLabelSize.height)];
    
    [self.commentWithTagLabel removeFromSuperview];
    self.commentWithTagLabel = [[[IFTweetLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.commentLabel.frame), CGRectGetMinY(self.commentLabel.frame), CGRectGetWidth(self.commentLabel.frame), expectedCommentLabelSize.height)] autorelease];
	[self.commentWithTagLabel setFont: [UIFont fontWithName:@"Helvetica" size:14.0]];
	[self.commentWithTagLabel setTextColor:[UIColor darkGrayColor]];
	[self.commentWithTagLabel setBackgroundColor:[UIColor clearColor]];
	[self.commentWithTagLabel setNumberOfLines:0];
	[self.commentWithTagLabel setText:self.comment.comment];
	[self.commentWithTagLabel setLinksEnabled:YES];
	[self addSubview:self.commentWithTagLabel];
}

@end
