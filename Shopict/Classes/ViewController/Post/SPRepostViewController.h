//
//  SPRepostViewController.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月23日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@class SPPost;

@interface SPRepostViewController : SPBaseTabbedViewController

@property (assign, nonatomic) id delegate;
@property (nonatomic, retain) SPPost *post;
@property (retain, nonatomic) IBOutlet UITextView *commentTextView;
@property (retain, nonatomic) IBOutlet UIButton *authorImageButton;

@end
