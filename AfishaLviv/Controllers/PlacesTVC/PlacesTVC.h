//
//  PlacesTVC.h
//  AfishaLviv
//
//  Created by Mac on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Place+AfishaLviv.h"

@interface PlacesTVC : UITableViewController

@property (nonatomic) PlaceType placeType;

- (id)initWithPlaceType:(PlaceType)type;

@end
