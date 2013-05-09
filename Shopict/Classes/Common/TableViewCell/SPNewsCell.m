//
//  SPNewsCell.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月22日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPNewsCell.h"
#import "SPNews.h"
#import "SPPost.h"
#import "SPAccount.h"
#import "UIButton+WebCache.h"
#import "NSDate+TimeAgo.h"

#define LAYOUTMARGIN 5

@implementation SPNewsCell

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
    [_accountUsernameButton release];
    [_accountImageButton release];
    [_descriptionLabel release];
    [_dateTimeLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.accountImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)setNews:(SPNews *)news
{
    if (_news != news)
    {
        [_news release];
        _news = [news retain];
    }
    
    SPAccount *account = news.account;
    [self.accountImageButton setImageWithURL:[NSURL URLWithString:account.profileImgURL] forState:UIControlStateNormal];
    [self.accountUsernameButton setTitle:account.name forState:UIControlStateNormal];
    self.descriptionLabel.text = self.news.description;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *date = [dateFormatter dateFromString:news.dateTime];
    [dateFormatter release];
    NSString *ago = [date timeAgo];
    [self.dateTimeLabel setText:ago];
    
    CGSize maximumAccountNameButtonSize = CGSizeMake(CGRectGetWidth(self.accountUsernameButton.frame),CGRectGetHeight(self.accountUsernameButton.frame));
    CGSize expectedAccountNameButtonSize = [account.name sizeWithFont:self.accountUsernameButton.titleLabel.font constrainedToSize:maximumAccountNameButtonSize lineBreakMode:self.accountUsernameButton.titleLabel.lineBreakMode];
    [self.accountUsernameButton setFrame:CGRectMake(CGRectGetMinX(self.accountUsernameButton.frame), CGRectGetMinY(self.accountUsernameButton.frame), expectedAccountNameButtonSize.width+LAYOUTMARGIN, CGRectGetHeight(self.accountUsernameButton.frame))];
    
    CGSize maximumdescriptionLabelSize = CGSizeMake(CGRectGetWidth(self.descriptionLabel.frame),1000);
    CGSize expecteddescriptionLabelSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:maximumdescriptionLabelSize lineBreakMode:self.descriptionLabel.lineBreakMode];
    [self.descriptionLabel setFrame:CGRectMake(CGRectGetMinX(self.descriptionLabel.frame), CGRectGetMinY(self.descriptionLabel.frame), CGRectGetWidth(self.descriptionLabel.frame), expecteddescriptionLabelSize.height)];
}

- (IBAction)accountButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SPNewsCellDidSelectAccount:)]) {
        [self.delegate SPNewsCellDidSelectAccount:self.news.account];
    }
}



@end
