//
//  Place.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import <Foundation/Foundation.h>

@interface ALPlace : NSObject

@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * place_type;
@property (nonatomic, strong) NSString * simage_url;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;

+ (ALPlace *)placeWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo;

@end
