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

@class SQIPCardDetails;
@class SQIPCardEntryViewController;
@class SQIPTheme;

typedef NS_ENUM(NSUInteger, SQIPCardEntryCompletionStatus) {
    SQIPCardEntryCompletionStatusCanceled = 0,
    SQIPCardEntryCompletionStatusSuccess,
};

/**
 The delegate of a `SQIPCardEntryViewController` instance must adopt the `SQIPCardEntryViewControllerDelegate` protocol.
 */
@protocol SQIPCardEntryViewControllerDelegate

/**
 This method is called after the user has saved their card information. Your implementation should send the provided card details to your server to perform any additional work (for example, charging the card). After you are finished processing the card, you need to notify the card entry view controller of the result.
 
 If your server handled the card successfully, call the completion block with `nil` as the only argument. A success animation will be displayed to the user, and `cardEntryViewController:didCompleteWithStatus:` will be called, at which point you should dismiss the card entry view controller.
 
 If your application encountered an error while processing the card, call the completion block with the error. Its `localizedDescription` will be displayed to the user in the card entry view controller. The user will have an opportunity to edit their card information and re-submit the form.
 
 @param cardEntryViewController The SQIPCardEntryViewController instance.
 @param cardDetails Details about the entered card, including the nonce.
 @param completionHandler The completion handler to be called once you have finished processing the card.
 */
- (void)cardEntryViewController:(nonnull SQIPCardEntryViewController *)cardEntryViewController
           didObtainCardDetails:(nonnull SQIPCardDetails *)cardDetails
              completionHandler:(void (^_Nonnull)(NSError *_Nullable))completionHandler;

/**
 Indicates that the card form has been completed successfully or was canceled.
 
 @param cardEntryViewController The SQIPCardEntryViewController instance.
 @param status The completion status of the card entry view controller.

 Use this method to dismiss the card entry view controller and update any other app state.
 */
- (void)cardEntryViewController:(nonnull SQIPCardEntryViewController *)cardEntryViewController
          didCompleteWithStatus:(SQIPCardEntryCompletionStatus)status;

@end

/**
 Displays a form that lets the user enter their card information. When the user saves their card information, a card nonce is requested and provided to the `delegate`.
 */
@interface SQIPCardEntryViewController : UIViewController

/**
 Creates a new card entry view controller.
 
 @param theme The theme instance used to style the form.
 */
- (nonnull instancetype)initWithTheme:(nonnull SQIPTheme *)theme;

/**
 The object that acts as the delegate of the card entry view controller.
 */
@property (nonatomic, weak, nullable) id<SQIPCardEntryViewControllerDelegate> delegate;

/**
 :nodoc:
 `init` is unavailable. Use `-[SQIPCardEntryViewController initWithTheme:]` instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 :nodoc:
 `initWithNibName:bundle:` is unavailable. Use `-[SQIPCardEntryViewController initWithTheme:]` instead.
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/**
 :nodoc:
 `initWithCoder:` is unavailable. Use `-[SQIPCardEntryViewController initWithTheme:]` instead.
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 :nodoc:
 `new` is unavailable. Use `-[SQIPCardEntryViewController initWithTheme:]` instead.
 */
+ (instancetype)new NS_UNAVAILABLE;

@end
