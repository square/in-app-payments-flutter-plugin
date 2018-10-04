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

/**
 Manages initialization for Square Mobile Commerce SDK.
 @warning You must initialize the SDK before attempting any other operation.
 */
@interface SQMCMobileCommerceSDK : NSObject

/**
 Initializes Square Mobile Commerce SDK.
 Call this method from the `application:didFinishLaunchingWithOptions:` method in your app delegate.
 @warning You must initialize the SDK before attempting any other operation, or your app will crash.
 */
+ (void)initializeWithApplicationID:(nonnull NSString *)applicationID NS_SWIFT_NAME(initialize(applicationID:));

/**
 Returns `true` if the device supports Apple Pay and the user has added a compatible card; otherwise, `false`.
 */
@property (class, nonatomic, readonly) BOOL canUseApplePay;

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
