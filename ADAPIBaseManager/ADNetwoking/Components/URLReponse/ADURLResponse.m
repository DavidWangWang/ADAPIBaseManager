//
//  ADURLResponse.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADURLResponse.h"
#import "NSObject+ADNetworkingMethods.h"
#import "NSURLRequest+ADNetworkingMethods.h"

@interface ADURLResponse ()

@property (nonatomic, assign) ADURLResponseStatus status;
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, copy) id content;
@property (nonatomic, assign) NSInteger requestId;
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, assign) BOOL isCache;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, copy) NSData *responseData;
@end

@implementation ADURLResponse

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestID:(NSNumber *)requestID
                               request:(NSURLRequest *)request
                        responseObject:(id)responseObject
                                 error:(NSError *)error
{
    if (self = [super init]) {
        _contentString = [responseString ad_defaultValue:@""];
        _requestId = [requestID integerValue];
        _request = request;
        _acturlRequestParams = request.actualRequestParams;
        _originRequestParams = request.originRequestParams;
        _isCache = NO;
        _status = [self responseStatusWithError:error];
        _content = responseObject ? responseObject : @{};
        _errorMessage = [NSString stringWithFormat:@"%@", error];
    }

    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        _content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        _contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _status = [self responseStatusWithError:nil];
        _requestId = 0;
        _request = nil;
        _isCache = YES;
        _responseData = data;
    }
    return self;
}

#pragma mark - private

- (ADURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        ADURLResponseStatus result = ADURLResponseStatusErrorNoNetwork;
        if (error.code == NSURLErrorTimedOut) {
            result = ADURLResponseStatusErrorTimeout;
        } else if (error.code == NSURLErrorCancelled) {
            result = ADURLResponseStatusErrorCancel;
        } else if (error.code == NSURLErrorNotConnectedToInternet) {
            result = ADURLResponseStatusErrorNoNetwork;
        }
        return result;
    }
    
    return ADURLResponseStatusSuccess;
}

- (NSData *)responseData
{
    if (_responseData == nil) {
        NSError *error = nil;
        _responseData = [NSJSONSerialization dataWithJSONObject:self.content options:0 error:&error];
        if (error) {
            _responseData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return _responseData;
}

@end
