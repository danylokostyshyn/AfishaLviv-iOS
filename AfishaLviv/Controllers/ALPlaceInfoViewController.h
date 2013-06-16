//
//  PlaceInfoVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import "ALViewController.h"
#import <MapKit/MapKit.h>

@interface ALPlaceInfoViewController : ALViewController <UITableViewDataSource, UITableViewDelegate,
        UIWebViewDelegate, MKMapViewDelegate>
@property (strong, nonatomic) NSURL *placeInfoURL;
@end
