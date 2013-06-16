//
//  EventsMenuViewController.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.06.12.

#import "ALEventsMenuViewController.h"

//controlles
#import "ALEventsViewController.h"

@interface ALEventsMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSDate *currentDate;
@end

@implementation ALEventsMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _items = [NSMutableArray array];
        self.title = NSLocalizedString(@"EventsString_1", @"EventsMenuTVC title");
        self.tabBarItem.title = NSLocalizedString(@"EventsString_2", @"EventsMenuTVC tab title");
        self.tabBarItem.image =  [UIImage imageNamed:@"191-collection.png"];
    }
    return self;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kALEventTypesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ALEventsMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case ALEventTypeConcert: {
            cell.textLabel.text = NSLocalizedString(@"Concerts", @"Conert category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"153-guitar.png"];
            break;
        }
        case ALEventTypeExibition: {
            cell.textLabel.text = NSLocalizedString(@"Exhibitions", @"Exhibition category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"41-picture-frame.png"];
            break;
        }
        case ALEventTypeCinema: {
            cell.textLabel.text = NSLocalizedString(@"Films", @"Cinema category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"45-movie-1"];
            break;
        }
        case ALEventTypeParty: {
            cell.textLabel.text = NSLocalizedString(@"Parties", @"Party category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"88-beer-mug.png"];
            break;
        }
        case ALEventTypePerformance: {
            cell.textLabel.text = NSLocalizedString(@"Performances", @"Performance category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"124-bullhorn.png"];
            break;
        }
        case ALEventTypePresentation: {
            cell.textLabel.text = NSLocalizedString(@"Presentations", @"Presentation category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"137-presentation.png"];
            break;
        }

        default: break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALEventsViewController *eventsViewController =
    [[ALEventsViewController alloc] initWithNibName:@"ALEventsViewController" bundle:nil];
    eventsViewController.eventsType = (ALEventType)indexPath.row;
    eventsViewController.items = self.items;
    eventsViewController.currentDate = self.currentDate;

    [self.navigationController pushViewController:eventsViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

@end
