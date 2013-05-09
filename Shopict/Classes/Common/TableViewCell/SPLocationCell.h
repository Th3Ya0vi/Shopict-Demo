//
//  SPLocationCell.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPVenue;
@interface SPLocationCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;

@property (retain, nonatomic) SPVenue *venue;

@end
