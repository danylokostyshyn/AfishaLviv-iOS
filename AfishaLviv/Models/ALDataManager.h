//
//  DataManager.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 4/20/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    ALEventTypeConcert,
    ALEventTypeExibition,
    ALEventTypeCinema,
    ALEventTypeParty,
    ALEventTypePerformance,
    ALEventTypePresentation
} ALEventType;

static NSUInteger kALEventTypesCount = 6;

typedef enum {
    ALPlaceTypeRestaurant,
    ALPlaceTypeMuseum,
    ALPlaceTypeGallery,
    ALPlaceTypeTheater,
    ALPlaceTypeCinema,
    ALPlaceTypeClub,
    ALPlaceTypeHall
} ALPlaceType;

static NSUInteger kALPlaceTypesCount = 7;

@class ALEventInfo, ALPlaceInfo;
@interface ALDataManager : NSObject

////events
//+ (void)fetchEventsForDate:(NSDate *)date inToManagedObjectContext:(NSManagedObjectContext *)context;
//+ (NSArray *)eventsForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;
//+ (NSArray *)eventsForDate:(NSDate *)date type:(EventType)type inManagedObjectContext:(NSManagedObjectContext *)context;
//+ (void)deleteEventsForDate:(NSDate *)date inManagedContext:(NSManagedObjectContext *)context;
//+ (void)deleteAllEventsInManagedObjectContext:(NSManagedObjectContext *)context;
//
////events infos
//+ (void)fetchEventsInfosForUrl:(NSURL *)url inToManagedObjectContext:(NSManagedObjectContext *)context;
//+ (ALEventInfo *)eventInfoForUniqueUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context;
//+ (void)deleteAllEventsInfosInManagedObjectContext:(NSManagedObjectContext *)context;
//
////places
//+ (void)fetchPlacesForType:(PlaceType)type inToManagedObjectContext:(NSManagedObjectContext *)context;
//+ (NSArray *)placesForType:(PlaceType)type inManagedObjectContext:(NSManagedObjectContext *)context;
//+ (void)deleteAllPlacesInManagedObjectContext:(NSManagedObjectContext *)context;
//
////places infos
//+ (void)fetchPlacesInfosForUrl:(NSURL *)url inToManagedObjectContext:(NSManagedObjectContext *)context;
//+ (ALPlaceInfo *)placeInfoForUniqueUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context;
//+ (void)deleteAllPlacesInfosInManagedObjectContext:(NSManagedObjectContext *)context;

@end
