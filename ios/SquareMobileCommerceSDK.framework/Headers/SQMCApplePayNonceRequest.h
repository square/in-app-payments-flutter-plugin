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

@class PKPayment;
@class SQMCApplePayNonceResult;

/**
 A completion handler that handles the result of an Apple Pay nonce request.
 @param result The result when the nonce request succeeds; otherwise, `nil`.
 @param error An error with domain `SQMCApplePayNonceRequestErrorDomain` when the nonce request fails; otherwise, `nil`. See `SQMCApplePayNonceRequestError` for possible error types.
 */
typedef void (^SQMCApplePayNonceRequestCompletionHandler)(SQMCApplePayNonceResult *_Nullable result, NSError *_Nullable error);


/**
 Lets the application retrieve a card nonce using a PKPayment instance obtained from Apple Pay.
 */
@interface SQMCApplePayNonceRequest : NSObject

/**
 Creates a new Apple Pay nonce request.
 
 @param payment The PKPayment that should be used to request a nonce.
 */
- (nonnull instancetype)initWithPayment:(nonnull PKPayment *)payment;

/**
 Performs the request to retrieve a card nonce.
 
 @param completionHandler The completion handler to be called upon success or failure of the nonce request.
 */
- (void)performWithCompletionHandler:(nonnull SQMCApplePayNonceRequestCompletionHandler)completionHandler;

/**
 :nodoc:
 `init` is unavailable. Use `-[SQMCApplePayNonceRequest initWithPayment:]` instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 :nodoc:
 `new` is unavailable. Use `-[SQMCApplePayNonceRequest initWithPayment:]` instead.
 */
+ (instancetype)new NS_UNAVAILABLE;

@end
