//
//  SPInterestSelectionViewController.h
//  SP
//
//  Created by Bi Chen Ka Kit on 13年3月6日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@class SPTableViewFooterView;
@interface SPInterestSelectionViewController : SPBaseTabbedViewController

@property (retain, nonatomic) IBOutlet UIScrollView *scollView;
@property (retain, nonatomic) NSMutableArray *categories;
@property (retain, nonatomic) SPTableViewFooterView *loadingView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet NSMutableArray *buttons;

@end
