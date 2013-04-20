//
//  AfishaLvivFetcher.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 20.03.12.

#import <Foundation/Foundation.h>

//models
#import "DataManager.h"

#define AFISHALVIV_EVENT_DATE @"date"
#define AFISHALVIV_EVENT_DESCRIPTION @"desc"
#define AFISHALVIV_EVENT_TYPE @"event_type"
#define AFISHALVIV_EVENT_PLACEURL @"place_url"
#define AFISHALVIV_EVENT_PLACETITLE @"place_title"
#define AFISHALVIV_EVENT_SIMAGEURL @"simage_url"
#define AFISHALVIV_EVENT_TITLE @"title"
#define AFISHALVIV_EVENT_URL @"url"

#define AFISHALVIV_EVENTINFO_BIMAGEURL @"bimage_url"
#define AFISHALVIV_EVENTINFO_DATEINTERVAL @"date_interval"
#define AFISHALVIV_EVENTINFO_PLACEADDRESS @"place_address"
#define AFISHALVIV_EVENTINFO_PLACETITLE @"place_title"
#define AFISHALVIV_EVENTINFO_PLACEURL @"place_url"
#define AFISHALVIV_EVENTINFO_PRICE @"price"
#define AFISHALVIV_EVENTINFO_TEXT @"text"
#define AFISHALVIV_EVENTINFO_TITLE @"title"
#define AFISHALVIV_EVENTINFO_URL @"url"
#define AFISHALVIV_EVENTINFO_WORKTIME @"worktime"

#define EVENT_TYPE_CONCERT @"concert"
#define EVENT_TYPE_EXHIBITION @"exhibition"
#define EVENT_TYPE_PARTY @"party"
#define EVENT_TYPE_PERFORMANCE @"performance"
#define EVENT_TYPE_PRESENTATION @"presentation"
#define EVENT_TYPE_CINEMA @"cinema"

#define AFISHALVIV_PLACE_DESCRIPTION @"desc"
#define AFISHALVIV_PLACE_TYPE @"place_type"
#define AFISHALVIV_PLACE_SIMAGEURL @"simage_url"
#define AFISHALVIV_PLACE_TITLE @"title"
#define AFISHALVIV_PLACE_URL @"url"

#define AFISHALVIV_PLACEINFO_ADDRESS @"address"
#define AFISHALVIV_PLACEINFO_BIMAGEURL @"bimage_url"
#define AFISHALVIV_PLACEINFO_EMAIL @"email"
#define AFISHALVIV_PLACEINFO_GOOGLE_MAP @"googlemap"
#define AFISHALVIV_PLACEINFO_LOCATION @"location"
#define AFISHALVIV_PLACEINFO_PHONE @"phone"
#define AFISHALVIV_PLACEINFO_SCHEDULE @"schedule"
#define AFISHALVIV_PLACEINFO_TEXT @"text"
#define AFISHALVIV_PLACEINFO_TITLE @"title"
#define AFISHALVIV_PLACEINFO_URL @"url"
#define AFISHALVIV_PLACEINFO_WEBSITE @"website"

#define PLACE_TYPE_RESTAURANT @"restaurant"
#define PLACE_TYPE_MUSEUM @"museum"
#define PLACE_TYPE_GALLERY @"gallery"
#define PLACE_TYPE_THEATER @"theater"
#define PLACE_TYPE_CINEMA @"cinema"
#define PLACE_TYPE_CLUB @"club"
#define PLACE_TYPE_HALL @"hall"

@interface AfishaLvivFetcher : NSObject

+ (NSString *)afishaLvivDateStringFromDate:(NSDate *)date;
+ (NSArray *)eventsForDate:(NSDate *)date;
+ (NSDictionary *)eventInfoForEventUrl:(NSURL *)eventUrl;
+ (NSArray *)placesForType:(PlaceType)placeType;
+ (NSDictionary *)placeInfoForPlaceUrl:(NSURL *)placeUrl;

@end
