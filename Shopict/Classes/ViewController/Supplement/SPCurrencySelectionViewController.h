//
//  SBCurrencySelectionViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年12月13日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"


@protocol SPCurrencySelectionViewControllerDelegate <NSObject>

- (void)SPCurrencySelectionViewControllerDidSelectCurrency:(NSString *)currency;

@end

@interface SPCurrencySelectionViewController : SPBaseTabbedViewController

@property (assign, nonatomic) id delegate;

@property (retain, nonatomic) IBOutlet UITableView *currencyTableView;

@property (retain, nonatomic) NSString *currency;
@property (retain, nonatomic) NSMutableArray *currencies;


@end
