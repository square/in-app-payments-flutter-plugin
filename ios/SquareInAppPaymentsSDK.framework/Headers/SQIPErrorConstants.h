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
 The `NSError` `userInfo` key used to retrieve the debug code string for the error that occurred.
 */
extern NSString *_Nonnull const SQIPErrorDebugCodeKey;

/**
 The `NSError` `userInfo` key used to retrieve a detailed description of the error that occurred.
 Debug messages can be helpful when debugging, but are not suitable for displaying to users.
 */
extern NSString *_Nonnull const SQIPErrorDebugMessageKey;

#define sqip_ERROR_ENUM(_domain, _name)   \
typedef enum _name : NSInteger _name; \
enum __attribute__((ns_error_domain(_domain))) _name : NSInteger
