//
//  Place+AfishaLviv.h
//  AfishaLviv
//
//  Created by Mac on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place.h"

@interface Place (AfishaLviv)

typedef enum {
    PlaceTypeRestaurant,
    PlaceTypeMuseum,
    PlaceTypeGallery,
    PlaceTypeTheater,
    PlaceTypeCinema,
    PlaceTypeClub,
    PlaceTypeHall
} PlaceType;

+ (Place *)placeWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo 
            inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)fetchPlacesForType:(PlaceType)type inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)placesForPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)placesForType:(PlaceType)type inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllPlacesInManagedObjectContext:(NSManagedObjectContext *)context;


@end
