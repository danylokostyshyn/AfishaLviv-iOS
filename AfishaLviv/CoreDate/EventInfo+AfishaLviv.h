//
//  EventInfo+AfishaLviv.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 22.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventInfo.h"

@interface EventInfo (AfishaLviv)

+ (EventInfo *)eventInfoWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)fetchEventInfoForUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)eventInfoForUniqueUrl:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllEventInfosInManagedObjectContext:(NSManagedObjectContext *)context;


@end
