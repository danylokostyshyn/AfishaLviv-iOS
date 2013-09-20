//
//  ALHTTPClient.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 6/15/13.
//
//

#import "AFHTTPClient.h"

#import "ALHTTPRequestOperation.h"
#import "ALPlace.h"

@class ALHTTPRequestOperation, ALEventInfo, ALPlaceInfo;
@interface ALHTTPClient : AFHTTPClient

+ (ALHTTPClient *)sharedHTTPClient;

- (ALHTTPRequestOperation *)eventsOperationForDate:(NSDate *)date
                                           success:(void (^)(ALHTTPRequestOperation *operation, NSArray *events))success
                                           failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure;

- (ALHTTPRequestOperation *)eventInfoFromURL:(NSURL *)eventInfoURL
                                     success:(void (^)(ALHTTPRequestOperation *operation, ALEventInfo *eventInfo))success
                                     failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure;

- (ALHTTPRequestOperation *)placesOperationForType:(ALPlaceType)placeType
                                           success:(void (^)(ALHTTPRequestOperation *operation, NSArray *places))success
                                           failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure;

- (ALHTTPRequestOperation *)placeInfoFromURL:(NSURL *)placeInfoURL
                                     success:(void (^)(ALHTTPRequestOperation *operation, ALPlaceInfo *placeInfo))success
                                     failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure;

@end
