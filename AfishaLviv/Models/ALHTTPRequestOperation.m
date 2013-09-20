//
//  ALHTTPRequestOperation.m
//  AfishaLviv
//
//  Created by Danylo Kostyshyn on 9/20/13.
//
//

#import "ALHTTPRequestOperation.h"

//views
#import <MBProgressHUD.h>

@implementation ALHTTPRequestOperation

- (void)setCompletionBlockWithSuccess:(void (^)(ALHTTPRequestOperation *operation, id JSONObject))success
                              failure:(void (^)(ALHTTPRequestOperation *operation, NSError *error))failure;
{
    [super setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSError *serializationError;
         id JSONObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&serializationError];
         if (serializationError) {
             NSLog(@"%@", serializationError);
             failure((void (^)(ALHTTPRequestOperation *operation, id object))operation, serializationError);
             return;
         }
         
         success((ALHTTPRequestOperation *)operation, JSONObject);

     } failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    return [super connection:connection willSendRequest:request redirectResponse:response];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    
    [super connectionDidFinishLoading:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"No Internet Connection", nil);
    [hud hide:YES afterDelay:1];
    
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    
    [super connection:connection didFailWithError:error];
}

@end
