//
//  PlacesTVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 17.04.12.

#import "PlacesTVC.h"

#import "AfishaLvivFetcher.h"

#import "AppDelegate.h"

#import "PlaceCell.h"
#import "PlaceInfoVC.h"

#import "MBProgressHUD.h"

//models
#import "Place.h"
#import "DataManager.h"

@interface PlacesTVC ()

@property (strong, nonatomic) UILabel *noItemsLabel;
@property (strong, nonatomic) NSArray *items;

@end

@implementation PlacesTVC
@synthesize noItemsLabel = _noItemsLabel;
@synthesize items = _items;
@synthesize placeType = _placeType;

- (id)initWithPlaceType:(PlaceType)type
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.placeType = type;
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
        _noItemsLabel.text = NSLocalizedString(@"No places found", @"No placess label.");
        
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
#pragma mark Logic

- (void)downloadPlacesForType:(PlaceType)type
{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", @"Loading dialog string.");
    
    //save context. get items. if no events rollback context
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [delegate saveContext];
        [DataManager deleteAllPlacesInManagedObjectContext:managedObjectContext];
        [DataManager fetchPlacesForType:self.placeType inToManagedObjectContext:managedObjectContext];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[DataManager placesForType:type inManagedObjectContext:managedObjectContext] count] != 0) { 
                [delegate saveContext];
            } else {
                [delegate.managedObjectContext rollback];
            }
            
            self.items = [NSArray arrayWithArray:[DataManager placesForType:self.placeType inManagedObjectContext:managedObjectContext]];
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

- (void)fetchPlacesForType:(PlaceType)type
{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    self.items = [NSArray arrayWithArray:[DataManager placesForType:type inManagedObjectContext:managedObjectContext]];
    
    if ([self.items count] == 0) {
        [self downloadPlacesForType:type];
    }
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    switch (self.placeType) {
        case PlaceTypeCinema:
            self.title = NSLocalizedString(@"Cinema", @"PlacesTVC title cinema.");
            break;
            
        case PlaceTypeClub:
            self.title = NSLocalizedString(@"Clubs", @"PlacesTVC title clubs.");
            break;
            
        case PlaceTypeGallery:
            self.title = NSLocalizedString(@"Galleries", @"PlacesTVC title galleries.");
            break;
            
        case PlaceTypeHall:
            self.title = NSLocalizedString(@"Halls", @"PlacesTVC title halls.");
            break;
            
        case PlaceTypeMuseum:
            self.title = NSLocalizedString(@"Museums", @"PlacesTVC title museums.");
            break;
            
        case PlaceTypeRestaurant:
            self.title = NSLocalizedString(@"Restaurants", @"PlacesTVC title restaurants.");
            break;
            
        case PlaceTypeTheater:
            self.title = NSLocalizedString(@"Theaters", @"PlacesTVC title theaters.");
            break;
            
        default:
            break;
    }      
    
    [self fetchPlacesForType:self.placeType];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.items = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0;
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
    static NSString *CellIdentifier = @"PlacesTVC_Cell";
    PlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Place *place = [self.items objectAtIndex:indexPath.row];   
    
    cell.titleLabel.text = place.title;
    
    if ([place.desc isEqualToString:@"null"] == NO)
        cell.descriptionLabel.text = place.desc;
    
    cell.dkImageView.imageUrl = [NSURL URLWithString:place.simage_url];
    
//    [cell addSubview:[DKImageView imageViewWithImageFromUrl:[NSURL URLWithString:place.simage_url] style:DKImageViewStyleSmall]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place *place = [self.items objectAtIndex:indexPath.row];   
    
    PlaceInfoVC *placesInfoVC = [[PlaceInfoVC alloc] initWithPlaceInfoUrl:[NSURL URLWithString:place.url]];
    placesInfoVC.title = place.title;
    
    [self.navigationController pushViewController:placesInfoVC animated:YES];    
    
    //must be after push, to provide datasoutce for eventinfovc
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];}

@end
