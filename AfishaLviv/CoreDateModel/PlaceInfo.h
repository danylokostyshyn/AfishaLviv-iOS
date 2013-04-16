//
//  PlaceInfo.h
//  AfishaLviv
//
//  Created by Mac on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlaceInfo : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * bimage_url;
@property (nonatomic, retain) NSString * google_map_url;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * schedule;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * email;

@end
