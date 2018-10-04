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

/**
 Encapsulates options used to style SQMCCardEntryViewController.
 */
@interface SQMCTheme : NSObject

/**
 The text field font.
 */
@property (nonatomic, strong, nonnull) UIFont *font;

/**
 The submit button font.
 */
@property (nonatomic, strong, nonnull) UIFont *emphasisFont;

/**
 The background color of the card entry view controller.
 */
@property (nonatomic, strong, nonnull) UIColor *backgroundColor;

/**
 The fill color for text fields.
 */
@property (nonatomic, strong, nonnull) UIColor *foregroundColor;

/**
 The text field text color.
 */
@property (nonatomic, strong, nonnull) UIColor *textColor;

/**
 The text field placeholder text color.
 */
@property (nonatomic, strong, nonnull) UIColor *placeholderTextColor;

/**
 The submit button text color when enabled.
 */
@property (nonatomic, strong, nonnull) UIColor *submitButtonTextColor;

/**
 The tint color reflected in:
 * the text field cursor
 * the submit button background color when enabled.
 */
@property (nonatomic, strong, nonnull) UIColor *tintColor;

/**
 The text color when the text is invalid.
 */
@property (nonatomic, strong, nonnull) UIColor *errorColor;

/**
 The appearance of the keyboard.
 */
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;

@end
