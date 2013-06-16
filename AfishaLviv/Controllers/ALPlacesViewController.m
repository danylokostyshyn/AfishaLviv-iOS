//
//  PlacesTVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.04.12.

#import "ALPlacesViewController.h"

//models
#import "AfishaLvivFetcher.h"
#import "ALDataManager.h"
#import "ALPlace.h"

//views
#import "MBProgressHUD.h"

//controllers
#import "ALPlaceInfoViewController.h"

#import "ALHTTPClient.h"

@interface ALPlacesViewController ()
@property (strong, nonatomic) UITableViewCell *cell;
@property (strong, nonatomic) UILabel *noItemsLabel;
@property (strong, nonatomic) NSArray *items;
@end

@implementation ALPlacesViewController

- (UITableViewCell *)cell
{
    if (!_cell) {
        _cell = [[[NSBundle mainBundle] loadNibNamed:@"ALPlaceCell" owner:self options:nil] lastObject];
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
        _noItemsLabel.text = NSLocalizedString(@"No places found", @"No placess label.");
        
        _noItemsLabel.shadowColor = [UIColor whiteColor];
        _noItemsLabel.shadowOffset = CGSizeMake(0, 1);
        
        [self.view addSubview:_noItemsLabel];
    }
    return _noItemsLabel;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    switch (self.placeType) {
        case ALPlaceTypeCinema: self.title = NSLocalizedString(@"Cinema", @"PlacesTVC title cinema."); break;
        case ALPlaceTypeClub: self.title = NSLocalizedString(@"Clubs", @"PlacesTVC title clubs."); break;
        case ALPlaceTypeGallery: self.title = NSLocalizedString(@"Galleries", @"PlacesTVC title galleries."); break;
        case ALPlaceTypeHall: self.title = NSLocalizedString(@"Halls", @"PlacesTVC title halls."); break;
        case ALPlaceTypeMuseum: self.title = NSLocalizedString(@"Museums", @"PlacesTVC title museums."); break;
        case ALPlaceTypeRestaurant: self.title = NSLocalizedString(@"Restaurants", @"PlacesTVC title restaurants."); break;
        case ALPlaceTypeTheater: self.title = NSLocalizedString(@"Theaters", @"PlacesTVC title theaters."); break;
        default: self.title = @"O_o"; break;
    }      
    
    [self refreshPlaces];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)refreshPlaces
{
    [[ALHTTPClient sharedHTTPClient] placesOperationForType:self.placeType
                                                    success:^(AFHTTPRequestOperation *operation, NSArray *places) {
                                                        self.items = places;
                                                        [self.tableView reloadData];
                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"%@", error);
                                                    }];
}

#pragma mark - UITableViewDataSource

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
    static NSString *CellIdentifier = @"ALPlaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = self.cell;
        self.cell = nil;
    }
    
    ALPlace *place = [self.items objectAtIndex:indexPath.row];   
    
    ((UILabel *)[cell viewWithTag:2]).text = place.title;
    
    if ([place.desc isEqualToString:@"null"] == NO) {
        ((UILabel *)[cell viewWithTag:3]).text = place.desc;
    }
    
    [(UIImageView *)[cell viewWithTag:1] setImageWithURL:[NSURL URLWithString:place.simage_url]
                                        placeholderImage:[UIImage imageNamed:@"question-mark-small.png"]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALPlace *place = [self.items objectAtIndex:indexPath.row];   
    
    ALPlaceInfoViewController *placeInfoViewController = [ALPlaceInfoViewController controller];
    placeInfoViewController.placeInfoURL = [NSURL URLWithString:place.url];
    
    [self.navigationController pushViewController:placeInfoViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cell.bounds.size.height;
}

@end
