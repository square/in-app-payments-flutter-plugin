#import "FlutterMobileCommerceSdkCardEntry.h"
#import "FlutterMobileCommerceSdkErrorUtilities.h"
#import "Converters/SQMCCardEntryResult+FlutterMobileCommerceSdkAdditions.h"

@interface FlutterMobileCommerceSdkCardEntry()

@property (strong, readwrite) FlutterResult cardEntryResolver;
@property (strong, readwrite) SQMCTheme *theme;

@end

// Define all the error codes and messages below
// These error codes and messages **MUST** align with iOS error codes and dart error codes
// Search KEEP_IN_SYNC_CHECKOUT_ERROR to update all places

// flutter plugin expected errors
static NSString *const FlutterMobileCommerceCardEntryCanceled = @"fl_card_entry_canceled";

// flutter plugin debug error codes
static NSString *const FlutterMobileCommerceCardEntryAlreadyInProgress = @"fl_card_entry_already_in_progress";

// flutter plugin debug messages
static NSString *const FlutterMobileCommerceMessageCardEntryAlreadyInProgress = @"A card entry flow is already in progress. Ensure that the in-progress card entry flow is completed before calling startCardEntryFlow again.";
static NSString *const FlutterMobileCommerceMessageCardEntryCanceled = @"The card entry flow is canceled";

@implementation FlutterMobileCommerceSdkCardEntry

- (instancetype)init
{
    self.theme = [[SQMCTheme alloc] init];
    return self;
}

- (void)startCardEntryFlow:(FlutterResult)result
{
    if (self.cardEntryResolver != nil) {
        result([FlutterError errorWithCode:FlutterMobileCommerceUsageError
                                   message:[FlutterMobileCommerceSdkErrorUtilities getPluginErrorMessage:FlutterMobileCommerceCardEntryAlreadyInProgress]
                                   details:[FlutterMobileCommerceSdkErrorUtilities getDebugErrorObject:FlutterMobileCommerceCardEntryAlreadyInProgress debugMessage:FlutterMobileCommerceMessageCardEntryAlreadyInProgress]]);
        return;
    }
    SQMCCardEntryViewController *cardEntryForm = [self makeCardEntryForm];
    cardEntryForm.delegate = self;

    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController*)rootViewController) pushViewController:cardEntryForm animated:YES];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cardEntryForm];
        [rootViewController presentViewController:navigationController animated:YES completion:nil];
    }
    self.cardEntryResolver = result;
}

- (SQMCCardEntryViewController *)makeCardEntryForm;
{
    return [[SQMCCardEntryViewController alloc] initWithTheme:self.theme];
}

- (void)cardEntryViewControllerDidCancel:(nonnull SQMCCardEntryViewController *)cardEntryViewController
{
    NSAssert(self.cardEntryResolver != nil, @"The card entry resolver has been released");
    self.cardEntryResolver([FlutterError errorWithCode:FlutterMobileCommerceCardEntryCanceled
                                               message:[FlutterMobileCommerceSdkErrorUtilities getPluginErrorMessage:FlutterMobileCommerceCardEntryCanceled]
                                               details:[FlutterMobileCommerceSdkErrorUtilities getDebugErrorObject:FlutterMobileCommerceCardEntryCanceled debugMessage:FlutterMobileCommerceMessageCardEntryCanceled]]);
    self.cardEntryResolver = nil;
    [self closeCardEntryForm];
}

- (void)cardEntryViewController:(nonnull SQMCCardEntryViewController *)cardEntryViewController didSucceedWithResult:(nonnull SQMCCardEntryResult *)result
{
    self.cardEntryResolver([result jsonDictionary]);
    self.cardEntryResolver = nil;
    [self closeCardEntryForm];
}

- (void)closeCardEntryForm
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setFormTheme:(FlutterResult)result themeParameters:(NSDictionary *)themeParameters
{
    result(FlutterMethodNotImplemented);
}

@end
