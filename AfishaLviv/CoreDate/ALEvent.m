//
//  Event.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 24.03.12.

#import "ALEvent.h"

#define AFISHALVIV_EVENT_DATE                   @"date"
#define AFISHALVIV_EVENT_DESCRIPTION            @"desc"
#define AFISHALVIV_EVENT_TYPE                   @"event_type"
#define AFISHALVIV_EVENT_PLACEURL               @"place_url"
#define AFISHALVIV_EVENT_PLACETITLE             @"place_title"
#define AFISHALVIV_EVENT_SIMAGEURL              @"simage_url"
#define AFISHALVIV_EVENT_TITLE                  @"title"
#define AFISHALVIV_EVENT_URL                    @"url"

@implementation ALEvent

+ (ALEvent *)eventWithAfishaLvivInfo:(NSDictionary *)dictionary
{
    ALEvent *item = [[ALEvent alloc] init];
    item.date = [dictionary objectForKey:AFISHALVIV_EVENT_DATE];
    item.desc = [dictionary objectForKey:AFISHALVIV_EVENT_DESCRIPTION];
    item.place_url = [dictionary objectForKey:AFISHALVIV_EVENT_PLACEURL];
    item.place_title = [dictionary objectForKey:AFISHALVIV_EVENT_PLACETITLE];
    item.simage_url = [dictionary objectForKey:AFISHALVIV_EVENT_SIMAGEURL];
    item.title = [dictionary objectForKey:AFISHALVIV_EVENT_TITLE];
    item.url = [dictionary objectForKey:AFISHALVIV_EVENT_URL];
    
    NSString *typeString = [dictionary objectForKey:AFISHALVIV_EVENT_TYPE];
    if ([typeString isEqualToString:EVENT_TYPE_CONCERT]) item.event_type = ALEventTypeConcert;
    else if ([typeString isEqualToString:EVENT_TYPE_EXHIBITION]) item.event_type = ALEventTypeExibition;
    else if ([typeString isEqualToString:EVENT_TYPE_PARTY]) item.event_type = ALEventTypeParty;
    else if ([typeString isEqualToString:EVENT_TYPE_PERFORMANCE]) item.event_type = ALEventTypePerformance;
    else if ([typeString isEqualToString:EVENT_TYPE_PRESENTATION]) item.event_type = ALEventTypePresentation;
    else if ([typeString isEqualToString:EVENT_TYPE_CINEMA]) item.event_type = ALEventTypeCinema;

    return item;
}

@end
