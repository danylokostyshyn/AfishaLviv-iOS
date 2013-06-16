//
//  PlaceAnnotation.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import "ALPlaceAnnotation.h"

@implementation ALPlaceAnnotation 

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate 
                   title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}
@end
