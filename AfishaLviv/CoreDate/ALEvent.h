//
//  Event.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 24.03.12.

#import <Foundation/Foundation.h>

#define EVENT_TYPE_CONCERT                      @"concert"
#define EVENT_TYPE_EXHIBITION                   @"exhibition"
#define EVENT_TYPE_PARTY                        @"party"
#define EVENT_TYPE_PERFORMANCE                  @"performance"
#define EVENT_TYPE_PRESENTATION                 @"presentation"
#define EVENT_TYPE_CINEMA                       @"cinema"

#define kALEventTypesCount  6

typedef enum {
    ALEventTypeConcert,
    ALEventTypeExibition,
    ALEventTypeCinema,
    ALEventTypeParty,
    ALEventTypePerformance,
    ALEventTypePresentation
} ALEventType;

@class ALEventInfo;

@interface ALEvent : NSObject

@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic) ALEventType event_type;
@property (nonatomic, strong) NSString * place_title;
@property (nonatomic, strong) NSString * place_url;
@property (nonatomic, strong) NSString * simage_url;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;

+ (ALEvent *)eventWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo;

@end
