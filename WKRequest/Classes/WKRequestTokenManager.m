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

#import "WKRequestTokenManager.h"

//--------------------------------------------------------------------------------------------------

static const NSInteger kWKRequestTokenManager_DayStroke = 1;

static NSString * const kWKRequestTokenManager_UserDefaults_ExpireIn       = @"kWKRequestTokenManager_UserDefaults_ExpireIn";
static NSString * const kWKRequestTokenManager_UserDefaults_AccessToken    = @"kWKRequestTokenManager_UserDefaults_AccessToken";
static NSString * const kWKRequestTokenManager_UserDefaults_TokenType      = @"kWKRequestTokenManager_UserDefaults_TokenType";

//--------------------------------------------------------------------------------------------------

static WKRequestTokenManager *instance;

//--------------------------------------------------------------------------------------------------

@implementation WKRequestTokenManager

//--------------------------------------------------------------------------------------------------
#pragma mark - Constructors
//--------------------------------------------------------------------------------------------------

+(WKRequestTokenManager *)sharedInstance
{
    if(!instance) instance = [[WKRequestTokenManager alloc] initPrivate];
    
    return instance;
}

- (instancetype)initPrivate
{
    if(!instance)
    {
        instance = [super init];
    }
    
    return instance;
}

- (instancetype)initWithData:(NSData *)data
{
    (void)[self initPrivate];
    
    [self initializeWithData:data];
    
    return instance;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Public
//--------------------------------------------------------------------------------------------------

-(void)initializeWithData:(NSData *)data
{
    if(!data) return;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    instance.accessToken    = json[@"access_token"];
    instance.tokenType      = json[@"token_type"];
    instance.expiresIn      = [json[@"expires_in"] integerValue];
}


//--------------------------------------------------------------------------------------------------
#pragma mark - Getters & Setters
//--------------------------------------------------------------------------------------------------

-(BOOL)isExpired
{
    // La marge à ne pas dépasser, ici "kWKRequestTokenManager_DayStroke" jour. Quand je detecte qu'il reste "kWKRequestTokenManager_DayStroke" jour je redemande un token.
    static const NSInteger stroke = (3600 * 24) * kWKRequestTokenManager_DayStroke;
    
    NSInteger tokenAvailabilityTimeStamp = instance.expiresIn;
    NSInteger currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    
    return tokenAvailabilityTimeStamp <= (currentTimeStamp + stroke) ? YES : NO;
}

//--------------------------------------------------------------------------------------------------

-(NSInteger)expiresIn
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kWKRequestTokenManager_UserDefaults_ExpireIn];
}

-(void)setExpiresIn:(NSInteger)expiresIn
{
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
    
    [[NSUserDefaults standardUserDefaults] setInteger:(expiresIn + timestamp) forKey:kWKRequestTokenManager_UserDefaults_ExpireIn];
}

//--------------------------------------------------------------------------------------------------

-(NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kWKRequestTokenManager_UserDefaults_AccessToken];
}

-(void)setAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kWKRequestTokenManager_UserDefaults_AccessToken];
}

//--------------------------------------------------------------------------------------------------

-(NSString *)tokenType
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kWKRequestTokenManager_UserDefaults_TokenType];
}

-(void)setTokenType:(NSString *)tokenType
{
    [[NSUserDefaults standardUserDefaults] setObject:tokenType forKey:kWKRequestTokenManager_UserDefaults_TokenType];
}

//--------------------------------------------------------------------------------------------------

@end
