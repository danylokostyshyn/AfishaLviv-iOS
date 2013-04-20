//
//  Place.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import "Place.h"

#import "AfishaLvivFetcher.h"

@implementation Place

@dynamic desc;
@dynamic place_type;
@dynamic simage_url;
@dynamic title;
@dynamic url;

+ (Place *)placeWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo
            inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                                 inManagedObjectContext:context];
    
    place.title = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_TITLE];
    place.simage_url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_SIMAGEURL];
    place.place_type = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_TYPE];
    place.desc = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_DESCRIPTION];
    place.url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_URL];
    
    return place;
}

@end
