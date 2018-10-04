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

#import <PassKit/PassKit.h>

/**
 PKPaymentRequest additions for using Apple Pay with Square.
 */
@interface PKPaymentRequest (Square)

/**
 Creates a PKPaymentRequest instance with Square-supported networks and merchant capabilities.
 
 @param merchantIdentifier Your merchant identifier. This must be one of the Merchant IDs associated with your Apple Developer account.
 @param countryCode The two-letter ISO 3166 country code for the country where the payment will be processed. E.g. "US".
 @param currencyCode The three-letter ISO 4217 currency code. E.g. "USD".
 */
+ (nonnull PKPaymentRequest *)squarePaymentRequestWithMerchantIdentifier:(nonnull NSString *)merchantIdentifier
                                                             countryCode:(nonnull NSString *)countryCode
                                                            currencyCode:(nonnull NSString *)currencyCode NS_SWIFT_NAME(squarePaymentRequest(merchantIdentifier:countryCode:currencyCode:));

@end
