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
 The `NSError` `userInfo` key used to retrieve a detailed debug code string for the error that occurred.
 */
extern NSString *_Nonnull const SQIPErrorDebugCodeKey;

/**
 The `NSError` `userInfo` key used to to retrieve a human-readable message containing additional debug information related to the possible cause of the error.
 Debug messages should not be displayed to customers.
 */
extern NSString *_Nonnull const SQIPErrorDebugMessageKey;

#define SQIP_ERROR_ENUM(_domain, _name)   \
    typedef enum _name : NSInteger _name; \
    enum __attribute__((ns_error_domain(_domain))) _name : NSInteger
