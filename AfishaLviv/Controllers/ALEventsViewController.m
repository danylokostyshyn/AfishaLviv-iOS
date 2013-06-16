//
//  EventsViewController.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.06.12.

#import "ALEventsViewController.h"

#import <QuartzCore/QuartzCore.h>

//models
#import "AfishaLvivFetcher.h"
#import "ALEvent.h"

//views
#import "MBProgressHUD.h"

//controllers
#import "ALEventInfoViewController.h"

#import "ALHTTPClient.h"

@interface ALEventsViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *cell;
@property (strong, nonatomic) UILabel *noItemsLabel;
@property (strong, nonatomic) UIBarButtonItem *calendarBarButton;
@property (strong, nonatomic) NSDate *currentDate; 
@end

@implementation ALEventsViewController

- (UITableViewCell *)cell
{
    if (!_cell) {
        _cell = [[[NSBundle mainBundle] loadNibNamed:@"ALEventCell" owner:self options:nil] lastObject];
    }
    return _cell;
}

- (UILabel *)noItemsLabel
{
    if (_noItemsLabel == nil) {
        _noItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 30)];
        _noItemsLabel.backgroundColor = [UIColor clearColor];
        _noItemsLabel.textColor = [UIColor grayColor];
        _noItemsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        _noItemsLabel.textAlignment = NSTextAlignmentCenter;
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

#define kEventTypeConcert       0
#define kEventTypeExibition     1
#define kEventTypeCinema        2
#define kEventTypeParty         3
#define kEventTypePerformance   4
#define kEventTypePresentation  5

- (UIBarButtonItem *)calendarBarButton
{
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

}

#pragma mark - Logic

- (void)refreshEvents
{
    [[ALHTTPClient sharedHTTPClient] eventsOperationForDate:self.currentDate
                                                    success:^(AFHTTPRequestOperation *operation, NSArray *events) {
                                                        self.items = [events mutableCopy];
                                                        [self.tableView reloadData];                                                        
                                                        [self.refreshControl endRefreshing];
                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        [self.refreshControl endRefreshing];                                                        
                                                        NSLog(@"%@", error);
                                                    }];
    
}

#pragma mark - View Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = self.calendarBarButton;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM, yyyy"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.title = [dateFormatter stringFromDate:self.currentDate];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshEvents)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.items.count == 0) {
        [self refreshEvents];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger itemsCount = [self.items count];
    if (itemsCount == 0) {
        [self.view addSubview:self.noItemsLabel];
    } else {
        [self.noItemsLabel removeFromSuperview];
    }    
    return itemsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ALEventCell"];
    
    if (cell == nil) {
        cell = self.cell;
        self.cell = nil;
    }
    
    ALEvent *event = [self.items objectAtIndex:indexPath.row];
    
    ((UILabel *)[cell viewWithTag:2]).text = event.title;
    
    if ([event.desc isEqualToString:@"null"] == NO) {
        ((UILabel *)[cell viewWithTag:3]).text = event.desc;
    } 
    
    if ([event.place_title isEqualToString:@"null"] == NO) {
        ((UILabel *)[cell viewWithTag:4]).text = event.place_title;
    }
    
    [(UIImageView *)[cell viewWithTag:1] setImageWithURL:[NSURL URLWithString:event.simage_url]
                                        placeholderImage:[UIImage imageNamed:@"question-mark-small.png"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALEvent *event = [self.items objectAtIndex:indexPath.row];
    
    ALEventInfoViewController *eventInfoViewController = [ALEventInfoViewController controller];
    eventInfoViewController.event = event;

    [self.navigationController pushViewController:eventInfoViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cell.bounds.size.height;
}

@end