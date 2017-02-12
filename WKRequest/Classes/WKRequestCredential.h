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
 * Permet spécifier le username et le mot de passe d'une requête (authentification OAuth 2).
 *
 * @author Walid Kayhal
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface WKRequestCredential : NSObject

@property (nonatomic, strong) NSString *grantType;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

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
+(WKRequestCredential *)sharedInstance;

/**
 * Permet d'initialiser le singleton.
 *
 * @param grantType Le type d'authentification.
 * @return l'instance.
 *
 * @author Walid Kayhal
 */
- (instancetype)initWithGrantType:(NSString *)grantType username:(NSString *)username password:(NSString *)password;

@end
