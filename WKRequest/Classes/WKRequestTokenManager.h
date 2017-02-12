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

/**
 * Permet de stocker un token durant sa validité.
 *
 * @author Walid Kayhal
 */
@interface WKRequestTokenManager : NSObject

@property (nonatomic, strong, getter=token) NSString *accessToken;
@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, assign) NSInteger expiresIn;

@property (nonatomic, assign, getter=isExpired) BOOL expired;

//--------------------------------------------------------------------------------------------------
+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;
//--------------------------------------------------------------------------------------------------

/**
 * Permet de récupérer le singleton.
 *
 * @return l'intance.
 *
 * @author Walid Kayhal
 */
+(WKRequestTokenManager *)sharedInstance;


/**
 * Constructeur.
 *
 * @param data Les donneés.
 * @return L'instance.
 *
 * @author Walid Kayhal
 */
- (instancetype)initWithData:(NSData *)data;


/**
 * Constructeur.
 *
 * @param data Les d'initialiser les propriétes avec certaines données.
 * @return L'instance.
 *
 * @author Walid Kayhal
 */
-(void)initializeWithData:(NSData *)data;


@end
