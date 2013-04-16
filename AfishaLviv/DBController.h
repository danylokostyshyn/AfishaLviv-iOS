//
//  DBController.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBController : NSObject

typedef enum {
    EventTypeConcert,
    EventTypeExibition,
    EventTypeCinema,
    EventTypeParty,
    EventTypePerformance,
    EventTypePresentation
    
} EventType;



@end
