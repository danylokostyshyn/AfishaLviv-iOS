//
//  PlaceInfoVC.h
//  AfishaLviv
//
//  Created by Mac on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PlaceInfoVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, MKMapViewDelegate>

- (id)initWithPlaceInfoUrl:(NSURL *)placeInfoUrl;

@end
