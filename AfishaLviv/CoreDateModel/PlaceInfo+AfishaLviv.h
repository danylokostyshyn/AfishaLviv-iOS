//
//  PlaceInfo+AfishaLviv.h
//  AfishaLviv
//
//  Created by Mac on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceInfo.h"

@interface PlaceInfo (AfishaLviv)

+ (PlaceInfo *)placeInfoWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)fetchPlaceInfoForUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)placeInfoForUniqueUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllPlaceInfosInManagedObjectContext:(NSManagedObjectContext *)context;

@end
