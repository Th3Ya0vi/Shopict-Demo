//
//  SPLogInOptionViewController.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseLoginViewController.h"

@interface SPLogInOptionViewController : SPBaseLoginViewController
<UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UIView *launchCoverView;
@property (retain, nonatomic) IBOutlet UIImageView *launchCoverImageView;

@end
