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

@class SQIPCard;

/**
 Represents the result of a successful operation to process card payment information.
 */
@interface SQIPCardDetails : NSObject

/**
 A one-time-use payment token that is used with the Transactions API to [charge the card](https://docs.connect.squareup.com/api/connect/v2#endpoint-charge) or the Customers API to [store the Card on File](https://docs.connect.squareup.com/api/connect/v2#endpoint-createcustomercard).
 */
@property (nonatomic, strong, readonly, nonnull) NSString *nonce;

/**
 The payment card.
 */
@property (nonatomic, strong, readonly, nonnull) SQIPCard *card;

/**
 :nodoc:
 `init` is unavailable.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 :nodoc:
 `new` is unavailable.
 */
+ (instancetype) new NS_UNAVAILABLE;

@end
