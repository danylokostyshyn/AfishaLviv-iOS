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
#import "ALEvent.h"
#import "ALEventInfo.h"

//views
#import "MBProgressHUD.h"

//controllers
#import "ALEventInfoViewController.h"
#import "ALPlaceInfoViewController.h"

#import "ALHTTPClient.h"

@interface ALEventInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;;
@property (strong, nonatomic) ALEventInfo *eventInfo; 
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation ALEventInfoViewController

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 5, 290, 250)];
        _webView.delegate = self;
        
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
//        _webView.scrollView.scrollEnabled = NO;
        
        [_webView loadHTMLString:[self customHtmlFromHtmlString:self.eventInfo.text] baseURL:nil];
    }
    return _webView;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.event.title;
        
    [self refreshInfo];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

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

- (void)refreshInfo
{
    [[ALHTTPClient sharedHTTPClient] eventInfoFromURL:[NSURL URLWithString:self.event.url]
      success:^(AFHTTPRequestOperation *operation, ALEventInfo *eventInfo) {
          self.eventInfo = eventInfo;
          [self.tableView reloadData];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@", error);
      }];
}

#pragma mark - UITableViewDataSource

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *imageView;
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
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 10.f, 85.f, 115.f)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.layer.cornerRadius = 5.0;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderColor = [[UIColor blackColor] CGColor];
            imageView.layer.borderWidth = 1.0;
            
            [imageView setImageWithURL:[NSURL URLWithString:self.eventInfo.bimage_url]
                      placeholderImage:[UIImage imageNamed:@"question-mark-small.png"]];
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
            titleLabel.textAlignment = NSTextAlignmentCenter;
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
            titleLabel2.textAlignment = NSTextAlignmentCenter;
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
            titleLabel.textAlignment = NSTextAlignmentCenter;
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

#pragma mark - UITableViewDelegate

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case EventInfoCellStyleImageAndTitle: break;
        
        case EventInfoCellStylePlaceAddressAndTitle: {
            if ([self.eventInfo.place_title isEqualToString:@"null"] == NO) {

                ALPlaceInfoViewController *placeInfoViewController = [ALPlaceInfoViewController controller];
                placeInfoViewController.placeInfoURL = [NSURL URLWithString:self.eventInfo.place_url];
                [self.navigationController pushViewController:placeInfoViewController animated:YES];
            }
        } break;

        case EventInfoCellStyleText: break;
        
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIWebViewDelegate

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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL isEqual:@"about:blank"])
        return NO;
    return YES;
}

@end
