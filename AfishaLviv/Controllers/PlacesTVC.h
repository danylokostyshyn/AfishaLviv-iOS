//
//  PlacesTVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.04.12.

#import <UIKit/UIKit.h>

//models
#import "DataManager.h"

@interface PlacesTVC : UITableViewController

@property (nonatomic) PlaceType placeType;

- (id)initWithPlaceType:(PlaceType)type;

@end
