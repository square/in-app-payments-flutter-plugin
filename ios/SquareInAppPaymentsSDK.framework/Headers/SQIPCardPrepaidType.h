#pragma Formatter Exempt

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
 Indicates if a card is prepaid.
 :nodoc:
 */
typedef NS_ENUM(NSUInteger, SQIPCardPrepaidType) {
    /** Unable to determine whether the card is prepaid or not. */
    SQIPCardPrepaidTypeUnknown,

    /** Card that is not prepaid */
    SQIPCardPrepaidTypeNotPrepaid,

    /** Prepaid card */
    SQIPCardPrepaidTypePrepaid,
};

/**
 Creates a SQIPCardPrepaidType from a string. i.e. "PREPAID" -> SQIPCardPrepaidTypePrepaid.
 :nodoc:
 */
extern SQIPCardPrepaidType SQIPCardPrepaidTypeFromString(NSString *_Nullable prepaidType) CF_SWIFT_NAME(SQIPCardPrepaidType.init(_:));

/**
 Creates a string from a SQIPCardPrepaidType. i.e. SQIPCardPrepaidTypePrepaid -> "PREPAID".
 :nodoc:
 */
extern NSString *_Nonnull NSStringFromSQIPCardPrepaidType(SQIPCardPrepaidType prepaidType) CF_SWIFT_NAME(getter:SQIPCardPrepaidType.description(self:));
