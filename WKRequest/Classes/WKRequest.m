//     ..    .. ..... ..   .. ....    .. .. ..... ..  .. .. .. ..... ..
//     ..    .. .. .. ..   .. .. ..   ....  .. ..  ....  ..... .. .. ..
//     .. .. .. ..... ..   .. .. ..   .. .. .....   ..   .. .. ..... ..
//      ..  ..  .. .. .... .. ....    .. .. .. ..   ..   .. .. .. .. ....
//
//     MIT License
//
//     Copyright (c) 2016 Walid KAYHAL
//
//     Permission is hereby granted, free of charge, to any person obtaining a copy
//     of this software and associated documentation files (the "Software"), to deal
//     in the Software without restriction, including without limitation the rights
//     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//     copies of the Software, and to permit persons to whom the Software is
//     furnished to do so, subject to the following conditions:
//
//     The above copyright notice and this permission notice shall be included in all
//     copies or substantial portions of the Software.
//
//     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//     SOFTWARE.

#import "WKRequest.h"
#import "WKRequestCredential.h"
#import "WKRequestTokenManager.h"
#import <UIKit/UIKit.h>

//--------------------------------------------------------------------------------------------------
#pragma mark - Constantes
//--------------------------------------------------------------------------------------------------

static const NSTimeInterval kDefaultTimeOutInterval = 60;
static const NSInteger KLostHTTPConnection = -1005;
//--------------------------------------------------------------------------------------------------

@interface WKRequest ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *allHeaders;
@property (nonatomic, strong) NSMutableArray<NSURLSessionTask *> *tasks;
@property (nonatomic, strong) NSNumber * currentTaskIdentifier;

@end

@implementation WKRequest

//--------------------------------------------------------------------------------------------------
#pragma mark - Constructors
//--------------------------------------------------------------------------------------------------

static WKRequest *instance;
+ (WKRequest *)sharedInstance
{
    if(!instance) instance = [[WKRequest alloc] initPrivate];
    
    return instance;
}

