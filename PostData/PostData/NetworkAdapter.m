//
//  NetworkAdapter.m
//  PostData
//
//  Created by Akshat Singhal on 15/03/14.
//  Copyright (c) 2014 info. All rights reserved.
//

#import "NetworkAdapter.h"
#define URL @"http://google.com"

@implementation NetworkAdapter
@synthesize delegate    =   _delegate;

- (void)postData:(NSDictionary *)data {
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSMutableString *postString = [[NSMutableString alloc] init];
    for (NSString *key in data) {
        [postString appendString:[NSString stringWithFormat:@"%@=%@&",key,data[key]]];
    }
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    (void )[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    appData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [appData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[self delegate] networkAdapterDelegateDidFinish:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"FAILED", @"status",
                                                      error,     @"message",
                                                      nil]];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error = nil;
    NSDictionary *parseObject=[NSJSONSerialization JSONObjectWithData:appData options:NSJSONReadingAllowFragments error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(networkAdapterDelegateDidFinish:)])
        [[self delegate] networkAdapterDelegateDidFinish:
         [NSDictionary dictionaryWithObjectsAndKeys:@"SUCCESS", @"status",parseObject, @"content",nil]];
}
- (BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace*)protectionSpace{
	if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]	||
		[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]			)
	{
		return NO;
	}
	else
	{
		return YES;
	}
}
- (void)connection:(NSURLConnection*)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge{
	
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
