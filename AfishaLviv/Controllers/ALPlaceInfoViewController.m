//
//  PlaceInfoVC.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import "ALPlaceInfoViewController.h"

#import <QuartzCore/QuartzCore.h>

//models
#import "DataManager.h"
#import "ALPlace.h"
#import "ALPlaceInfo.h"
#import "ALPlaceAnnotation.h"

//views
#import "MBProgressHUD.h"

#import "ALHTTPClient.h"

@interface ALPlaceInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ALPlaceInfo *placeInfo; 
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) MKMapView *mapView;
@end

@implementation ALPlaceInfoViewController

- (UIWebView *)webView
{
    if (_webView == nil) 
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 5, 290, 250)];
        _webView.delegate = self;
        
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
//        _webView.scrollView.scrollEnabled = NO;
        
        [_webView loadHTMLString:[self customHtmlFromHtmlString:self.placeInfo.text] baseURL:nil];
    }
    
    return _webView;
}

- (MKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] init];
        
        _mapView.delegate = self;
        _mapView.zoomEnabled = NO;
        
        if ([self.placeInfo.google_map_url isEqualToString:@"null"] == NO) 
        {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]*[0-9].[0-9]*[0-9]"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];

            NSArray *matches = [regex matchesInString:self.placeInfo.google_map_url
                                              options:0
                                                range:NSMakeRange(0, [self.placeInfo.google_map_url length])];
            
            NSNumber *latitude = [NSNumber numberWithDouble:[[self.placeInfo.google_map_url substringWithRange:[[matches objectAtIndex:0] rangeAtIndex:0]] doubleValue]];
            NSNumber *longtitude = [NSNumber numberWithDouble:[[self.placeInfo.google_map_url substringWithRange:[[matches objectAtIndex:1] rangeAtIndex:0]] doubleValue]];
            
            _mapView.frame = CGRectMake(10, 0, 300, 100);
            _mapView.layer.cornerRadius = 10.0;
            _mapView.layer.masksToBounds = YES;
            
            CLLocationCoordinate2D placeCoordinates = {[latitude doubleValue], [longtitude doubleValue]};
            MKCoordinateRegion coordinateRegion;
            
            coordinateRegion.center = placeCoordinates;
            coordinateRegion.span.longitudeDelta = 0.001f;
            coordinateRegion.span.latitudeDelta = 0.001f;
            
            [_mapView setRegion:coordinateRegion animated:YES]; 
            
            ALPlaceAnnotation *annotation = [[ALPlaceAnnotation alloc] initWithCoordinate:placeCoordinates title:nil subtitle:nil];
            [_mapView addAnnotation:annotation];                
        }        
        
    }
    return _mapView;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [[ALHTTPClient sharedHTTPClient] placeInfoFromURL:self.placeInfoURL
      success:^(AFHTTPRequestOperation *operation, ALPlaceInfo *placeInfo) {
        self.placeInfo = placeInfo;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark -
#pragma mark Table View Datasource

typedef enum {
    PlaceInfoCellStyleImageAndTitle,
    PlaceInfoCellStyleMap,
    PlaceInfoCellStyleText
} PlaceInfoCellStyle;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.placeInfo)
        return 0;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.placeInfo)
        return 0;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaceInfoCell";
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
    }
    
    switch (indexPath.section) {
        case PlaceInfoCellStyleImageAndTitle:		
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 10.f, 85.f, 115.f)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.layer.cornerRadius = 5.0;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderColor = [[UIColor blackColor] CGColor];
            imageView.layer.borderWidth = 1.0;
            
            [imageView setImageWithURL:[NSURL URLWithString:self.placeInfo.bimage_url]
                      placeholderImage:[UIImage imageNamed:@"question-mark-small.png"]];
            [cell addSubview:imageView];        
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            string = self.placeInfo.title;
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
            
            string = [NSString stringWithFormat:@"%@, %@", self.placeInfo.address, self.placeInfo.location];
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
            
        case PlaceInfoCellStyleMap:
            
            [cell addSubview:self.mapView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            break;            
            
        case PlaceInfoCellStyleText:
            
            [cell addSubview:self.webView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case PlaceInfoCellStyleImageAndTitle:
            return 133.0;
            
        case PlaceInfoCellStyleMap:
            return 100.0;
            
        case PlaceInfoCellStyleText:
            return self.webView.frame.size.height;
            
        default: return 0.0;
    }
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL isEqual:@"about:blank"])
        return NO;
    return YES;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[ALPlaceAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString * MyAnnotationIdentifier = @"PlaceAnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:MyAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:MyAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
//            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightButton addTarget:self
//                            action:@selector(showDetails:)
//                  forControlEvents:UIControlEventTouchUpInside];
//            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

@end
