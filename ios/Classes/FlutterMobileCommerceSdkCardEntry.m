#import "FlutterMobileCommerceSdkCardEntry.h"
#import "FlutterMobileCommerceSdkErrorUtilities.h"
#import "Converters/SQMCCardEntryResult+FlutterMobileCommerceSdkAdditions.h"

@interface FlutterMobileCommerceSdkCardEntry()

@property (strong, readwrite) FlutterMethodChannel* channel;
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

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
    self.theme = [[SQMCTheme alloc] init];
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
    result(nil);
}

- (SQMCCardEntryViewController *)makeCardEntryForm;
{
    return [[SQMCCardEntryViewController alloc] initWithTheme:self.theme];
}

- (void)cardEntryViewControllerDidCancel:(nonnull SQMCCardEntryViewController *)cardEntryViewController
{
    [self.channel invokeMethod:@"cardEntryDidCancel" arguments:nil];
}

- (void)cardEntryViewController:(nonnull SQMCCardEntryViewController *)cardEntryViewController didSucceedWithResult:(nonnull SQMCCardEntryResult *)result
{
    [self.channel invokeMethod:@"cardEntryDidSucceedWithResult" arguments:[result jsonDictionary]];
}

- (void)closeCardEntryForm:(FlutterResult)result
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    result(nil);
}

- (void)setFormTheme:(FlutterResult)result themeParameters:(NSDictionary *)themeParameters
{
    result(FlutterMethodNotImplemented);
}

@end
