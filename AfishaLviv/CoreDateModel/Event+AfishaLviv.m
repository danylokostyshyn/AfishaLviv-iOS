//
//  Event+AfishaLviv.m
//  AfishaLviv
//
//  Created by Mac on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event+AfishaLviv.h"
#import "AfishaLvivFetcher.h"

@implementation Event (AfishaLviv)

//+ (Event *)eventWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo 
//            inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" 
//                                                 inManagedObjectContext:context];
//    
//    event.date = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_DATE];
//    event.desc = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_DESCRIPTION];
//    event.event_type = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_TYPE];
//    event.place_url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_PLACEURL];
//    event.place_title = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_PLACETITLE];    
//    event.simage_url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_SIMAGEURL];
//    event.title = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_TITLE];
//    event.url = [afishaLvivInfo objectForKey:AFISHALVIV_EVENT_URL];
//    
//    return event;
//}

+ (NSString *)afishaLvivStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormat stringFromDate:date];
}

+ (void)fetchEventsForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *events = [AfishaLvivFetcher eventsForDate:date];
    for (NSDictionary *eventsInfo in events) {
        [Event eventWithAfishaLvivInfo:eventsInfo inManagedObjectContext:context];
    }
}

+ (NSArray *)eventsForPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context
{
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    [request setPredicate:predicate];
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];  
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];  
    
    // Fetch the records and handle an error  
    NSError *error;  
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];   
    
    if (!mutableFetchResults) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }   
    
    // Save our fetched data to an array  
    return [[NSArray alloc] initWithArray:mutableFetchResults];
}

+ (NSArray *)eventsForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", [self afishaLvivStringFromDate:date]];
    return [self eventsForPredicate:predicate inManagedObjectContext:context];
} 

+ (NSArray *)eventsForDate:(NSDate *)date type:(EventType)type inManagedObjectContext:(NSManagedObjectContext *)context
{   
    NSString *eventsTypeString;
    
    switch (type) {
        case EventTypeConcert:
            eventsTypeString = EVENT_TYPE_CONCERT;
            break;
            
        case EventTypeExibition:    
            eventsTypeString = EVENT_TYPE_EXHIBITION;            
            break;
            
        case EventTypeParty:    
            eventsTypeString = EVENT_TYPE_PARTY;            
            break;
            
        case EventTypePerformance:    
            eventsTypeString = EVENT_TYPE_PERFORMANCE;            
            break;
            
        case EventTypePresentation:    
            eventsTypeString = EVENT_TYPE_PRESENTATION;            
            break;
            
        case EventTypeCinema:    
            eventsTypeString = EVENT_TYPE_CINEMA;            
            break;
            
        default:
            break;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@ AND event_type == %@", [self afishaLvivStringFromDate:date], eventsTypeString];
    return [self eventsForPredicate:predicate inManagedObjectContext:context];
} 

+ (void)deleteAllEventsInManagedObjectContext:(NSManagedObjectContext *)context
{
    for (Event *item in [self eventsForPredicate:nil inManagedObjectContext:context]) {
        [context deleteObject:item];
    }
}    

+ (void)deleteEventsForDate:(NSDate *)date inManagedContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", [self afishaLvivStringFromDate:date]];
    
    for (Event *item in [self eventsForPredicate:predicate inManagedObjectContext:context]) {
        [context deleteObject:item];
    }
}

@end
