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
typedef NS_ENUM(NSUInteger, SQMCCardBrand) {
    
    /** An unidentified brand. */
    SQMCCardBrandOther = 0,
    
    /** Visa */
    SQMCCardBrandVisa,
    
    /** Mastercard */
    SQMCCardBrandMastercard,
    
    /** American Express */
    SQMCCardBrandAmericanExpress,
    
    /** Discover */
    SQMCCardBrandDiscover,
    
    /** Diners Club International */
    SQMCCardBrandDiscoverDiners,
    
   /** JCB */
    SQMCCardBrandJCB,
    
    /** China UnionPay */
    SQMCCardBrandChinaUnionPay,
};

/**
 Creates an SQMCCardBrand from a string. i.e. "VISA" -> SQMCCardBrandVisa
 */
extern SQMCCardBrand SQMCCardBrandFromString(NSString * _Nonnull cardBrand) CF_SWIFT_NAME(SQMCCardBrand.init(_:));

/**
 Creates a string from an SQMCCardBrand. i.e. SQMCCardBrandVisa -> "VISA"
 */
extern NSString * _Nonnull NSStringFromSQMCCardBrand(SQMCCardBrand cardBrand) CF_SWIFT_NAME(getter:SQMCCardBrand.description(self:));
