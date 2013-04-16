//
//  Event.h
//  AfishaLviv
//
//  Created by Mac on 24.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventInfo;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * event_type;
@property (nonatomic, retain) NSString * place_title;
@property (nonatomic, retain) NSString * place_url;
@property (nonatomic, retain) NSString * simage_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

+ (Event *)eventWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo 
            inManagedObjectContext:(NSManagedObjectContext *)context;

@end
