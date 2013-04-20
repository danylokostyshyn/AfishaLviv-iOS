//
//  PlaceCell.h
//  AfishaLviv
//
//  Created by Mac on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DKImageView.h"

@interface PlaceCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) DKImageView *dkImageView;

@end
