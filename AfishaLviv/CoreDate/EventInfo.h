//
//  EventInfo.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 25.03.12.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EventInfo : NSManagedObject

@property (nonatomic, retain) NSString * bimage_url;
@property (nonatomic, retain) NSString * date_interval;
@property (nonatomic, retain) NSString * place_url;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * worktime;
@property (nonatomic, retain) NSString * place_title;
@property (nonatomic, retain) NSString * place_address;

+ (EventInfo *)eventInfoWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo
                    inManagedObjectContext:(NSManagedObjectContext *)context;

@end
