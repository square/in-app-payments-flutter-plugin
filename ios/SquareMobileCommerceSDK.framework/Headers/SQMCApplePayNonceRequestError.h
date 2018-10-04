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
#import <SquareMobileCommerceSDK/SQMCErrorConstants.h>


/**
 The domain for errors that occur when requesting a nonce using Apple Pay.
 */
extern NSString *_Nonnull const SQMCApplePayNonceRequestErrorDomain;

/**
 The types of errors that can occur when requesting a nonce using Apple Pay.
 */
SQMC_ERROR_ENUM(SQMCApplePayNonceRequestErrorDomain, SQMCApplePayNonceRequestError){
    
    /**
     Square Mobile Commerce SDK could not connect to the network.
     */
    SQMCApplePayNonceRequestErrorNoNetwork = 1,
    
    /**
     The card information provided is invalid.
     */
    SQMCApplePayNonceRequestErrorInvalidCard,
    
    /**
     The card provided is not supported.
     */
    SQMCApplePayNonceRequestErrorUnsupportedCard,
    
    /**
     `SQMCApplePayNonceRequest` was used in an unexpected or unsupported way.
     See `userInfo[SQMCErrorDebugCodeKey]` and `userInfo[SQMCErrorDebugMessageKey]` for more information.
     */
    SQMCApplePayNonceRequestErrorUsageError,
};
