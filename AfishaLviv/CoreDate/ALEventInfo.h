//
//  EventInfo.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 25.03.12.

#import <Foundation/Foundation.h>

@interface ALEventInfo : NSObject

@property (nonatomic, strong) NSString * bimage_url;
@property (nonatomic, strong) NSString * date_interval;
@property (nonatomic, strong) NSString * place_url;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * worktime;
@property (nonatomic, strong) NSString * place_title;
@property (nonatomic, strong) NSString * place_address;

+ (ALEventInfo *)eventInfoWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo;

@end
