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

#import <UIKit/UIKit.h>

@class SQMCCardEntryResult;
@class SQMCCardEntryViewController;
@class SQMCTheme;

/**
 The delegate of a `SQMCCardEntryViewController` instance must adopt the `SQMCCardEntryViewControllerDelegate` protocol.
 */
@protocol SQMCCardEntryViewControllerDelegate

/**
 Indicates that the card form was completed and a nonce was obtained.
 
 @param cardEntryViewController The SQMCCardEntryViewController instance.
 @param result Contains a card nonce and details about the entered card.
 
 @note You should dismiss the card entry view controller when this method is called.
 */
- (void)cardEntryViewController:(nonnull SQMCCardEntryViewController *)cardEntryViewController didSucceedWithResult:(nonnull SQMCCardEntryResult *)result;

/**
 Indicates that the user tapped the cancel button.
 
 @param cardEntryViewController The SQMCCardEntryViewController instance.
 
 @note You should dismiss the card entry view controller when this method is called.
 */
- (void)cardEntryViewControllerDidCancel:(nonnull SQMCCardEntryViewController *)cardEntryViewController;

@end

/**
 Displays a form that lets the user enter their card information. When the user submits their card information, a card nonce is requested and provided to the `delegate`.
 */
@interface SQMCCardEntryViewController : UIViewController

/**
 Creates a new card entry view controller.
 
 @param theme The theme instance used to style the form.
 */
- (nonnull instancetype)initWithTheme:(nonnull SQMCTheme *)theme NS_DESIGNATED_INITIALIZER;

/**
 The object that acts as the delegate of the card entry view controller.
 */
@property (nonatomic, weak, nullable) id<SQMCCardEntryViewControllerDelegate> delegate;

/**
 :nodoc:
 `init` is unavailable. Use `-[SQMCCardEntryViewController initWithTheme:]` instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 :nodoc:
 `initWithNibName:bundle:` is unavailable. Use `-[SQMCCardEntryViewController initWithTheme:]` instead.
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/**
 :nodoc:
 `initWithCoder:` is unavailable. Use `-[SQMCCardEntryViewController initWithTheme:]` instead.
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 :nodoc:
 `new` is unavailable. Use `-[SQMCCardEntryViewController initWithTheme:]` instead.
 */
+ (instancetype)new NS_UNAVAILABLE;

@end
