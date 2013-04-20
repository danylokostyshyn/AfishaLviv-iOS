//
//  EventInfoTVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 27.03.12.

#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <EventKit/EventKit.h>

//models
#import "AfishaLvivFetcher.h"
#import "Event.h"
#import "EventInfo.h"
#import "AppDelegate.h"

//views
#import "DKImageView.h"
#import "MBProgressHUD.h"

//controllers
#import "EventInfoTVC.h"
#import "PlaceInfoVC.h"

@interface EventInfoTVC ()

@property (strong, nonatomic) UITableView *tableView;;
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) EventInfo *eventInfo; 
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation EventInfoTVC

@synthesize tableView = _tableView;
@synthesize event = _event;
@synthesize eventInfo = _eventInfo;
@synthesize webView = _webView;
@synthesize actionSheet = _actionSheet;

#pragma mark - Init

- (id)initWithEvent:(Event *)event
{
    self = [super init];
    if (self) {
        self.event = event;
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
        int tabBarHeight = self.tabBarController.tabBar.bounds.size.height;
        tableViewRect.size.height = tableViewRect.size.height - navigationControllerHeight - tabBarHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:tableViewRect  style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIWebView *)webView
{
    if (_webView == nil) 
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 5, 290, 250)];
        _webView.delegate = self;
        
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
//        _webView.scrollView.scrollEnabled = NO;
        
        [_webView loadHTMLString:[self customHtmlFromHtmlString:self.eventInfo.text] baseURL:nil];
    }
    
    return _webView;
}

- (UIActionSheet *)actionSheet
{
    if (_actionSheet == nil) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select action", @"Action menu title.")
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Action menu cancel button title.")
                                     destructiveButtonTitle:nil 
                                          otherButtonTitles://NSLocalizedString(@"Tweet", @"Action menu tweet button title."), 
                        NSLocalizedString(@"Open in Safari", @"Action menu open in safari button title."), 
                        NSLocalizedString(@"Add to calendar", @"Action menu add to calendar button title."), nil];
    }
    return _actionSheet;
}

#pragma mark -
#pragma mark Logic

- (NSString *)customHtmlFromHtmlString:(NSString *)content
{
    return [NSString stringWithFormat:@"<html> \n"
            "<head> \n"
            "<style type=\"text/css\"> \n"
            "body {font-family: \"%@\"; font-size: %@;}\n"
            "</style> \n"
            "</head> \n"
            "<body>%@</body> \n"
            "</html>", @"helvetica", [NSNumber numberWithInt:14], content];
}

- (void)downloadEventInfoFromUrl:(NSURL *)url
{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", @"Loading dialog string.");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

        [DataManager fetchEventsInfosForUrl:url inToManagedObjectContext:managedObjectContext];
        [delegate saveContext];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.eventInfo = [DataManager eventInfoForUniqueUrl:url inManagedObjectContext:managedObjectContext];

            [self.tableView reloadData];
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

- (void)actionButtonPressed
{
    [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

enum {
//    kTweetButton = 0,
    kSafariButton = 0,
    kCalendarButton = 1
};

- (void)composeTweet
{
    // Create the view controller
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    // Optional: set an image, url and initial text
//    [twitter addImage:[UIImage imageNamed:@"iOSDevTips.png"]];
    [twitter addURL:[NSURL URLWithString:self.eventInfo.url]];
    [twitter setInitialText:[NSString stringWithFormat:@"%@\n%@",self.eventInfo.title, self.eventInfo.date_interval]];
    
    // Show the controller
    [self presentModalViewController:twitter animated:YES];
    
    // Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
//        NSString *title = @"Tweet Status";
//        NSString *msg; 
//        
//        if (result == TWTweetComposeViewControllerResultCancelled)
//            msg = @"Tweet compostion was canceled.";
//        else if (result == TWTweetComposeViewControllerResultDone)
//            msg = @"Tweet composition completed.";
//        
//        // Show alert to see how things went...
//        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//        [alertView show];
        
        // Dismiss the controller
        [self dismissModalViewControllerAnimated:YES];
    };    
}

- (void)createEventInCalendar
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];

    event.title = self.eventInfo.title;
    event.startDate = [NSDate date];
    event.endDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:[NSDate date]];
    
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	
	// set the addController's event store to the current event store.
	addController.eventStore = eventStore;
    addController.event = event;
	
    addController.editViewDelegate = self;
    addController.navigationBar.barStyle = UIBarStyleBlack;
    
	// present EventsAddViewController as a modal view controller
	[self presentModalViewController:addController animated:YES];    
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
//        case kTweetButton:
//            [self composeTweet];
//            break;
        case kSafariButton:
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.eventInfo.url]];
            break;
        case kCalendarButton:
            [self createEventInCalendar];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark View Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                                                                                  target:self 
                                                                                  action:@selector(actionButtonPressed)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    self.eventInfo = [DataManager eventInfoForUniqueUrl:[NSURL URLWithString:self.event.url] inManagedObjectContext:managedObjectContext];
    
    if (self.eventInfo == nil) {
        [self downloadEventInfoFromUrl:[NSURL URLWithString:self.event.url]];
    } 
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

