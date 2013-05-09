//
//  SPNewsCell.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月22日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPNews, SPAccount;

@protocol SPNewsCellDelegate <NSObject>

- (void)SPNewsCellDidSelectAccount:(SPAccount *)account;

@end

@interface SPNewsCell : UITableViewCell

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UIButton *accountImageButton;
@property (retain, nonatomic) IBOutlet UIButton *accountUsernameButton;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, retain) SPNews *news;

- (IBAction)accountButtonPressed:(id)sender;

@end
