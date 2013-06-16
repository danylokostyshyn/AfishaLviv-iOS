//
//  Event.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 24.03.12.

#import <Foundation/Foundation.h>

@class ALEventInfo;

@interface ALEvent : NSObject

@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * event_type;
@property (nonatomic, strong) NSString * place_title;
@property (nonatomic, strong) NSString * place_url;
@property (nonatomic, strong) NSString * simage_url;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;

+ (ALEvent *)eventWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo;

@end
