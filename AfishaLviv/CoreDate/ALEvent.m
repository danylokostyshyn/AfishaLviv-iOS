//
//  Event.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 24.03.12.

#import "ALEvent.h"

#import "AfishaLvivFetcher.h"

@implementation ALEvent

+ (ALEvent *)eventWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo
{
    ALEvent *event = [[ALEvent alloc] init];
    event.date = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_DATE];
    event.desc = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_DESCRIPTION];
    event.event_type = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_TYPE];
    event.place_url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_PLACEURL];
    event.place_title = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_PLACETITLE];    
    event.simage_url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_SIMAGEURL];
    event.title = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_TITLE];
    event.url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_URL];
    return event;
}

@end