- (instancetype)initPrivate
{
    if(!instance)
    {
        instance = [super init];
        self.allHeaders = [NSMutableDictionary new];
        self.timeoutInterval = kDefaultTimeOutInterval;
    }
    
    return instance;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Public Methods
//--------------------------------------------------------------------------------------------------

- (NSNumber *)requestWithUrl:(NSString *)url method:(WKRequestMethod)method completion:(CompletionHandler)completion
{
    return [self requestWithParameters:nil url:url method:method credential:nil completion:completion];
}

- (NSNumber *)requestWithUrl:(NSString *)url parameters:(id)parameters method:(WKRequestMethod)method completion:(CompletionHandler)completion
{
    return [self requestWithParameters:parameters url:url method:method credential:nil completion:completion];
}

- (NSNumber *)requestWithUrl:(NSString *)url method:(WKRequestMethod)method credential:(WKRequestCredential *)credential completion:(CompletionHandler)completion
{
    return [self requestWithParameters:nil url:url method:method credential:credential completion:completion];
}

- (NSUInteger)cancelAllRequests
{
    NSUInteger tasksCanceled = 0;
    
    for (NSURLSessionTask *task in [self.tasks copy])
    {
        tasksCanceled += [self cancelRequestWithIdentifier:task.taskIdentifier];
    }
    
    return tasksCanceled;
}

- (NSUInteger)cancelRequestWithIdentifier:(NSInteger)identifier
{
    NSInteger tasksCanceled = 0;
    NSArray *tasks = [self.tasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taskIdentifier == %d", identifier]];
    
    for (NSURLSessionTask *task in self.tasks)
    {
        [task cancel];
        tasksCanceled += 1;
    }
    
    [self.tasks removeObjectsInArray:tasks];
    
    return tasksCanceled;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//--------------------------------------------------------------------------------------------------

- (NSNumber *)requestWithParameters:(id)parameters url:(NSString *)url method:(WKRequestMethod)method credential:(WKRequestCredential *)credential completion:(CompletionHandler)completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    if(credential)
    {
        [self authentificationWithRequest:request url:url crendential:credential completion:completion];
    }
    else
    {
        [self queryForRequest:request parameters:parameters url:url method:method credential:nil completion:completion];
    }
    
    return self.currentTaskIdentifier;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Authentification
//--------------------------------------------------------------------------------------------------

- (void)authentificationWithRequest:(NSMutableURLRequest *)request url:(NSString *)url crendential:(WKRequestCredential *)credential completion:(CompletionHandler)completion
{
    [self queryForRequest:request parameters:nil url:url method:WKRequestMethodPost credential:credential completion:^(NSError *error, id data) {
        
        if([WKRequestTokenManager sharedInstance].isExpired) [[WKRequestTokenManager sharedInstance] initializeWithData:data];
        
        if(completion) completion(error, data);
    }];
}

//--------------------------------------------------------------------------------------------------
#pragma mark - GET, POST, PUT, DELETE
//--------------------------------------------------------------------------------------------------

- (void)queryForRequest:(NSMutableURLRequest*)request parameters:(id)parameters url:(NSString *)url method:(WKRequestMethod)method credential:(WKRequestCredential *)credential completion:(CompletionHandler)completion
{
    switch (method)
    {
        case WKRequestMethodGet:
            [self queryForGetRequest:request atUrl:url withParameters:parameters];
            break;
            
        case WKRequestMethodPost:
            [self queryForPostRequest:request atUrl:url withParameters:parameters credential:credential];
            break;
            
        case WKRequestMethodPut:
            [self queryForPutRequest:request atUrl:url withParameters:parameters];
            break;
            
        case WKRequestMethodSubscribe:
            [self queryForSubscribeRequest:request atUrl:url withParameters:parameters];
            break;
            
        case WKRequestMethodUnsubscribe:
            [self queryForUnsubscribeRequest:request atUrl:url withParameters:parameters];
            break;
            
        default:
            return;
    }
    
    [self configureAndExecuteRequest:request credential:credential completion:completion];
    
    [self clean];
}

- (void)queryForGetRequest:(NSMutableURLRequest*)request atUrl:(NSString*)stringUrl withParameters:(NSDictionary*) parameters
{
    NSString *urlWithParams = [self concat:stringUrl withParameters:parameters];
    
    NSURL *url = [NSURL URLWithString:[urlWithParams stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    request.URL         = url;
    request.HTTPBody    = nil;
    request.HTTPMethod  = @"GET";
    
    request.allHTTPHeaderFields = self.headers;
    self.headers = nil;
}

//--------------------------------------------------------------------------------------------------

- (void)queryForPostRequest:(NSMutableURLRequest*)request atUrl:(NSString*)stringUrl withParameters:(id)parameters credential:(WKRequestCredential *)credential
{
    [self transformUrl:&stringUrl withUrlParams:self.urlParameters];
    
    NSURL *url = [NSURL URLWithString:[stringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    request.URL = url;
    request.HTTPMethod = @"POST";
    
    if(parameters && !credential)
    {
        NSData *dataToPost;
        
        // x-www-form-urlencoded encoding
        if([self.headers.allValues containsObject:@"application/x-www-form-urlencoded"])
        {
            NSString *params = [self concat:@"" withParameters:parameters];
            dataToPost = [params dataUsingEncoding:NSUTF8StringEncoding];
        }
        // JSON encoding by default
        else
        {
            dataToPost = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        }
        
        request.HTTPBody = dataToPost;
        
        [self.allHeaders setObject:@"application/json" forKey:@"Content-Type"];
    }
    else if(credential && !parameters)
    {
        NSString *c = [NSString stringWithFormat:@"username=%@&password=%@&grant_type=%@", credential.username, credential.password, credential.grantType];
        request.HTTPBody = [c dataUsingEncoding:NSUTF8StringEncoding];
    }
}

//--------------------------------------------------------------------------------------------------

- (void)queryForPutRequest:(NSMutableURLRequest*)request atUrl:(NSString*)stringUrl withParameters:(id)parameters
{
    NSMutableString *mutableStringUrl = [NSMutableString stringWithString:stringUrl];
    
    NSURL *url = [NSURL URLWithString:[mutableStringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    request.URL = url;
    request.HTTPMethod = @"PUT";
    
    if(parameters)
    {
        NSData *dataToPost = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = dataToPost;
    }
    
    [self.allHeaders setObject:@"application/json" forKey:@"Content-Type"];
}

//--------------------------------------------------------------------------------------------------

- (void)queryForSubscribeRequest:(NSMutableURLRequest*)request atUrl:(NSString*)stringUrl withParameters:(id)parameters
{
    NSMutableString *mutableStringUrl = [NSMutableString stringWithString:stringUrl];
    
    NSURL *url = [NSURL URLWithString:[mutableStringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    request.URL = url;
    request.HTTPMethod = @"SUBSCRIBE";
    
    if(parameters)
    {
        NSData *dataToPost = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = dataToPost;
    }
    
    [self.allHeaders setObject:@"application/json" forKey:@"Content-Type"];
}

//--------------------------------------------------------------------------------------------------

- (void)queryForUnsubscribeRequest:(NSMutableURLRequest*)request atUrl:(NSString*)stringUrl withParameters:(id)parameters
{
    NSMutableString *mutableStringUrl = [NSMutableString stringWithString:stringUrl];
    
    NSURL *url = [NSURL URLWithString:[mutableStringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    request.URL = url;
    request.HTTPMethod = @"UNSUBSCRIBE";
    
    if(parameters)
    {
        NSData *dataToPost = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = dataToPost;
    }
    
    [self.allHeaders setObject:@"application/json" forKey:@"Content-Type"];
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Useful methods
//--------------------------------------------------------------------------------------------------

- (NSString *)concat:(NSString *)string withParameters:(NSDictionary *)parameters
{
    if(![parameters isKindOfClass:NSDictionary.class]) return string;
    
    NSMutableString *mutableStringUrl = [NSMutableString stringWithString:string];
    
    int i = 0;
    for(NSString* key in [parameters allKeys])
    {
        if(i == 0 && string.length > 0)    [mutableStringUrl appendString:@"?"];
        else if(i > 0)                  [mutableStringUrl appendString:@"&"];
        
        [mutableStringUrl appendFormat:@"%@=%@", key, [parameters objectForKey:key]];
        
        i++;
    }
    
    return mutableStringUrl;
}

- (void)transformUrl:(NSString **)url withUrlParams:(id)parameters
{
    NSString *urlWithParams = nil;
    
    if(self.urlParameters)
    {
        urlWithParams = [self concat:*url withParameters:parameters];
        *url = urlWithParams;
    }
}

- (void)configureAndExecuteRequest:(NSMutableURLRequest*)request credential:(WKRequestCredential *)credential completion:(CompletionHandler)completion
{
    if(credential) [self.allHeaders setObject:[NSString stringWithFormat:@"%@ %@", [WKRequestTokenManager sharedInstance].tokenType, [WKRequestTokenManager sharedInstance].token] forKey:@"Authorization"];
    
    [self.allHeaders addEntriesFromDictionary:self.headers];
    request.allHTTPHeaderFields = self.allHeaders;
    request.timeoutInterval = self.timeoutInterval;
    
    if(request.URL && request.URL.scheme && request.URL.host) [self executeTaskWithRequest:request completion:completion];
}

- (void)clean
{
    // Init again
    self.allHeaders = [NSMutableDictionary new];
    
    self.headers = nil;
    self.urlParameters = nil;
    self.timeoutInterval = kDefaultTimeOutInterval;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Application
//--------------------------------------------------------------------------------------------------

- (void)showNetworkActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
}

- (void)hideNetworkActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Session Task for HTTP
//--------------------------------------------------------------------------------------------------

- (void)executeTaskWithRequest:(NSMutableURLRequest*)request completion:(CompletionHandler)completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    [self showNetworkActivity];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [self hideNetworkActivity];
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        self.responseFields = ((NSHTTPURLResponse *)response).allHeaderFields;
        
        if (completion)
        {
            if (statusCode >= 200 && statusCode <= 299)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, data);
                });
            }
            else
            {
                if (error.code == KLostHTTPConnection)
                {
                    return [self executeTaskWithRequest:request completion:completion];
                }
                
                NSString *dataReturned = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSError *error = [NSError errorWithDomain:@"(!) HTTP Error" code:statusCode userInfo:@{@"Info" : dataReturned ?: @"No data"}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error, data);
                });
            }
        }
    }];

    [self manageTask:task];
}

-(void)manageTask:(NSURLSessionTask *)task
{
    if(!self.tasks)
    {
        self.tasks = [NSMutableArray new];
    }
    else
    {
        // Removes task completed
        self.tasks = [[self.tasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state != %d", NSURLSessionTaskStateCompleted]] mutableCopy];
    }
    
    [self.tasks addObject:task];
    self.currentTaskIdentifier = @(task.taskIdentifier);
    
    [task resume];
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Session task for TCP
//--------------------------------------------------------------------------------------------------

- (void)requestForStreamWithHostname:(NSString *)hostname port:(NSInteger)port data:(NSString *)data completion:(void(^)(NSError *))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    [self showNetworkActivity];
    
    NSURLSessionStreamTask *task = [session streamTaskWithHostName:hostname port:port];
    
    [self manageTask:task];
    
    [task writeData:[data dataUsingEncoding:NSUTF8StringEncoding] timeout:30.f completionHandler:^(NSError * _Nullable err) {
        
        [self hideNetworkActivity];
        
        if(!err)
        {
            [task closeWrite];
            [task captureStreams];
        }
        
        if(completion) completion(err);
    }];
}


@end

