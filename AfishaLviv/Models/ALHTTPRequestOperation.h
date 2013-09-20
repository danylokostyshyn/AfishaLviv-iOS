//
//  ALHTTPRequestOperation.h
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 9/20/13.
//
//

#import "AFHTTPRequestOperation.h"

@interface ALHTTPRequestOperation : AFHTTPRequestOperation

- (void)setCompletionBlockWithSuccess:(void (^)(ALHTTPRequestOperation *operation, id JSONObject))success
                              failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure;

@end
