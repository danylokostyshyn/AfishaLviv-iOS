//
//  EventInfo.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 25.03.12.

#import "EventInfo.h"

#import "AfishaLvivFetcher.h"

@implementation EventInfo

@dynamic bimage_url;
@dynamic date_interval;
@dynamic place_url;
@dynamic price;
@dynamic text;
@dynamic title;
@dynamic url;
@dynamic worktime;
@dynamic place_title;
@dynamic place_address;

+ (EventInfo *)eventInfoWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo
                    inManagedObjectContext:(NSManagedObjectContext *)context
{
    EventInfo *eventInfo = [NSEntityDescription insertNewObjectForEntityForName:@"EventInfo"
                                                         inManagedObjectContext:context];
    
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
