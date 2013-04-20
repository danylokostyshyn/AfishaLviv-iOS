//
//  EventsTVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import <UIKit/UIKit.h>

//models
#import "DataManager.h"

//controlles
#import "DatePickerVC.h"
#import "SettingsVC.h"

@interface EventsTVC : UITableViewController <DatePickerDatasource, DatePickerDelegate, SettingsDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell *eventCell;
@property (nonatomic) EventType type;

- (id)initWithEventType:(EventType)type;

@end
