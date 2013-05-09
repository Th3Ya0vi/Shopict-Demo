//
//  SPTwitterAccountFeedViewController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPTwitterAccountFeedViewController.h"
#import "UIButton+SPButtonUtility.h"

@interface SPTwitterAccountFeedViewController ()

@end

@implementation SPTwitterAccountFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"SELECT ACCOUNT";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *rightBarButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
    [rightBarButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    [barButtonItem release];
}

-(IBAction)cancelButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(SPTwitterAccountFeedViewControllerDidSelectAccount:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^(void){[self.delegate SPTwitterAccountFeedViewControllerDidSelectAccount:nil];}] ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_accountTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAccountTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TwitterCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor colorWithRed:208/255.0 green:35/255.0 blue:28/255.0 alpha:1]];
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    ACAccount *account = [self.accounts objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"@%@",account.username]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(SPTwitterAccountFeedViewControllerDidSelectAccount:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^(void){[self.delegate SPTwitterAccountFeedViewControllerDidSelectAccount:[self.accounts objectAtIndex:indexPath.row]];}] ;
    }
}

@end
