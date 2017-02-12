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

#import "WKRequestCredential.h"

//--------------------------------------------------------------------------------------------------
static WKRequestCredential *instance;
//--------------------------------------------------------------------------------------------------

@implementation WKRequestCredential

//--------------------------------------------------------------------------------------------------
#pragma mark - Constructors
//--------------------------------------------------------------------------------------------------

+(WKRequestCredential *)sharedInstance
{
    if(!instance) instance = [[WKRequestCredential alloc] initPrivate];
    
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

//--------------------------------------------------------------------------------------------------
#pragma mark - Public methods
//--------------------------------------------------------------------------------------------------

- (instancetype)initWithGrantType:(NSString *)grantType username:(NSString *)username password:(NSString *)password
{
    if(!instance) instance = [[WKRequestCredential alloc] initPrivate];
    
    instance.grantType = grantType;
    instance.username = username;
    instance.password = password;
    
    return instance;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Getters & Setters
//--------------------------------------------------------------------------------------------------

-(NSString *)grantType
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"grant_type"];
}

-(void)setGrantType:(NSString *)grantType
{
    [[NSUserDefaults standardUserDefaults] setObject:grantType forKey:@"grant_type"];
}

//--------------------------------------------------------------------------------------------------

-(NSString *)username
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

-(void)setUsername:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
}

//--------------------------------------------------------------------------------------------------

-(NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

-(void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

@end
