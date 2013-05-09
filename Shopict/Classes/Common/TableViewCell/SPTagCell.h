//
//  SPTagCell.h
//  SHOPBOOK
//
//  Created by bichenkk on 13年2月2日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTagCell : UITableViewCell

@property (nonatomic, retain) NSString *hashTag;
@property (retain, nonatomic) IBOutlet UILabel *tagLabel;


@end
