//
//  EventsMenuViewController.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.06.12.

#import "EventsMenuViewController.h"

//controlles
#import "EventsViewController.h"

@interface EventsMenuViewController ()

@end

@implementation EventsMenuViewController

@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"EventsString_1", @"EventsMenuTVC title");
        self.tabBarItem.title = NSLocalizedString(@"EventsString_2", @"EventsMenuTVC tab title");
        self.tabBarItem.image =  [UIImage imageNamed:@"191-collection.png"];
    }
    return self;
}

#pragma mark - View Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

#define kEventTypeConcert 0
#define kEventTypeExibition 1
#define kEventTypeCinema 2
#define kEventTypeParty 3
#define kEventTypePerformance 4
#define kEventTypePresentation 5

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventsMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case kEventTypeConcert: {
            cell.textLabel.text = NSLocalizedString(@"Concerts", @"Conert category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"153-guitar.png"];
            break;
        }
        case kEventTypeExibition: {
            cell.textLabel.text = NSLocalizedString(@"Exhibitions", @"Exhibition category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"41-picture-frame.png"];
            break;
        }
        case kEventTypeCinema: {
            cell.textLabel.text = NSLocalizedString(@"Films", @"Cinema category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"45-movie-1"];
            break;
        }
        case kEventTypeParty: {
            cell.textLabel.text = NSLocalizedString(@"Parties", @"Party category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"88-beer-mug.png"];
            break;
        }
        case kEventTypePerformance: {
            cell.textLabel.text = NSLocalizedString(@"Performances", @"Performance category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"124-bullhorn.png"];
            break;
        }
        case kEventTypePresentation: {
            cell.textLabel.text = NSLocalizedString(@"Presentations", @"Presentation category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"137-presentation.png"];
            break;
        }
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventsViewController *eventsViewController = [[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil];
    eventsViewController.managedObjectContext = self.managedObjectContext;
    eventsViewController.eventsType = indexPath.row;

    [self.navigationController pushViewController:eventsViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

@end
