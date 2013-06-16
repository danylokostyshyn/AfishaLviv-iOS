//
//  SettingsVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import "SettingsVC.h"

//models
#import "DataManager.h"

@interface SettingsVC ()

@property (strong, nonatomic) UITableView *tableView;

- (void)deleteAllCachedImages;

@end

@implementation SettingsVC

@synthesize tableView = _tableView;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Init

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"SettingsString_1", @"SettingVC title.");
        self.tabBarItem = [[UITabBarItem alloc] 
                           initWithTitle:NSLocalizedString(@"SettingsString_2", @"SettingVC tab title.") 
                           image:[UIImage imageNamed:@"20-gear2.png"] 
                           tag:0];         
    }
    return self;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        CGFloat navigationControllerHeight = self.navigationController.navigationBarHidden ? 0 :
        self.navigationController.navigationBar.frame.size.height;
        
        CGRect tableViewRect = self.view.bounds;
        tableViewRect.size.height = tableViewRect.size.height - navigationControllerHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];  
    
    [self.view addSubview:self.tableView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    if (indexPath.row == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"Erase database", @"Erase database button title.");
    }
    
    if (indexPath.row == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"Delete all cached images", @"Delete cached images button title.");
    }
    
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    
    return cell;   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObjectContext *managedObjectContext = [ApplicationDelegate managedObjectContext];
    
    if (indexPath.row == 0)
    {
        [DataManager deleteAllEventsInManagedObjectContext:managedObjectContext];
        [DataManager deleteAllEventsInfosInManagedObjectContext:managedObjectContext];
        [DataManager deleteAllPlacesInfosInManagedObjectContext:managedObjectContext];
        [self.delegate performSelector:@selector(settingsViewControllerDidEraseDadabase:) withObject:self];
    }
    
    if (indexPath.row == 1)
    {
        [self deleteAllCachedImages];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (void)deleteAllCachedImages
{
   NSString *smallImagesFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/small_imgs/"];
   BOOL smallImagesFolderExists = [[NSFileManager defaultManager] fileExistsAtPath:smallImagesFolder];
   if (smallImagesFolderExists == NO) {
       return;
   }
   else {
       [[NSFileManager defaultManager] removeItemAtPath:smallImagesFolder error:nil];
   }
    
    NSString *imagesFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/big_imgs/"];
    BOOL imagesFolderExists = [[NSFileManager defaultManager] fileExistsAtPath:imagesFolder];
    if (imagesFolderExists == NO) {
        return;
    }
    else {
        [[NSFileManager defaultManager] removeItemAtPath:imagesFolder error:nil];
    }
}

@end