typedef enum {
    EventInfoCellStyleImageAndTitle,
    EventInfoCellStylePlaceAddressAndTitle,
    EventInfoCellStyleText,
} EventInfoCellStyle;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.eventInfo == nil) 
        return 0;
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.eventInfo == nil) 
        return 0;
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeToFit;
    NSString *string;
    UIFont *font;
    
    switch (indexPath.section) {
        case EventInfoCellStyleImageAndTitle:
            return 133.0;
            
        case EventInfoCellStylePlaceAddressAndTitle:
            
            string = [NSString stringWithFormat:@"%@, \n%@", self.eventInfo.place_title, self.eventInfo.place_address];
            
            //if one of strings "null"
            string = [string stringByReplacingOccurrencesOfString:@"null, \n" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@", \nnull" withString:@""];
            
            font = [UIFont fontWithName:@"Helvetica" size:14];
            
            sizeToFit = [string sizeWithFont:font constrainedToSize:CGSizeMake(250, MAXFLOAT)];    
            return sizeToFit.height + 10;  
            
        case EventInfoCellStyleText:
            return self.webView.frame.size.height + 5;
            
        default:
            return 0.0;            
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DKImageView *imageView;
    UILabel *titleLabel;
    UILabel *titleLabel2; 
    CGRect frame;
    CGSize sizeToFit;
    
    UIFont *font;
    NSString *string;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel2 = [[UILabel alloc] init]; 

        [cell addSubview:titleLabel];
        [cell addSubview:titleLabel2];
        [cell addSubview:self.webView];
    }
    
    switch (indexPath.section) {
        case EventInfoCellStyleImageAndTitle:

            imageView = [[DKImageView alloc] initWithImageFromUrl:[NSURL URLWithString:self.eventInfo.bimage_url] style:DKImageViewStyleBig];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.layer.cornerRadius = 5.0;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderColor = [[UIColor blackColor] CGColor];
            imageView.layer.borderWidth = 1.0;
            [cell addSubview:imageView];        
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            string = self.eventInfo.title;
            font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            
            sizeToFit = [string sizeWithFont:font constrainedToSize:CGSizeMake(190, MAXFLOAT)];   
            
            frame = CGRectMake(110, 15, 190, sizeToFit.height);
            titleLabel.frame = frame;
            titleLabel.backgroundColor = [UIColor clearColor];
            
            titleLabel.text = string;
            titleLabel.font = font;
            titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            string = [NSString stringWithFormat:@"%@, %@, \n%@", self.eventInfo.date_interval, self.eventInfo.worktime, self.eventInfo.price];
            string = [string stringByReplacingOccurrencesOfString:@", \nnull" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@", null" withString:@""];
            
            font = [UIFont fontWithName:@"Helvetica" size:12];
            
            sizeToFit = [string sizeWithFont:font constrainedToSize:CGSizeMake(190, MAXFLOAT)];            
            
            frame = CGRectMake(110, frame.origin.y + frame.size.height + 15, 190, sizeToFit.height);
            titleLabel2.frame = frame;
            titleLabel2.backgroundColor = [UIColor clearColor];
            
            titleLabel2.text = string;
            titleLabel2.font = font;
            titleLabel2.textAlignment = UITextAlignmentCenter;
            titleLabel2.numberOfLines = 0;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        case EventInfoCellStylePlaceAddressAndTitle:
            
            string = [NSString stringWithFormat:@"%@, \n%@", self.eventInfo.place_title, self.eventInfo.place_address];
            
            //if one of strings "null"
            string = [string stringByReplacingOccurrencesOfString:@"null, \n" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@", \nnull" withString:@""];
            
            font = [UIFont fontWithName:@"Helvetica" size:14];
            
            sizeToFit = [string sizeWithFont:font constrainedToSize:CGSizeMake(250, MAXFLOAT)];            
            
            frame = CGRectMake(35, 5, 250, sizeToFit.height);
            titleLabel.frame = frame;
            titleLabel.backgroundColor = [UIColor clearColor];
            
            titleLabel.text = string;
            titleLabel.font = font;
            titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            
            if ([self.eventInfo.place_title isEqualToString:@"null"] == NO)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
            break;
        case EventInfoCellStyleText:
//            [cell addSubview:self.webView];  
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)showPlaceInfo
{
    PlaceInfoVC *placeInfoVC = [[PlaceInfoVC alloc] initWithPlaceInfoUrl:[NSURL URLWithString:self.eventInfo.place_url]];
    if ([self.eventInfo.place_title isEqualToString:@"null"] == NO) {
        placeInfoVC.title = self.eventInfo.place_title;
    } else {
        placeInfoVC.title = self.eventInfo.place_address;
    }
    
    [self.navigationController pushViewController:placeInfoVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case EventInfoCellStyleImageAndTitle:
            break;
        case EventInfoCellStylePlaceAddressAndTitle:
            if ([self.eventInfo.place_title isEqualToString:@"null"] == NO) {
                [self showPlaceInfo];                    
            }

            break;
        case EventInfoCellStyleText:
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)aWebView 
{
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    [self.tableView reloadData];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL isEqual:@"about:blank"])
        return NO;
    return YES;
}

@end
