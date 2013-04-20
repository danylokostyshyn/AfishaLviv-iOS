//
//  Event+AfishaLviv.h
//  AfishaLviv
//
//  Created by Mac on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@interface Event (AfishaLviv)

typedef enum {
    EventTypeConcert,
    EventTypeExibition,
    EventTypeCinema,
    EventTypeParty,
    EventTypePerformance,
    EventTypePresentation
    
} EventType;


//+ (Event *)eventWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSString *)afishaLvivStringFromDate:(NSDate *)date;

+ (void)fetchEventsForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)eventsForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)eventsForDate:(NSDate *)date type:(EventType)type inManagedObjectContext:(NSManagedObjectContext *)context;

//+ (NSDictionary *)dictionaryWithEventArraysAndTypesForDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteAllEventsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteEventsForDate:(NSDate *)date inManagedContext:(NSManagedObjectContext *)context;

@end
