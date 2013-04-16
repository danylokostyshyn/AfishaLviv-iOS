//
//  DBController.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBController.h"

#import "AfishaLvivFetcher.h"

#import "Event+AfishaLviv.h"
#import "EventInfo+AfishaLviv.h"
#import "Place+AfishaLviv.h"
#import "PlaceInfo+AfishaLviv.h"

#import "AppDelegate.h"

@implementation DBController





/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (void)fetchPlaceInfoForUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSDictionary *placesInfo = [AfishaLvivFetcher placeInfoForPlaceUrl:url];
    [PlaceInfo placeInfoWithAfishaLvivInfo:placesInfo inManagedObjectContext:context];   
}

+ (void)fetchPlaceInfoForUrl:(NSURL *)url
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self fetchPlaceInfoForUrl:url inManagedObjectContext:[delegate managedObjectContext]];
}

+ (NSArray *)placeInfoForPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context
{
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlaceInfo" inManagedObjectContext:context];   
    
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

+ (NSArray *)placeInfoForUniqueUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
    return [self placeInfoForPredicate:predicate inManagedObjectContext:context];
}

+ (NSArray *)placeInfoForUniqueUrl:(NSURL *)url
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [self placeInfoForUniqueUrl:url inManagedObjectContext:[delegate managedObjectContext]];
}

+ (void)deleteAllPlaceInfosInManagedObjectContext:(NSManagedObjectContext *)context
{
    for (PlaceInfo *item in [self placeInfoForPredicate:nil inManagedObjectContext:context]) {
        [context deleteObject:item];
    }    
}

+ (void)deleteAllPlaceInfos
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [self deleteAllPlaceInfosInManagedObjectContext:[delegate managedObjectContext]];
}

@end
