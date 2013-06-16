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

//views
#import <MBProgressHUD.h>

@interface ALHTTPClient ()
@property (nonatomic) NSUInteger activeOperationsCount;
@end

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

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation
{
    [super enqueueHTTPRequestOperation:operation];
    [self incrementActiveOperationsCount];
}

- (void)incrementActiveOperationsCount
{
    self.activeOperationsCount++;
    
    if (self.activeOperationsCount == 1) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = NSLocalizedString(@"Loading...", @"");
    }
}

- (void)decrementActiveOperationsCount
{
    self.activeOperationsCount--;
    
    if (self.activeOperationsCount == 0) {
        [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
    }
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
        
        [self decrementActiveOperationsCount];
        success(operation, events);
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self decrementActiveOperationsCount];
        failure(operation, failure);
     }];
    
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
        
        [self decrementActiveOperationsCount];        
        success(operation, eventInfo);
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self decrementActiveOperationsCount];
         failure(operation, failure);
     }];
    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)placesOperationForType:(ALPlaceType)placeType
                                           success:(void (^)(AFHTTPRequestOperation *operation, NSArray *places))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
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

        [self decrementActiveOperationsCount];        
        success(operation, places);
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self decrementActiveOperationsCount];
         failure(operation, failure);
     }];
    
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
        
        [self decrementActiveOperationsCount];
        success(operation, placeInfo);
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self decrementActiveOperationsCount];
         failure(operation, failure);
     }];

    
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

@end
