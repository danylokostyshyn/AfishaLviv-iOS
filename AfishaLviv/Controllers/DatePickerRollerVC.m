//
//  DatePickerRollerVC.m
//  AfishaLviv
//
//  Created by Mac on 22.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickerRollerVC.h"

@interface DatePickerRollerVC ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation DatePickerRollerVC

@synthesize delegate = _delegate;
@synthesize tableView = _tableView;
@synthesize datePicker = _datePicker;

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

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil)
    {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 320, 216)];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    return _datePicker;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DatePickerRollerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"armagedon";
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.title = NSLocalizedString(@"Date Picker", @"DatePickerRollerVC title.");
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.datePicker];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CancelBarButtonItemLabel_1", @"Cancel button title.")
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(cancelButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self 
                                                                                    action:@selector(doneButtonPressed)];    
    
    self.navigationItem.rightBarButtonItem = doneButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.tableView = nil;
    self.datePicker = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Actions

- (void)cancelButtonPressed
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonPressed
{
    [self.delegate datePicker:self didPickDate:[self.datePicker date]];
    [self.navigationController dismissModalViewControllerAnimated:YES];    
}

@end
