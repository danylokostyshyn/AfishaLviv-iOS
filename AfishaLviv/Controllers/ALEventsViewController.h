//
//  EventsViewController.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.06.12.

#import "ALViewController.h"

//models
#import "ALEvent.h"

//views
#import "ALDatePickerView.h"

@interface ALEventsViewController : UITableViewController <ALDatePickerViewDelegate>
@property (nonatomic) ALEventType eventsType;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSDate *currentDate;
@end
