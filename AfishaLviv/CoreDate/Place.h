//
//  Place.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * place_type;
@property (nonatomic, retain) NSString * simage_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

+ (Place *)placeWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo
            inManagedObjectContext:(NSManagedObjectContext *)context;

@end
