//
//  EventInfo.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 25.03.12.

#import "ALEventInfo.h"

#define AFISHALVIV_EVENTINFO_BIMAGEURL          @"bimage_url"
#define AFISHALVIV_EVENTINFO_DATEINTERVAL       @"date_interval"
#define AFISHALVIV_EVENTINFO_PLACEADDRESS       @"place_address"
#define AFISHALVIV_EVENTINFO_PLACETITLE         @"place_title"
#define AFISHALVIV_EVENTINFO_PLACEURL           @"place_url"
#define AFISHALVIV_EVENTINFO_PRICE              @"price"
#define AFISHALVIV_EVENTINFO_TEXT               @"text"
#define AFISHALVIV_EVENTINFO_TITLE              @"title"
#define AFISHALVIV_EVENTINFO_URL                @"url"
#define AFISHALVIV_EVENTINFO_WORKTIME           @"worktime"

@implementation ALEventInfo

+ (ALEventInfo *)eventInfoWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo
{
    ALEventInfo *eventInfo = [[ALEventInfo alloc] init];
    eventInfo.bimage_url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_BIMAGEURL];
    eventInfo.date_interval = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_DATEINTERVAL];
    eventInfo.place_address = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_PLACEADDRESS];
    eventInfo.place_title = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_PLACETITLE];
    eventInfo.place_url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_PLACEURL];
    eventInfo.price = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_PRICE];
    eventInfo.text = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_TEXT];
    eventInfo.title = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_TITLE];
    eventInfo.url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_URL];
    eventInfo.worktime = [afishaLvivInfo objectForKey:AFISHALVIV_EVENTINFO_WORKTIME];
    return eventInfo;
}

@end
