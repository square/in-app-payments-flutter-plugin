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

/** Indicates a card's brand, such as Visa. */
typedef NS_ENUM(NSUInteger, SQIPCardBrand) {
    
    /** An unidentified brand. */
    SQIPCardBrandOtherBrand = 0,
    
    /** Visa */
    SQIPCardBrandVisa,
    
    /** Mastercard */
    SQIPCardBrandMastercard,
    
    /** American Express */
    SQIPCardBrandAmericanExpress,
    
    /** Discover */
    SQIPCardBrandDiscover,
    
    /** Diners Club International */
    SQIPCardBrandDiscoverDiners,
    
   /** JCB */
    SQIPCardBrandJCB,
    
    /** China UnionPay */
    SQIPCardBrandChinaUnionPay,
};

/**
 Creates an SQIPCardBrand from a string. i.e. "VISA" -> SQIPCardBrandVisa
 */
extern SQIPCardBrand SQIPCardBrandFromString(NSString * _Nonnull cardBrand) CF_SWIFT_NAME(SQIPCardBrand.init(_:));

/**
 Creates a string from an SQIPCardBrand. i.e. SQIPCardBrandVisa -> "VISA"
 */
extern NSString * _Nonnull NSStringFromSQIPCardBrand(SQIPCardBrand cardBrand) CF_SWIFT_NAME(getter:SQIPCardBrand.description(self:));
