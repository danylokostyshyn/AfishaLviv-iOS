//
//  PlacesMenuTVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 16.04.12.

#import "ALPlacesMenuViewController.h"

//models

//controllers
#import "ALPlacesViewController.h"

@interface ALPlacesMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ALPlaceType selectedType;
@end

@implementation ALPlacesMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"PlacesString_1", @"PlacesMenuTVC title.");
        self.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:NSLocalizedString(@"PlacesString_2", @"PlacesMenuTVC tab title.")
                           image:[UIImage imageNamed:@"103-map.png"] tag:0];
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
    return kALPlaceTypesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlacessMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case ALPlaceTypeCinema:
            cell.textLabel.text = NSLocalizedString(@"Cinema", @"Cinema place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"43-film-roll.png"];
            break;
            
        case ALPlaceTypeClub:
            cell.textLabel.text = NSLocalizedString(@"Clubs", @"Club place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"144-martini.png"];
            break;
            
        case ALPlaceTypeGallery:
            cell.textLabel.text = NSLocalizedString(@"Galleries", @"Gallery place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"121-landscape.png"];
            break;
            
        case ALPlaceTypeHall:
            cell.textLabel.text = NSLocalizedString(@"Halls", @"Hall place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"190-bank.png"];
            break;
            
        case ALPlaceTypeMuseum:
            cell.textLabel.text = NSLocalizedString(@"Museums", @"Museum place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"190-bank.png"];
            break;
            
        case ALPlaceTypeRestaurant:
            cell.textLabel.text = NSLocalizedString(@"Restaurants", @"Restaurant place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"34-coffee.png"];
            break;

        case ALPlaceTypeTheater:
            cell.textLabel.text = NSLocalizedString(@"Theaters", @"Theater place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"124-bullhorn.png"];
            break;
            
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALPlacesViewController *placesViewController =
    [[ALPlacesViewController alloc] initWithNibName:@"ALPlacesViewController" bundle:nil];
    placesViewController.placeType = (ALPlaceType)indexPath.row;
    
    [self.navigationController pushViewController:placesViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];    
}

@end
