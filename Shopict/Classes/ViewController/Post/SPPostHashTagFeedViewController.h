//
//  SPProductHashTagFeedViewController.h
//  SP
//
//  Created by bichenkk on 13年2月22日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPPostFeedViewController.h"

@interface SPPostHashTagFeedViewController : SPPostFeedViewController

@property (nonatomic, retain) NSString *hashTag;
@property (retain, nonatomic) IBOutlet UIView *trackHeaderView;
@property (retain, nonatomic) IBOutlet UIButton *trackButton;

@end
