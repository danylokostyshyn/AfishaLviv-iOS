//
//  Place.h
//  AfishaLviv
//
//  Created by Mac on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * place_type;
@property (nonatomic, retain) NSString * simage_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

@end
