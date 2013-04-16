//
//  EventsTVC.h
//  AfishaLviv
//
//  Created by Mac on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Event+AfishaLviv.h"

#import "DatePickerVC.h"
#import "SettingsVC.h"

@interface EventsTVC : UITableViewController <DatePickerDatasource, DatePickerDelegate, SettingsDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell *eventCell;


@property (nonatomic) EventType type;

- (id)initWithEventType:(EventType)type;

@end
