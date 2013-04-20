//
//  EventsViewController.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.06.12.

#import "EventsViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "AfishaLvivFetcher.h"
#import "Event.h"

#import "UIImageView+WebCache.h"

#import "MBProgressHUD.h"

#import "EventInfoTVC.h"

@interface EventsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UILabel *noItemsLabel;
@property (strong, nonatomic) UIBarButtonItem *calendarBarButton;
@property (strong, nonatomic) NSDate *currentDate; 

@end

@implementation EventsViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

@synthesize eventCell = _eventCell;
@synthesize noItemsLabel = _noItemsLabel;
@synthesize eventsType = _eventsType;
@synthesize calendarBarButton = _calendarBarButton;
@synthesize currentDate = _currentDate;

#pragma mark - Init

- (UILabel *)noItemsLabel
{
    if (_noItemsLabel == nil) {
        _noItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 30)];
        _noItemsLabel.backgroundColor = [UIColor clearColor];
        _noItemsLabel.textColor = [UIColor grayColor];
        _noItemsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        _noItemsLabel.textAlignment = UITextAlignmentCenter;
        _noItemsLabel.text = NSLocalizedString(@"No events found", @"No events label.");
        
        _noItemsLabel.shadowColor = [UIColor whiteColor];
        _noItemsLabel.shadowOffset = CGSizeMake(0, 1);
        
        [self.view addSubview:_noItemsLabel];
    }
    return _noItemsLabel;
}

- (NSDate *)currentDate
{
    if (_currentDate == nil) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    if (_currentDate != currentDate) {
        _currentDate = currentDate;
        
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }  
        
        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];           
    }
}

#define kEventTypeConcert 0
#define kEventTypeExibition 1
#define kEventTypeCinema 2
#define kEventTypeParty 3
#define kEventTypePerformance 4
#define kEventTypePresentation 5

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];

    NSString *eventTypeString;
    switch (self.eventsType) {
        case kEventTypeConcert:
            eventTypeString = EVENT_TYPE_CONCERT;
            break;
        case kEventTypeExibition:
            eventTypeString = EVENT_TYPE_EXHIBITION;
            break;            
        case kEventTypeCinema:
            eventTypeString = EVENT_TYPE_CINEMA;
            break;                        
        case kEventTypeParty:
            eventTypeString = EVENT_TYPE_PARTY;
            break;                      
        case kEventTypePerformance:
            eventTypeString = EVENT_TYPE_PERFORMANCE;
            break;                                  
        case kEventTypePresentation:
            eventTypeString = EVENT_TYPE_PRESENTATION;
            break;                                  
        default:
            break;
    }
    
    NSString *dateString = [AfishaLvivFetcher afishaLvivDateStringFromDate:self.currentDate];
//    NSLog(@"%@", dateString);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_type == %@ AND date == %@", eventTypeString, dateString];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_type == %@", eventTypeString];    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (UIBarButtonItem *)calendarBarButton {
    if (_calendarBarButton == nil) {
        _calendarBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar-icon.png"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(calendarButtonPressed)];
    }
    return _calendarBarButton;
}

#pragma mark - Actions

- (void)calendarButtonPressed
{
    DatePickerVC *datePickerVC = [[DatePickerVC alloc] init];
    datePickerVC.delegate = self;
    datePickerVC.datasource = self;
    
    [self.navigationController pushViewController:datePickerVC animated:YES];
}

#pragma mark - Logic

- (void)downloadEventsForDate:(NSDate *)date
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	hud.labelText = NSLocalizedString(@"Loading", @"Loading");
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		NSArray *itemsArray = [AfishaLvivFetcher eventsForDate:date];
        if (itemsArray != nil) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
            NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            for (id object in result) {
                [self.managedObjectContext deleteObject:object];
            }
            
            for (NSDictionary *dictionary in itemsArray) {
                [Event eventWithAfishaLvivInfo:dictionary inManagedObjectContext:self.managedObjectContext];
            }
            
            NSError *error;
            [self.managedObjectContext save:&error];
        }        
        
		dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedResultsController = nil;
            
            NSError *error;
            if (![[self fetchedResultsController] performFetch:&error]) {
                // Update to handle the error appropriately.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);  // Fail
            }    
            
            [self.tableView reloadData];
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
			[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
		});
	});    
}

#pragma mark - View Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM, yyyy"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.title = [dateFormatter stringFromDate:self.currentDate];    
    
    [self downloadEventsForDate:self.currentDate];
    
//    NSError *error;
//	if (![[self fetchedResultsController] performFetch:&error]) {
//		// Update to handle the error appropriately.
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//	}    
//    
    self.navigationItem.rightBarButtonItem = self.calendarBarButton;
}

- (void)viewDidUnload
{
    self.managedObjectContext = nil;
    self.fetchedResultsController = nil;    
    self.calendarBarButton = nil;
    [self setEventCell:nil];
    [self setNoItemsLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];

//    if (self.currentDate == nil) {
//        self.title = NSLocalizedString(@"PickDateString_1", @"Pick a date title when no date selected.");
//    } else {
//        //set navigationbar title
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"d MMMM, yyyy"];
//        [dateFormatter setLocale:[NSLocale currentLocale]];
//        self.title = [dateFormatter stringFromDate:self.currentDate];
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];        
    return self.eventCell.bounds.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    if ([sectionInfo numberOfObjects] == 0) {
        [self.view addSubview:self.noItemsLabel];
    } else {
        [self.noItemsLabel removeFromSuperview];
    }    
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];        
        cell = self.eventCell;
        self.eventCell = nil;        
    }
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:2];
    label.text = event.title;
    
    if ([event.desc isEqualToString:@"null"] == NO) {
        label = (UILabel *)[cell viewWithTag:3];
        label.text = event.desc;
    } 
    
    if ([event.place_title isEqualToString:@"null"] == NO) {
        label = (UILabel *)[cell viewWithTag:4];
        label.text = event.place_title;
    } 
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    [imageView setImageWithURL:[NSURL URLWithString:event.simage_url] 
              placeholderImage:[UIImage imageNamed:@"question-mark-small.png"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    EventInfoTVC *eventInfoTVC = [[EventInfoTVC alloc] initWithEvent:event];
    eventInfoTVC.title = event.title;
    
    [self.navigationController pushViewController:eventInfoTVC animated:YES];    
}

#pragma mark - NSFetchedRequestControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
     
}

#pragma mark - 
#pragma mark DatePickerDelegate

- (void)datePicker:(DatePickerVC *)datePicker didSelectedDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM, yyyy"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.title = [dateFormatter stringFromDate:date];

    self.currentDate = date;

    [self downloadEventsForDate:date];
}

#pragma mark - 
#pragma mark DatePickerDatasource

- (NSDate *)checkedDate
{
    return self.currentDate;
}

#pragma mark - 
#pragma mark SettingsDelegate

- (void)settingsViewControllerDidEraseDadabase:(SettingsVC *)settingsVC
{
    self.currentDate = nil;
    [self.tableView reloadData];
}

@end
