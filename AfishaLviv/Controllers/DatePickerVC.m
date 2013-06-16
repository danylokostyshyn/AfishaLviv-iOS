//
//  DatePickerVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import "DatePickerVC.h"

#import "ALEventsViewController.h"

@interface DatePickerVC ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *datesArray;
@property (strong, nonatomic) NSDate *selectedDate;

- (BOOL)isDate:(NSDate *)firstDate equalTo:(NSDate *)secondDate;
- (void)uncheckAllCellsOnTableView:(UITableView *)tableView;

@end

@implementation DatePickerVC

@synthesize delegate = _delegate;
@synthesize datasource = _datasource;

@synthesize tableView = _tableView;
@synthesize datesArray = _datesArray;
@synthesize selectedDate = _selectedDate;

- (NSArray*)datesArray
{
    if (_datesArray == nil)
    {
        NSMutableArray *datesArray = [[NSMutableArray alloc] init];
        for (int day = 0; day < 7; day++) {
            [datesArray addObject:[NSDate dateWithTimeInterval:(60*60*24*day) sinceDate:[NSDate date]]];
        }
        _datesArray = [NSArray arrayWithArray:datesArray];
    }
    return _datesArray;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat navigationControllerHeight = self.navigationController.navigationBarHidden ? 0 :
        self.navigationController.navigationBar.frame.size.height;
        
        CGRect tableViewRect = self.view.bounds;
        int tabBarHeight = self.tabBarController.tabBar.bounds.size.height;
        tableViewRect.size.height = tableViewRect.size.height - navigationControllerHeight - tabBarHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - TableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return NSLocalizedString(@"Dates", @"CalendarVC table header for dates section.");
        case 1: return NSLocalizedString(@"Custom date", @"CalendarVC table header for custom date section.");
        default: return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; // 2 for datepicker
}

- (UITableViewCell *)pickDateCellForTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"PickDateCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = NSLocalizedString(@"PickDateLabelString", @"Pick date manually label.");
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: 
            return [self.datesArray count];
        case 1: 
            return 1;
        default: 
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        return [self pickDateCellForTableView:tableView];
    }
    
    static NSString *CellIdentifier = @"EventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]])
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"'%@', E, dd MMMM", NSLocalizedString(@"Today", @"Today prefix on calendar.")]];
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:0]])
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"'%@', E, dd MMMM", NSLocalizedString(@"Tomorrow", @"Tomorrow prefix on calendar.")]];
    else 
        [dateFormatter setDateFormat:@"EEEE, dd MMMM"];

    NSDate *currentDate = ((NSDate *)[self.datesArray objectAtIndex:indexPath.row]);
   
    cell.textLabel.text = [dateFormatter stringFromDate:currentDate];
    
    if ([self isDate:[self.datasource checkedDate] equalTo:currentDate]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]])  {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        DatePickerRollerVC *datePickerRollerVC = [[DatePickerRollerVC alloc] init];
        datePickerRollerVC.delegate = self;
        
        [self.navigationController presentModalViewController:
         [[UINavigationController alloc] initWithRootViewController:datePickerRollerVC] animated:YES];
        
        return;
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    self.selectedDate = ((NSDate *)[self.datesArray objectAtIndex:indexPath.row]);
    [self.delegate datePicker:self didSelectedDate:self.selectedDate];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"CalendarVCTitleString", @"CalendarVC title.");
   
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - 
#pragma mark DatePickerRollerDelegate

- (void)datePicker:(DatePickerRollerVC *)datePicker didPickDate:(NSDate *)date
{
    [self uncheckAllCellsOnTableView:self.tableView];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
   
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = [dateFormatter stringFromDate:date];
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectedDate = date;
    
    [self.delegate datePicker:self didSelectedDate:self.selectedDate];
    
//    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - 
#pragma mark UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

#pragma mark - 
#pragma mark Actions

- (BOOL)isDate:(NSDate *)firstDate equalTo:(NSDate *)secondDate
{
    //needs to camparing dates without time part
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    firstDate = [calendar dateFromComponents:[calendar components:flags fromDate:firstDate]];
    secondDate = [calendar dateFromComponents:[calendar components:flags fromDate:secondDate]];    
    
    if ([firstDate isEqualToDate:secondDate]) {
        return YES;
    }
    
    return  NO;
}

- (void)uncheckAllCellsOnTableView:(UITableView *)tableView
{
    for (int section = 0; section < [tableView numberOfSections]; section++) {
        for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
}

@end