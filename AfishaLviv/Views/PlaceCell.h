//
//  PlaceCell.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.04.12.

#import <UIKit/UIKit.h>

//views
#import "DKImageView.h"

@interface PlaceCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) DKImageView *dkImageView;

@end
