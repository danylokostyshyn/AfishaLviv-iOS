//
//  Place.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import "ALPlace.h"

#define AFISHALVIV_PLACE_DESCRIPTION            @"desc"
#define AFISHALVIV_PLACE_TYPE                   @"place_type"
#define AFISHALVIV_PLACE_SIMAGEURL              @"simage_url"
#define AFISHALVIV_PLACE_TITLE                  @"title"
#define AFISHALVIV_PLACE_URL                    @"url"

@implementation ALPlace

+ (ALPlace *)placeWithAfishaLvivInfo:(NSDictionary *)dictionary
{
    ALPlace *item = [[ALPlace alloc] init];
    item.title = [dictionary objectForKey:AFISHALVIV_PLACE_TITLE];
    item.simage_url = [dictionary objectForKey:AFISHALVIV_PLACE_SIMAGEURL];
    item.desc = [dictionary objectForKey:AFISHALVIV_PLACE_DESCRIPTION];
    item.url = [dictionary objectForKey:AFISHALVIV_PLACE_URL];
    
    NSString *itemTypeString = [dictionary objectForKey:AFISHALVIV_PLACE_TYPE];
    if ([itemTypeString isEqualToString:PLACE_TYPE_RESTAURANT]) item.place_type = ALPlaceTypeRestaurant;
    else if ([itemTypeString isEqualToString:PLACE_TYPE_MUSEUM]) item.place_type = ALPlaceTypeMuseum;
    else if ([itemTypeString isEqualToString:PLACE_TYPE_GALLERY]) item.place_type = ALPlaceTypeGallery;
    else if ([itemTypeString isEqualToString:PLACE_TYPE_THEATER]) item.place_type = ALPlaceTypeTheater;
    else if ([itemTypeString isEqualToString:PLACE_TYPE_CINEMA]) item.place_type = ALPlaceTypeCinema;
    else if ([itemTypeString isEqualToString:PLACE_TYPE_CLUB]) item.place_type = ALPlaceTypeClub;
    else if ([itemTypeString isEqualToString:PLACE_TYPE_HALL]) item.place_type = ALPlaceTypeHall;

    return item;
}

@end
