//
//  SBProductCommentCell.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年12月18日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPAccount, SPComment, IFTweetLabel;

@protocol SBProductCommentCellDelegate <NSObject>

- (void)SPPostCommentCellDidSelectAccount:(SPAccount *)account;

@end

@interface SPPostCommentCell : UITableViewCell

@property (assign, nonatomic) id delegate;
@property (nonatomic, retain) SPComment *comment;

@property (retain, nonatomic) IBOutlet UIButton *accountImageButton;
@property (retain, nonatomic) IBOutlet UIButton *accountNameButton;
@property (retain, nonatomic) IBOutlet UILabel *commentLabel;
@property (retain, nonatomic) IFTweetLabel *commentWithTagLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateTimeLabel;

- (IBAction)accountButtonPressed:(id)sender;

@end
