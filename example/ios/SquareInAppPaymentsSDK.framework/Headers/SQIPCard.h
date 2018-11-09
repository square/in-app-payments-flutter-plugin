//
//    Copyright (c) 2018-present, Square, Inc. All rights reserved.
//
//    Your use of this software is subject to the Square Developer Terms of
//    Service (https://squareup.com/legal/developers). This copyright notice shall
//    be included in all copies or substantial portions of the software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#import <SquareInAppPaymentsSDK/SQIPCardBrand.h>

/**
 Represents the non-confidential details of a payment card.
 */
@interface SQIPCard : NSObject <NSCopying>

/**
 The card brand (for example, Visa).
 */
@property (nonatomic, assign, readonly) SQIPCardBrand brand;

/**
 The last four digits of the card number.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *lastFourDigits;

/**
 The month of the card's expiration date. This value is always between 1 and 12, inclusive.
 */
@property (nonatomic, assign, readonly) NSUInteger expirationMonth;

/**
 The four-digit year of the card's expiration date.
 */
@property (nonatomic, assign, readonly) NSUInteger expirationYear;

/**
 The billing postal code, if available.
 */
@property (nonatomic, strong, readonly, nullable) NSString *postalCode;

/**
 :nodoc:
 `init` is unavailable.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 :nodoc:
 `new` is unavailable.
 */
+ (instancetype)new NS_UNAVAILABLE;

@end
