//
//  PlaceInfoVC.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PlaceInfoVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, MKMapViewDelegate>

- (id)initWithPlaceInfoUrl:(NSURL *)placeInfoUrl;

@end
