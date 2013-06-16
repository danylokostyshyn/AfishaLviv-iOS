//
//  Place.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import "ALPlace.h"

#import "AfishaLvivFetcher.h"

@implementation ALPlace

+ (ALPlace *)placeWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo
{
    ALPlace *place = [[ALPlace alloc] init];
    place.title = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_TITLE];
    place.simage_url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_SIMAGEURL];
    place.place_type = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_TYPE];
    place.desc = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_DESCRIPTION];
    place.url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_URL];
    return place;
}

@end
