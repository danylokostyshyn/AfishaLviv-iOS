//
//  PlaceAnnotation.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import <MapKit/MapKit.h>

@interface ALPlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate 
                   title:(NSString *)title subtitle:(NSString *)subtitle;

@end