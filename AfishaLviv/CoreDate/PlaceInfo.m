//
//  PlaceInfo.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import "PlaceInfo.h"

#import "AfishaLvivFetcher.h"

@implementation PlaceInfo

@dynamic address;
@dynamic bimage_url;
@dynamic google_map_url;
@dynamic location;
@dynamic phone;
@dynamic schedule;
@dynamic title;
@dynamic text;
@dynamic url;
@dynamic website;
@dynamic email;

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
        NSLog(@"%@", exception);
        return nil;
    }
}

@end
