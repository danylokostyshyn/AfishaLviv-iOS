//
//  EventsViewController.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.06.12.

#import "ALViewController.h"

#import "ALEvent.h"

@interface ALEventsViewController : UITableViewController
@property (nonatomic) ALEventType eventsType;
@property (strong, nonatomic) NSMutableArray *items;
@end
