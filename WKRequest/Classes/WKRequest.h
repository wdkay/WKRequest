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

#import <Foundation/Foundation.h>

//--------------------------------------------------------------------------------------------------

@class WKRequestCredential;

//--------------------------------------------------------------------------------------------------
#pragma mark - Enum
//--------------------------------------------------------------------------------------------------

typedef NS_ENUM(NSInteger, WKRequestMethod)
{
    WKRequestMethodPost,
    WKRequestMethodGet,
    WKRequestMethodPut,
    WKRequestMethodDelete,
    WKRequestMethodSubscribe,
    WKRequestMethodUnsubscribe,
    
} NS_ENUM_AVAILABLE_IOS(7_0);


//--------------------------------------------------------------------------------------------------
#pragma mark - Typedef
//--------------------------------------------------------------------------------------------------

typedef void (^CompletionHandler) (NSError *error, id data);

//--------------------------------------------------------------------------------------------------
#pragma mark - Object
//--------------------------------------------------------------------------------------------------

/**
 * Used to perfom HTTP & TCP queries.
 *
 * @author Walid Kayhal
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface WKRequest : NSObject <NSURLSessionDataDelegate>


//--------------------------------------------------------------------------------------------------
#pragma mark - Properties
//--------------------------------------------------------------------------------------------------

/** Headers to add to the request */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headers;

/** Useful to transmit parameters via URL when a POST request is used  */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *urlParameters;

/** Useful to retrieve the request response fields  */
@property (nonatomic, strong) NSDictionary <NSString *, NSString *> *responseFields;

/** The request timeout */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

//--------------------------------------------------------------------------------------------------
+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;
//--------------------------------------------------------------------------------------------------

/**
 * Singleton
 *
 * @return The current instance.
 *
 * @author Walid Kayhal
 */
+ (WKRequest *)sharedInstance;

/**
 * Execute an HTTP request.
 *
 * @param url                   URL to reach.
 * @param method                HTTP method (GET, POST, PUT, DELETE).
 * @param completion     Useful to do a treatment when the request is ended.
 *
 * @return The request identifier.
 *
 * @author Walid Kayhal
 */
- (NSNumber *)requestWithUrl:(NSString *)url method:(WKRequestMethod)method completion:(CompletionHandler)completion;


/**
 * Execute an HTTP request.
 *
 * @param url                   URL to reach.
 * @param parameters            Parameters to sent to the webservice.
 * @param method                HTTP method (GET, POST, PUT, DELETE).
 * @param completion     Useful to do a treatment when the request is ended.
 *
 * @return The request identifier.
 *
 * @author Walid Kayhal
 */
- (NSNumber *)requestWithUrl:(NSString *)url parameters:(id)parameters method:(WKRequestMethod)method completion:(CompletionHandler)completion;


/**
 * Execute an HTTP request with authentication.
 *
 * @param url                   URL to reach.
 * @param method                La methode HTTP désirée (GET, POST, PUT, DELETE).
 * @param credential            Credential to get the webservice's token.
 * @param completion     Useful to do a treatment when the request is ended.
 *
 * @return The request identifier.
 *
 * @author Walid Kayhal
 */
- (NSNumber *)requestWithUrl:(NSString *)url method:(WKRequestMethod)method credential:(WKRequestCredential *)credential completion:(CompletionHandler)completion;


/** Cancel all requests which are currently running 
 *
 * @return An integer that represents the number of requests canceled
 *
 * @author Walid Kayhal
 */
- (NSUInteger)cancelAllRequests;

/** Cancel requests for an identifier given
 *
 * @param identifier    The request identifier to cancel.
 *
 * @return An integer that represents the number of requests canceled
 *
 * @author Walid Kayhal
 */
- (NSUInteger)cancelRequestWithIdentifier:(NSInteger)identifier;


/**
 * Permits to execute a TCP request
 *
 * @param hostname The target
 * @param port The target port
 * @param data Data to send to the target
 * @param completion Useful to do a treatment when the request is ended
 *
 * @author Walid Kayhal
 */
- (void)requestForStreamWithHostname:(NSString *)hostname port:(NSInteger)port data:(NSString *)data completion:(void(^)(NSError *))completion;


@end

