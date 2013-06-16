//
//  PlaceInfo.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import <Foundation/Foundation.h>

@interface ALPlaceInfo : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * bimage_url;
@property (nonatomic, strong) NSString * google_map_url;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * schedule;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * website;
@property (nonatomic, strong) NSString * email;

+ (ALPlaceInfo *)placeInfoWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo;

@end
