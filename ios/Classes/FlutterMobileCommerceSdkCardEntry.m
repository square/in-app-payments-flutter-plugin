#import "FlutterMobileCommerceSdkCardEntry.h"
#import "FlutterMobileCommerceSdkErrorUtilities.h"
#import "Converters/SQMCCardEntryResult+FlutterMobileCommerceSdkAdditions.h"

@interface FlutterMobileCommerceSdkCardEntry()

@property (strong, readwrite) FlutterMethodChannel* channel;
@property (strong, readwrite) SQMCTheme *theme;

@end

@implementation FlutterMobileCommerceSdkCardEntry

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
    self.theme = [[SQMCTheme alloc] init];
}

- (void)startCardEntryFlow:(FlutterResult)result
{
    SQMCCardEntryViewController *cardEntryForm = [self _makeCardEntryForm];
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

- (void)showCardProcessingError:(FlutterResult)result errorMessage:(NSString *)errorMessage
{
    result(FlutterMethodNotImplemented);
}

- (void)setFormTheme:(FlutterResult)result themeParameters:(NSDictionary *)themeParameters
{
    result(FlutterMethodNotImplemented);
}

#pragma mark - Private Methods
- (SQMCCardEntryViewController *)_makeCardEntryForm;
{
    return [[SQMCCardEntryViewController alloc] initWithTheme:self.theme];
}

@end
