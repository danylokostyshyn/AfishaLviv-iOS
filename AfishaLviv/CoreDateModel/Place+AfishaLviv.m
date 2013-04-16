//
//  Place+AfishaLviv.m
//  AfishaLviv
//
//  Created by Mac on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place+AfishaLviv.h"

#import "AfishaLvivFetcher.h"

@implementation Place (AfishaLviv)

+ (Place *)placeWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo 
            inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" 
                                                 inManagedObjectContext:context];
    
    place.title = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_TITLE];
    place.simage_url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_SIMAGEURL];
    place.place_type = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_TYPE];
    place.desc = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_DESCRIPTION];
    place.url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACE_URL];
    
    return place;
}

+ (void)fetchPlacesForType:(PlaceType)type inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *items = [AfishaLvivFetcher placesForType:type];
    for (NSDictionary *itemInfo in items) {
        [Place placeWithAfishaLvivInfo:itemInfo inManagedObjectContext:context];
    }
}

+ (NSArray *)placesForPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context
{
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];   
    
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

+ (NSArray *)placesForType:(PlaceType)type inManagedObjectContext:(NSManagedObjectContext *)context
{   
    NSString *placeTypeString;
    
    switch (type) {
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"place_type == %@", placeTypeString];
    return [self placesForPredicate:predicate inManagedObjectContext:context];
} 

+ (void)deleteAllPlacesInManagedObjectContext:(NSManagedObjectContext *)context
{
    for (Place *item in [self placesForPredicate:nil inManagedObjectContext:context]) {
        [context deleteObject:item];
    }
}    

@end
