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


/**
 Indicates the result of card entry.
 */
typedef NS_ENUM(NSUInteger, SQIPCardEntryCompletionStatus) {

    /** Card entry was canceled by the customer. */
    SQIPCardEntryCompletionStatusCanceled = 0,

    /** Card entry was completed successfully. */
    SQIPCardEntryCompletionStatusSuccess,
};

/**
 The delegate of a `SQIPCardEntryViewController` instance must adopt the `SQIPCardEntryViewControllerDelegate` protocol.
 */
@protocol SQIPCardEntryViewControllerDelegate

/**
 Invoked after the customer has submitted their card information. Your implementation should send the provided card details to your server to perform any additional work (for example, charging the card). After you are finished processing the card, notify the card entry view controller of the result so it can be displayed to the customer.
 
 If your server successfully processed the card, call the completion handler with `nil` as the only argument. A success animation will be displayed to the customer, and `cardEntryViewController:didCompleteWithStatus:` will be called, at which point you should dismiss the card entry view controller.
 
 If your application encountered an error while processing the card, call the completion handler with the error. Its `localizedDescription` will be displayed to the customer in the card entry view controller. The customer will have an opportunity to edit their card information and re-submit.
 
 @param cardEntryViewController The SQIPCardEntryViewController instance.
 @param cardDetails Details about the entered card, including the nonce.
 @param completionHandler The completion handler to be called once you have finished processing the card.
 */
- (void)cardEntryViewController:(nonnull SQIPCardEntryViewController *)cardEntryViewController
           didObtainCardDetails:(nonnull SQIPCardDetails *)cardDetails
              completionHandler:(void (^_Nonnull)(NSError *_Nullable))completionHandler;

/**
 Invoked when the card entry form has been completed. The `status` parameter indicates whether card entry succeeded or was cancelled.
 Use this method to dismiss the card entry view controller and update any other app state.
 
 @param cardEntryViewController The SQIPCardEntryViewController instance.
 @param status The card entry completion status.

 */
- (void)cardEntryViewController:(nonnull SQIPCardEntryViewController *)cardEntryViewController
          didCompleteWithStatus:(SQIPCardEntryCompletionStatus)status;

@end

/**
 Lets the application collect card information from the customer. If the card information entered is valid, a card nonce will be provided to the `delegate`.
 */
@interface SQIPCardEntryViewController : UIViewController

/**
 Creates a new card entry view controller.
 
 @param theme The theme instance used to style the card entry view controller.
 */
- (nonnull instancetype)initWithTheme:(nonnull SQIPTheme *)theme;

/**
 The object that acts as the delegate of the card entry view controller.
 */
@property (nonatomic, weak, nullable) id<SQIPCardEntryViewControllerDelegate> delegate;

/**
 Indicates that the customer must enter the postal code associated with their payment card. When false, the postal code field will not be displayed.
 
 Defaults to `true`.
 
 @note Postal code collection is required for processing payments for Square accounts based in the United States, Canada, and United Kingdom. Disabling postal code collection in those regions will result in all credit card transactions being declined.
 */
@property (nonatomic, assign) BOOL collectPostalCode;

/**
 :nodoc:
 `init` is unavailable. Use `-[SQIPCardEntryViewController initWithTheme:]` instead.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 :nodoc:
 `initWithNibName:bundle:` is unavailable. Use `-[SQIPCardEntryViewController initWithTheme:]` instead.
 */
- (nonnull instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/**
 :nodoc:
 `initWithCoder:` is unavailable. Use `-[SQIPCardEntryViewController initWithTheme:]` instead.
 */
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 :nodoc:
 `new` is unavailable. Use `-[SQIPCardEntryViewController initWithTheme:]` instead.
 */
+ (nonnull instancetype) new NS_UNAVAILABLE;

@end
