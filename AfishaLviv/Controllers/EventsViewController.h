//
//  EventsViewController.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Event+AfishaLviv.h"

#import "DatePickerVC.h"
#import "SettingsVC.h"

@interface EventsViewController : UITableViewController <DatePickerDatasource, DatePickerDelegate, SettingsDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSUInteger eventsType;

@property (strong, nonatomic) IBOutlet UITableViewCell *eventCell;

@end
