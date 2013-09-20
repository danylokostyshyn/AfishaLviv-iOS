//
//  ALHTTPClient.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 6/15/13.
//
//

#import "ALHTTPClient.h"

//models
#import "ALEvent.h"
#import "ALEventInfo.h"
#import "ALPlace.h"
#import "ALPlaceInfo.h"

@interface ALHTTPClient ()

@end

@implementation ALHTTPClient

static NSString *kAPIBaseUrlString = @"http://afishalvivparser.appspot.com";

+ (ALHTTPClient *)sharedHTTPClient
{
    static dispatch_once_t onceToken;
    static ALHTTPClient *sharedHTTPClient = nil;
    dispatch_once(&onceToken, ^{
        sharedHTTPClient = [[ALHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseUrlString]];
    });
    return sharedHTTPClient;
}

+ (NSString *)afishaLvivDateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];  //2012-01-13
    return [dateFormat stringFromDate:date];
}

#pragma mark - Operations

- (ALHTTPRequestOperation *)eventsOperationForDate:(NSDate *)date
                                           success:(void (^)(ALHTTPRequestOperation *operation, NSArray *events))success
                                           failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *requestPath = [kAPIBaseUrlString stringByAppendingFormat:@"/events?%@", [ALHTTPClient afishaLvivDateStringFromDate:date]];
    NSURLRequest *request = [[ALHTTPClient sharedHTTPClient] requestWithMethod:@"GET"
                                                                      path:requestPath
                                                                    parameters:nil];

    ALHTTPRequestOperation *operation = [[ALHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(ALHTTPRequestOperation *operation, id JSONObject) {
        NSMutableArray *events = [NSMutableArray array];
        for (NSDictionary *eventDict in (NSArray *)JSONObject) {
            ALEvent *event = [ALEvent eventWithAfishaLvivInfo:eventDict];
            [events addObject:event];
        }
        success(operation, events);
    } failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (ALHTTPRequestOperation *)eventInfoFromURL:(NSURL *)eventInfoURL
                                     success:(void (^)(ALHTTPRequestOperation *operation, ALEventInfo *eventInfo))success
                                     failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *requestPath = [kAPIBaseUrlString stringByAppendingFormat:@"/event_info?%@", eventInfoURL];
    NSURLRequest *request = [[ALHTTPClient sharedHTTPClient] requestWithMethod:@"GET"
                                                                          path:requestPath
                                                                    parameters:nil];

    ALHTTPRequestOperation *operation = [[ALHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(ALHTTPRequestOperation *operation, id JSONObject) {
        ALEventInfo *eventInfo = [ALEventInfo eventInfoWithAfishaLvivInfo:(NSDictionary *)JSONObject];
        success(operation, eventInfo);
    } failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (ALHTTPRequestOperation *)placesOperationForType:(ALPlaceType)placeType
                                           success:(void (^)(ALHTTPRequestOperation *operation, NSArray *places))success
                                           failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *placeTypeString;
    switch (placeType) {
        case ALPlaceTypeRestaurant: placeTypeString = PLACE_TYPE_RESTAURANT; break;
        case ALPlaceTypeMuseum: placeTypeString = PLACE_TYPE_MUSEUM; break;
        case ALPlaceTypeGallery: placeTypeString = PLACE_TYPE_GALLERY; break;
        case ALPlaceTypeTheater: placeTypeString = PLACE_TYPE_THEATER; break;
        case ALPlaceTypeCinema: placeTypeString = PLACE_TYPE_CINEMA; break;
        case ALPlaceTypeClub: placeTypeString = PLACE_TYPE_CLUB; break;
        case ALPlaceTypeHall: placeTypeString = PLACE_TYPE_HALL; break;
        default: break;
    }

    NSString *requestPath = [kAPIBaseUrlString stringByAppendingFormat:@"/places?%@", placeTypeString];
    NSURLRequest *request = [[ALHTTPClient sharedHTTPClient] requestWithMethod:@"GET"
                                                                          path:requestPath
                                                                    parameters:nil];
    
    ALHTTPRequestOperation *operation = [[ALHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(ALHTTPRequestOperation *operation, id JSONObject) {
        NSMutableArray *places = [NSMutableArray array];
        for (NSDictionary *placeDict in (NSArray *)JSONObject) {
            ALPlace *place = [ALPlace placeWithAfishaLvivInfo:placeDict];
            [places addObject:place];
        }
        success(operation, places);
    } failure:failure];

    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (ALHTTPRequestOperation *)placeInfoFromURL:(NSURL *)placeInfoURL
                                     success:(void (^)(ALHTTPRequestOperation *operation, ALPlaceInfo *placeInfo))success
                                     failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *requestPath = [kAPIBaseUrlString stringByAppendingFormat:@"/place_info?%@", placeInfoURL];
    NSURLRequest *request = [[ALHTTPClient sharedHTTPClient] requestWithMethod:@"GET"
                                                                          path:requestPath
                                                                    parameters:nil];
    
    ALHTTPRequestOperation *operation = [[ALHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(ALHTTPRequestOperation *operation, id JSONObject) {
        ALPlaceInfo *placeInfo = [ALPlaceInfo placeInfoWithAfishaLvivInfo:(NSDictionary *)JSONObject];
        success(operation, placeInfo);
    } failure:failure];

    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

@end
