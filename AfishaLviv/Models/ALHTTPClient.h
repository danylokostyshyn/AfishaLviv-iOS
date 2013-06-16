//
//  ALHTTPClient.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 6/15/13.
//
//

#import "AFHTTPClient.h"

#import "ALPlace.h"

@class ALEventInfo, ALPlaceInfo;
@interface ALHTTPClient : AFHTTPClient
+ (ALHTTPClient *)sharedHTTPClient;

- (AFHTTPRequestOperation *)eventsOperationForDate:(NSDate *)date
                                           success:(void (^)(AFHTTPRequestOperation *operation, NSArray *events))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)eventInfoFromURL:(NSURL *)eventInfoURL
                                     success:(void (^)(AFHTTPRequestOperation *operation, ALEventInfo *eventInfo))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)placesOperationForType:(ALPlaceType)placeType
                                           success:(void (^)(AFHTTPRequestOperation *operation, NSArray *places))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)placeInfoFromURL:(NSURL *)placeInfoURL
                                     success:(void (^)(AFHTTPRequestOperation *operation, ALPlaceInfo *placeInfo))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
