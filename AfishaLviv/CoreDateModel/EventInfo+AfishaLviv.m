//
//  EventInfo+AfishaLviv.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 22.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventInfo+AfishaLviv.h"

#import "AfishaLvivFetcher.h"

@implementation EventInfo (AfishaLviv)

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

+ (void)fetchEventInfoForUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSDictionary *eventsInfo = [AfishaLvivFetcher eventInfoForEventUrl:url];
    [EventInfo eventInfoWithAfishaLvivInfo:eventsInfo inManagedObjectContext:context];
}

+ (NSArray *)eventInfoForPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context
{
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventInfo" inManagedObjectContext:context];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    [request setPredicate:predicate];
    
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

+ (NSArray *)eventInfoForUniqueUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
    return [self eventInfoForPredicate:predicate inManagedObjectContext:context];
}

+ (void)deleteAllEventInfosInManagedObjectContext:(NSManagedObjectContext *)context
{
    for (EventInfo *item in [self eventInfoForPredicate:nil inManagedObjectContext:context]) {
        [context deleteObject:item];
    }
}    

@end
