//
//  ALHTTPClient.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 6/15/13.
//
//

#import "ALHTTPClient.h"

#import "ALAppDelegate.h"

//models
#import "ALEvent.h"
#import "ALEventInfo.h"
#import "ALPlace.h"
#import "ALPlaceInfo.h"

#import "AfishaLvivFetcher.h"

@implementation ALHTTPClient

static NSString *kAPIBaseUrlString = @"http://afishalvivparser.appspot.com";

+ (ALHTTPClient *)sharedHTTPClient
{
    static dispatch_once_t onceToken;
    static ALHTTPClient *sharedHTTPClient;
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

- (AFHTTPRequestOperation *)eventsOperationForDate:(NSDate *)date
                                           success:(void (^)(AFHTTPRequestOperation *operation, NSArray *events))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *requestPath = [kAPIBaseUrlString stringByAppendingFormat:@"/events?%@", [ALHTTPClient afishaLvivDateStringFromDate:date]];
    NSURLRequest *request = [[ALHTTPClient sharedHTTPClient] requestWithMethod:@"GET"
                                                                      path:requestPath
                                                                    parameters:nil];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        // Processing response payload
        NSError *serializationError;
        NSArray *eventsDicts = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&serializationError];
        if (serializationError) { failure(operation, serializationError); }
        
        NSMutableArray *events = [NSMutableArray array];
        for (NSDictionary *eventDict in eventsDicts) {
            ALEvent *event = [ALEvent eventWithAfishaLvivInfo:eventDict];
            [events addObject:event];
        }
        
        success(operation, events);
    }
                                     failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)eventInfoFromURL:(NSURL *)eventInfoURL
                                     success:(void (^)(AFHTTPRequestOperation *operation, ALEventInfo *eventInfo))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *requestPath = [kAPIBaseUrlString stringByAppendingFormat:@"/event_info?%@", eventInfoURL];
    NSURLRequest *request = [[ALHTTPClient sharedHTTPClient] requestWithMethod:@"GET"
                                                                          path:requestPath
                                                                    parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Processing response payload
        NSError *serializationError;
        NSDictionary *eventInfoDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&serializationError];
        if (serializationError) { failure(operation, serializationError); }
        
        ALEventInfo *eventInfo = [ALEventInfo eventInfoWithAfishaLvivInfo:eventInfoDict];
        
        success(operation, eventInfo);
    }
                                     failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)placesOperationForType:(PlaceType)placeType
                                           success:(void (^)(AFHTTPRequestOperation *operation, NSArray *places))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *placeTypeString;
    switch (placeType) {
        case PlaceTypeRestaurant: placeTypeString = PLACE_TYPE_RESTAURANT; break;
        case PlaceTypeMuseum: placeTypeString = PLACE_TYPE_MUSEUM; break;
        case PlaceTypeGallery: placeTypeString = PLACE_TYPE_GALLERY; break;
        case PlaceTypeTheater: placeTypeString = PLACE_TYPE_THEATER; break;
        case PlaceTypeCinema: placeTypeString = PLACE_TYPE_CINEMA; break;
        case PlaceTypeClub: placeTypeString = PLACE_TYPE_CLUB; break;
        case PlaceTypeHall: placeTypeString = PLACE_TYPE_HALL; break;
        default: break;
    }

    NSString *requestPath = [kAPIBaseUrlString stringByAppendingFormat:@"/places?%@", placeTypeString];
    NSURLRequest *request = [[ALHTTPClient sharedHTTPClient] requestWithMethod:@"GET"
                                                                          path:requestPath
                                                                    parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Processing response payload
        NSError *serializationError;
        NSArray *placessDicts = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&serializationError];
        if (serializationError) { failure(operation, serializationError); }
        
        NSMutableArray *places = [NSMutableArray array];
        for (NSDictionary *placeDict in placessDicts) {
            ALPlace *place = [ALPlace placeWithAfishaLvivInfo:placeDict];
            [places addObject:place];
        }
        
        success(operation, places);
    }
                                     failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)placeInfoFromURL:(NSURL *)placeInfoURL
                                     success:(void (^)(AFHTTPRequestOperation *operation, ALPlaceInfo *placeInfo))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *requestPath = [kAPIBaseUrlString stringByAppendingFormat:@"/place_info?%@", placeInfoURL];
    NSURLRequest *request = [[ALHTTPClient sharedHTTPClient] requestWithMethod:@"GET"
                                                                          path:requestPath
                                                                    parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Processing response payload
        NSError *serializationError;
        NSDictionary *placeInfoDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&serializationError];
        if (serializationError) { failure(operation, serializationError); }
        
        ALPlaceInfo *placeInfo = [ALPlaceInfo placeInfoWithAfishaLvivInfo:placeInfoDict];
        
        success(operation, placeInfo);
    }
                                     failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

@end
