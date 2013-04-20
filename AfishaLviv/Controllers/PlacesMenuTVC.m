//
//  PlacesMenuTVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 16.04.12.

#import "PlacesMenuTVC.h"

#import "AfishaLvivFetcher.h"

#import "PlacesTVC.h"

//models
#import "DataManager.h"

@interface PlacesMenuTVC ()

@property (strong, nonatomic) NSArray *categoriesArray;
@property (nonatomic) PlaceType selectedType;

@end

@implementation PlacesMenuTVC

@synthesize categoriesArray = _categoriesArray;
@synthesize selectedType = _selectedType;

- (id)init
{
    self = [super init];
    if (self) {
        self = [self initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"PlacesString_1", @"PlacesMenuTVC title.");
        self.tabBarItem = [[UITabBarItem alloc] 
                           initWithTitle:NSLocalizedString(@"PlacesString_2", @"PlacesMenuTVC tab title.") 
                           image:[UIImage imageNamed:@"103-map.png"] 
                           tag:0]; 
    }
    return self;
}

#pragma mark -
#pragma mark Lazzy Init

- (NSArray *)categoriesArray
{
    if (_categoriesArray == nil) {
        _categoriesArray = [[NSArray alloc] initWithObjects:
                            [NSNumber numberWithInt:PlaceTypeCinema],
                            [NSNumber numberWithInt:PlaceTypeClub],
                            [NSNumber numberWithInt:PlaceTypeGallery],
                            [NSNumber numberWithInt:PlaceTypeHall],
                            [NSNumber numberWithInt:PlaceTypeMuseum],
                            [NSNumber numberWithInt:PlaceTypeRestaurant],                            
                            [NSNumber numberWithInt:PlaceTypeTheater], nil];
    }
    return _categoriesArray;
}

#pragma mark -
#pragma mark View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlacessMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case PlaceTypeCinema:
            cell.textLabel.text = NSLocalizedString(@"Cinema", @"Cinema place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"43-film-roll.png"];
            break;
            
        case PlaceTypeClub:
            cell.textLabel.text = NSLocalizedString(@"Clubs", @"Club place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"144-martini.png"];
            break;
            
        case PlaceTypeGallery:
            cell.textLabel.text = NSLocalizedString(@"Galleries", @"Gallery place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"121-landscape.png"];
            break;
            
        case PlaceTypeHall:
            cell.textLabel.text = NSLocalizedString(@"Halls", @"Hall place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"190-bank.png"];
            break;
            
        case PlaceTypeMuseum:
            cell.textLabel.text = NSLocalizedString(@"Museums", @"Museum place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"190-bank.png"];
            break;
            
        case PlaceTypeRestaurant:
            cell.textLabel.text = NSLocalizedString(@"Restaurants", @"Restaurant place category name to display.");
            cell.imageView.image = [UIImage imageNamed:@"34-coffee.png"];
            break;

        case PlaceTypeTheater:
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
    PlacesTVC *placesTVC;
    
    
    switch (indexPath.row) {
        case PlaceTypeCinema:
            placesTVC = [[PlacesTVC alloc] initWithPlaceType:PlaceTypeCinema];
            break;
            
        case PlaceTypeClub:
            placesTVC = [[PlacesTVC alloc] initWithPlaceType:PlaceTypeClub];
            break;
            
        case PlaceTypeGallery:
            placesTVC = [[PlacesTVC alloc] initWithPlaceType:PlaceTypeGallery];
            break;
            
        case PlaceTypeHall:
            placesTVC = [[PlacesTVC alloc] initWithPlaceType:PlaceTypeHall];
            break;
            
        case PlaceTypeMuseum:
            placesTVC = [[PlacesTVC alloc] initWithPlaceType:PlaceTypeMuseum];
            break;
            
        case PlaceTypeRestaurant:
            placesTVC = [[PlacesTVC alloc] initWithPlaceType:PlaceTypeRestaurant];
            break;

        case PlaceTypeTheater:
            placesTVC = [[PlacesTVC alloc] initWithPlaceType:PlaceTypeTheater];
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:placesTVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];    
}

@end
