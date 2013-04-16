//
//  Event.m
//  AfishaLviv
//
//  Created by Mac on 24.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
//#import "EventInfo.h"

#import "AfishaLvivFetcher.h"

@implementation Event

@dynamic date;
@dynamic desc;
@dynamic event_type;
@dynamic place_title;
@dynamic place_url;
@dynamic simage_url;
@dynamic title;
@dynamic url;

+ (Event *)eventWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo 
            inManagedObjectContext:(NSManagedObjectContext *)context
{
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" 
                                                 inManagedObjectContext:context];
    
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
