//
//  AfishaLvivFetcher.m
//  AfishaLviv
//
//  Created by Mac on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AfishaLvivFetcher.h"

@implementation AfishaLvivFetcher

+ (NSString *)afishaLvivDateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];  //2012-01-13
    return [dateFormat stringFromDate:date];
}

+ (NSArray *)eventsForDate:(NSDate *)date
{
    NSString *queryUrl = [NSString stringWithFormat:@"http://afishalvivparser.appspot.com/events?%@", [self afishaLvivDateStringFromDate:date]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryUrl]];
    
    NSError *error;
    NSArray *results = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) NSLog(@"%@", error);
    
    return results;
}

+ (NSDictionary *)eventInfoForEventUrl:(NSURL *)eventUrl
{
    NSString *queryUrl = [NSString stringWithFormat:@"http://afishalvivparser.appspot.com/event_info?%@", eventUrl];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryUrl]];
    
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) NSLog(@"%@", error);
    
    return results;
}

+ (NSArray *)placesForType:(PlaceType)placeType
{
    NSString *placeTypeString;
    
    switch (placeType) {
        case PlaceTypeRestaurant:
            placeTypeString = PLACE_TYPE_RESTAURANT;
            break;
        case PlaceTypeMuseum:
            placeTypeString = PLACE_TYPE_MUSEUM;
            break;
        case PlaceTypeGallery:
            placeTypeString = PLACE_TYPE_GALLERY;
            break;
        case PlaceTypeTheater:
            placeTypeString = PLACE_TYPE_THEATER;
            break;
        case PlaceTypeCinema:
            placeTypeString = PLACE_TYPE_CINEMA;
            break;
        case PlaceTypeClub:
            placeTypeString = PLACE_TYPE_CLUB;
            break;
        case PlaceTypeHall:
            placeTypeString = PLACE_TYPE_HALL;
            break;
        default:
            break;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://afishalvivparser.appspot.com/places?%@", placeTypeString]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    NSArray *results = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) NSLog(@"%@", error);
    
    return results;
}

+ (NSDictionary *)placeInfoForPlaceUrl:(NSURL *)placeUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@", placeUrl];
    NSString *queryUrl = [NSString stringWithFormat:@"http://afishalvivparser.appspot.com/place_info?%@", urlString];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryUrl]];
    
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) NSLog(@"%@", error);
    
    return result;
}

@end
