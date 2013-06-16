//
//  Place.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 29.03.12.

#import <Foundation/Foundation.h>

#define PLACE_TYPE_RESTAURANT                   @"restaurant"
#define PLACE_TYPE_MUSEUM                       @"museum"
#define PLACE_TYPE_GALLERY                      @"gallery"
#define PLACE_TYPE_THEATER                      @"theater"
#define PLACE_TYPE_CINEMA                       @"cinema"
#define PLACE_TYPE_CLUB                         @"club"
#define PLACE_TYPE_HALL                         @"hall"

#define kALPlaceTypesCount  7

typedef enum {
    ALPlaceTypeRestaurant,
    ALPlaceTypeMuseum,
    ALPlaceTypeGallery,
    ALPlaceTypeTheater,
    ALPlaceTypeCinema,
    ALPlaceTypeClub,
    ALPlaceTypeHall
} ALPlaceType;

@interface ALPlace : NSObject

@property (nonatomic, strong) NSString * desc;
@property (nonatomic) ALPlaceType place_type;
@property (nonatomic, strong) NSString * simage_url;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;

+ (ALPlace *)placeWithAfishaLvivInfo:(NSDictionary *)afishaLvivInfo;

@end
