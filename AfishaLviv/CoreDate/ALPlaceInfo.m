//
//  PlaceInfo.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import "ALPlaceInfo.h"

#define AFISHALVIV_PLACEINFO_ADDRESS            @"address"
#define AFISHALVIV_PLACEINFO_BIMAGEURL          @"bimage_url"
#define AFISHALVIV_PLACEINFO_EMAIL              @"email"
#define AFISHALVIV_PLACEINFO_GOOGLE_MAP         @"googlemap"
#define AFISHALVIV_PLACEINFO_LOCATION           @"location"
#define AFISHALVIV_PLACEINFO_PHONE              @"phone"
#define AFISHALVIV_PLACEINFO_SCHEDULE           @"schedule"
#define AFISHALVIV_PLACEINFO_TEXT               @"text"
#define AFISHALVIV_PLACEINFO_TITLE              @"title"
#define AFISHALVIV_PLACEINFO_URL                @"url"
#define AFISHALVIV_PLACEINFO_WEBSITE            @"website"

@implementation ALPlaceInfo

+ (ALPlaceInfo *)placeInfoWithAfishaLvivInfo:(NSDictionary *)dictionary
{
    ALPlaceInfo *item = [[ALPlaceInfo alloc] init];
    item.address = [dictionary objectForKey:AFISHALVIV_PLACEINFO_ADDRESS];
    item.bimage_url = [dictionary objectForKey:AFISHALVIV_PLACEINFO_BIMAGEURL];
    item.email = [dictionary objectForKey:AFISHALVIV_PLACEINFO_EMAIL];
    item.google_map_url = [dictionary objectForKey:AFISHALVIV_PLACEINFO_GOOGLE_MAP];
    item.location = [dictionary objectForKey:AFISHALVIV_PLACEINFO_LOCATION];
    item.phone = [dictionary objectForKey:AFISHALVIV_PLACEINFO_PHONE];
    item.schedule = [dictionary objectForKey:AFISHALVIV_PLACEINFO_SCHEDULE];
    item.text = [dictionary objectForKey:AFISHALVIV_PLACEINFO_TEXT];
    item.title = [dictionary objectForKey:AFISHALVIV_PLACEINFO_TITLE];
    item.url = [dictionary objectForKey:AFISHALVIV_PLACEINFO_URL];
    item.website = [dictionary objectForKey:AFISHALVIV_PLACEINFO_WEBSITE];
    return item;
}

@end
