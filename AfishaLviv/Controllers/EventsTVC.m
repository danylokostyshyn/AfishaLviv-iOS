//
//  EventsTVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import <QuartzCore/QuartzCore.h>

#import "EventsTVC.h"

#import "AppDelegate.h"

#import "AfishaLvivFetcher.h"

#import "UIImageView+WebCache.h"

#import "MBProgressHUD.h"

#import "EventInfoTVC.h"

//models
#import "DataManager.h"

@interface EventsTVC ()

@property (strong, nonatomic) UILabel *noItemsLabel;
@property (strong, nonatomic) NSDate *currentDate; 
@property (strong, nonatomic) NSArray *items;

@end

@implementation EventsTVC

@synthesize eventCell = _eventCell;
@synthesize type = _type;
@synthesize noItemsLabel = _noItemsLabel;
@synthesize currentDate = _currentDate;
@synthesize items = _items;

#pragma mark -
#pragma mark Init

- (id)initWithEventType:(EventType)type
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.type = type;
    }
    return self;
}

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

- (void)setItems:(NSArray *)items
{
    _items = [NSArray arrayWithArray:items];
    
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];    
}

#pragma mark -
#pragma mark UI Actions

- (void)calendarButtonPressed
{
    DatePickerVC *datePickerVC = [[DatePickerVC alloc] init];
    datePickerVC.delegate = self;
    datePickerVC.datasource = self;
    
    [self.navigationController pushViewController:datePickerVC animated:YES];
}

#pragma mark -
#pragma mark Logic

- (void)downloadEventsForDate:(NSDate *)date
{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", @"Loading dialog string.");
    
    //save context. get events. if no events rollback context
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [delegate saveContext];
        [DataManager deleteEventsForDate:date inManagedContext:managedObjectContext];
        [DataManager fetchEventsForDate:date inToManagedObjectContext:managedObjectContext];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[DataManager eventsForDate:date inManagedObjectContext:managedObjectContext] count] != 0) {
                [delegate saveContext];
            } else {
                [delegate.managedObjectContext rollback];
            }
            
            self.items = [NSArray arrayWithArray:[DataManager eventsForDate:date type:self.type inManagedObjectContext:managedObjectContext]];
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

- (void)fetchEventsForDate:(NSDate *)date type:(EventType)type
{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    self.items = [NSArray arrayWithArray:[DataManager eventsForDate:date type:type inManagedObjectContext:managedObjectContext]];

    if ([self.items count] == 0) {
        [self downloadEventsForDate:date];
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar-icon.png"] 
                                                                              style:UIBarButtonItemStylePlain 
                                                                             target:self 
                                                                             action:@selector(calendarButtonPressed)];
    

    
    self.currentDate = [NSDate date];
    
    [self fetchEventsForDate:[NSDate date] type:self.type];
}

- (void)viewDidUnload
{
    [self setEventCell:nil];
    [super viewDidUnload];
    
    self.items = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.currentDate == nil) {
        self.title = NSLocalizedString(@"PickDateString_1", @"Pick a date title when no date selected.");
    } else {
        //set navigationbar title
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMMM, yyyy"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.title = [dateFormatter stringFromDate:self.currentDate];
    }
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
    if ([self.items count] == 0) {
        [self.view addSubview:self.noItemsLabel];
    } else {
        [self.noItemsLabel removeFromSuperview];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];

    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];        
        cell = self.eventCell;
        self.eventCell = nil;        
    }
    
    Event *event = [self.items objectAtIndex:indexPath.row];
    
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
    Event *event = [self.items objectAtIndex:indexPath.row];
    
    EventInfoTVC *eventInfoTVC = [[EventInfoTVC alloc] initWithEvent:event];
    eventInfoTVC.title = event.title;
    
    [self.navigationController pushViewController:eventInfoTVC animated:YES];    
    
    //must be after push, to provide datasoutce for eventinfovc
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 
#pragma mark DatePickerDelegate

- (void)datePicker:(DatePickerVC *)datePicker didSelectedDate:(NSDate *)date
{
    self.currentDate = date;
    [self fetchEventsForDate:date type:self.type];
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
    self.items = nil;
    self.currentDate = nil;

    [self.tableView reloadData];
}

@end
