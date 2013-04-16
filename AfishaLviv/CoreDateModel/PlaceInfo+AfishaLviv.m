//
//  PlaceInfo+AfishaLviv.m
//  AfishaLviv
//
//  Created by Mac on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceInfo+AfishaLviv.h"

#import "AfishaLvivFetcher.h"

@implementation PlaceInfo (AfishaLviv)

+ (PlaceInfo *)placeInfoWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo
                    inManagedObjectContext:(NSManagedObjectContext *)context
{
    PlaceInfo *itemInfo = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceInfo" 
                                                        inManagedObjectContext:context];

    @try {
        itemInfo.address = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_ADDRESS];
        itemInfo.bimage_url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_BIMAGEURL];
        itemInfo.email = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_EMAIL];
        itemInfo.google_map_url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_GOOGLE_MAP];    
        itemInfo.location = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_LOCATION];        
        itemInfo.phone = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_PHONE];
        itemInfo.schedule = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_SCHEDULE];
        itemInfo.text = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_TEXT];
        itemInfo.title = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_TITLE];
        itemInfo.url = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_URL];
        itemInfo.website = [afishaLvivInfo objectForKey:AFISHALVIV_PLACEINFO_WEBSITE];
        
        return itemInfo;

    }
    @catch (NSException *exception) {
        return nil;
    }
}

+ (void)fetchPlaceInfoForUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSDictionary *placesInfo = [AfishaLvivFetcher placeInfoForPlaceUrl:url];
    [PlaceInfo placeInfoWithAfishaLvivInfo:placesInfo inManagedObjectContext:context];   
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

+ (void)deleteAllPlaceInfosInManagedObjectContext:(NSManagedObjectContext *)context
{
    for (PlaceInfo *item in [self placeInfoForPredicate:nil inManagedObjectContext:context]) {
        [context deleteObject:item];
    }    
}

@end