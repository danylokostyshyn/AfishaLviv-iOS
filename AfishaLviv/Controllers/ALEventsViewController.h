//
//  EventsViewController.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.06.12.

#import "ALViewController.h"

@interface ALEventsViewController : UITableViewController
@property (nonatomic) NSUInteger eventsType;
@property (strong, nonatomic) NSMutableArray *items;
@end
