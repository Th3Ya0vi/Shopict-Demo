//
//  SBCurrencySelectionViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年12月13日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPCurrencySelectionViewController.h"
#import "UIButton+SPButtonUtility.h"
#import "UIColor+SPColorUtility.h"

@interface SPCurrencySelectionViewController ()

@end

@implementation SPCurrencySelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"CURRENCY";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *rightBarButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
    [rightBarButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setLeftBarButtonItem:rightBarButtonItem];
    [rightBarButtonItem release];
    
    self.currencies = [NSMutableArray array];
    for (NSString *currencyCode in [NSLocale commonISOCurrencyCodes]) {
        NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
        NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
        NSLog(@"%@ %@",currencyCode,currencySymbol);
        if (![self.currency isEqualToString:currencyCode]) {
            [self.currencies addObject:currencyCode];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_currencyTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCurrencyTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.currencies.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CurrencyCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor themeColor]];
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    
    if (indexPath.section == 0) {
        [cell.textLabel setText:self.currency];
    }else{
        NSString *currency = [self.currencies objectAtIndex:indexPath.row];
        [cell.textLabel setText:currency];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(SPCurrencySelectionViewControllerDidSelectCurrency:)]) {
        
        NSString *currencyCode = nil;
        if (indexPath.section == 0) {
            currencyCode = self.currency;
        }else{
            currencyCode = [self.currencies objectAtIndex:indexPath.row];
        }
        [self.delegate SPCurrencySelectionViewControllerDidSelectCurrency:currencyCode];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Selected";
    }else{
        return @"Options";
    }
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
