//
//  DataManager.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 4/20/13.
//
//

#import "ALDataManager.h"

//models
#import "AfishaLvivFetcher.h"
#import "ALEvent.h"
#import "ALEventInfo.h"
#import "ALPlace.h"
#import "ALPlaceInfo.h"

@interface ALDataManager ()
+ (NSString *)afishaLvivStringFromDate:(NSDate *)date;
+ (NSArray *)entitiesWithName:(NSString *)entityName
                    predicate:(NSPredicate *)predicate
       inManagedObjectContext:(NSManagedObjectContext *)context;
@end

@implementation ALDataManager

//+ (NSString *)afishaLvivStringFromDate:(NSDate *)date
//{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//    
//    return [dateFormat stringFromDate:date];
//}
//
//+ (NSArray *)entitiesWithName:(NSString *)entityName
//                    predicate:(NSPredicate *)predicate
//       inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entity];
//    
//    if (predicate) {
//        [request setPredicate:predicate];
//    }
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
//    NSArray *sortDescriptors = @[sortDescriptor];
//    [request setSortDescriptors:sortDescriptors];
//    
//    NSError *error;
//    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
//    if (error) NSLog(@"%@", error);
//    
//    return fetchResults;
//}
//
//#pragma mark - Events
//
//+ (void)fetchEventsForDate:(NSDate *)date inToManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSArray *events = [AfishaLvivFetcher eventsForDate:date];
//    for (NSDictionary *eventsInfo in events) {
//        [ALEvent eventWithAfishaLvivInfo:eventsInfo inManagedObjectContext:context];
//    }
//}
//
//+ (NSArray *)eventsInManagedObjectContext:(NSManagedObjectContext *)context
//{
//    return [DataManager entitiesWithName:@"Event"
//                               predicate:nil
//                  inManagedObjectContext:context];
//}
//
//+ (NSArray *)eventsForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", [self afishaLvivStringFromDate:date]];
//    return [DataManager entitiesWithName:@"Event"
//                               predicate:predicate
//                  inManagedObjectContext:context];
//}
//
//+ (NSArray *)eventsForDate:(NSDate *)date type:(EventType)type inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSString *eventsTypeString;
//    switch (type) {
//        case EventTypeConcert: eventsTypeString = EVENT_TYPE_CONCERT; break;
//        case EventTypeExibition: eventsTypeString = EVENT_TYPE_EXHIBITION; break;
//        case EventTypeParty: eventsTypeString = EVENT_TYPE_PARTY; break;
//        case EventTypePerformance: eventsTypeString = EVENT_TYPE_PERFORMANCE; break;
//        case EventTypePresentation: eventsTypeString = EVENT_TYPE_PRESENTATION; break;
//        case EventTypeCinema: eventsTypeString = EVENT_TYPE_CINEMA; break;
//        default: break;
//    }
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@ AND event_type == %@",
//                              [self afishaLvivStringFromDate:date], eventsTypeString];
//    return [DataManager entitiesWithName:@"Event"
//                               predicate:predicate
//                  inManagedObjectContext:context];
//}
//
//+ (void)deleteEventsForDate:(NSDate *)date inManagedContext:(NSManagedObjectContext *)context
//{
//    for (ALEvent *item in [DataManager eventsForDate:date inManagedObjectContext:context]) {
//        [context deleteObject:item];
//    }
//}
//
//+ (void)deleteAllEventsInManagedObjectContext:(NSManagedObjectContext *)context
//{
//    for (ALEvent *item in [DataManager eventsInManagedObjectContext:context]) {
//        [context deleteObject:item];
//    }
//}
//
//#pragma mark - Events Info
//
//+ (void)fetchEventsInfosForUrl:(NSURL *)url inToManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSDictionary *eventsInfo = [AfishaLvivFetcher eventInfoForEventUrl:url];
//    [ALEventInfo eventInfoWithAfishaLvivInfo:eventsInfo inManagedObjectContext:context];
//}
//
//+ (NSArray *)eventsInfosInManagedObjectContext:(NSManagedObjectContext *)context
//{
//    return [DataManager entitiesWithName:@"EventInfo"
//                               predicate:nil
//                  inManagedObjectContext:context];
//}
//
//+ (ALEventInfo *)eventInfoForUniqueUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
//    return [[DataManager entitiesWithName:@"EventInfo"
//                                predicate:predicate
//                   inManagedObjectContext:context] lastObject];
//}
//
//+ (void)deleteAllEventsInfosInManagedObjectContext:(NSManagedObjectContext *)context
//{
//    for (ALEventInfo *item in [DataManager eventsInfosInManagedObjectContext:context]) {
//        [context deleteObject:item];
//    }
//}
//
//#pragma mark - Places
//
//+ (void)fetchPlacesForType:(PlaceType)type inToManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSArray *items = [AfishaLvivFetcher placesForType:type];
//    for (NSDictionary *itemInfo in items) {
//        [ALPlace placeWithAfishaLvivInfo:itemInfo inManagedObjectContext:context];
//    }
//}
//
//+ (NSArray *)placesInManagedObjectContext:(NSManagedObjectContext *)context
//{
//    return [DataManager entitiesWithName:@"Place"
//                               predicate:nil
//                  inManagedObjectContext:context];
//}
//
//+ (NSArray *)placesForType:(PlaceType)type inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSString *placeTypeString;
//    switch (type) {
//        case PlaceTypeRestaurant: placeTypeString = PLACE_TYPE_RESTAURANT; break;
//        case PlaceTypeMuseum: placeTypeString = PLACE_TYPE_MUSEUM; break;
//        case PlaceTypeGallery: placeTypeString = PLACE_TYPE_GALLERY; break;
//        case PlaceTypeTheater: placeTypeString = PLACE_TYPE_THEATER; break;
//        case PlaceTypeCinema: placeTypeString = PLACE_TYPE_CINEMA; break;
//        case PlaceTypeClub: placeTypeString = PLACE_TYPE_CLUB; break;
//        case PlaceTypeHall: placeTypeString = PLACE_TYPE_HALL; break;
//        default: break;
//    }
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"place_type == %@", placeTypeString];
//    return [DataManager entitiesWithName:@"Place"
//                               predicate:predicate
//                  inManagedObjectContext:context];
//}
//
//+ (void)deleteAllPlacesInManagedObjectContext:(NSManagedObjectContext *)context
//{
//    for (ALPlace *item in [DataManager placesInManagedObjectContext:context]) {
//        [context deleteObject:item];
//    }
//}
//
//#pragma mark - Places Info
//
//+ (void)fetchPlacesInfosForUrl:(NSURL *)url inToManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSDictionary *placesInfo = [AfishaLvivFetcher placeInfoForPlaceUrl:url];
//    [ALPlaceInfo placeInfoWithAfishaLvivInfo:placesInfo inManagedObjectContext:context];
//}
//
//+ (NSArray *)placesInfosInManagedObjectContext:(NSManagedObjectContext *)context
//{
//    return [DataManager entitiesWithName:@"PlaceInfo"
//                               predicate:nil
//                  inManagedObjectContext:context];
//}
//
//+ (ALPlaceInfo *)placeInfoForUniqueUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
//    return [[DataManager entitiesWithName:@"PlaceInfo"
//                                predicate:predicate
//                   inManagedObjectContext:context] lastObject];
//}
//
//+ (void)deleteAllPlacesInfosInManagedObjectContext:(NSManagedObjectContext *)context
//{
//    for (ALPlaceInfo *item in [DataManager placesInfosInManagedObjectContext:context]) {
//        [context deleteObject:item];
//    }
//}

@end
