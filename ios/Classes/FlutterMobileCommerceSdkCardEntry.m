#import "FlutterMobileCommerceSdkCardEntry.h"
#import "FlutterMobileCommerceSdkErrorUtilities.h"
#import "Converters/SQIPCardDetails+FlutterMobileCommerceSdkAdditions.h"

typedef void (^CompletionHandler)(NSError * _Nullable);

@interface FlutterMobileCommerceSdkCardEntry()

@property (strong, readwrite) FlutterMethodChannel* channel;
@property (strong, readwrite) SQIPTheme *theme;
@property (strong, readwrite) CompletionHandler completionHandler;

@end

@implementation FlutterMobileCommerceSdkCardEntry

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
    self.theme = [[SQIPTheme alloc] init];
}

- (void)startCardEntryFlow:(FlutterResult)result
{
    SQIPCardEntryViewController *cardEntryForm = [self _makeCardEntryForm];
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

- (void)cardEntryViewController:(SQIPCardEntryViewController *)cardEntryViewController didObtainCardDetails:(SQIPCardDetails *)cardDetails completionHandler:(CompletionHandler)completionHandler
{
    self.completionHandler = completionHandler;
    [self.channel invokeMethod:@"cardEntryDidObtainCardDetails" arguments:[cardDetails jsonDictionary]];
}

- (void)cardEntryViewController:(SQIPCardEntryViewController *)cardEntryViewController didCompleteWithStatus:(SQIPCardEntryCompletionStatus)status
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
        if (status == SQIPCardEntryCompletionStatusCanceled) {
            [self.channel invokeMethod:@"cardEntryDidCancel" arguments:nil];
        } else {
            [self.channel invokeMethod:@"cardEntryComplete" arguments:nil];
        }
    } else {
        if (status == SQIPCardEntryCompletionStatusCanceled) {
            [rootViewController dismissViewControllerAnimated:YES completion:^{
                [self.channel invokeMethod:@"cardEntryDidCancel" arguments:nil];
            }];
        } else {
            [rootViewController dismissViewControllerAnimated:YES completion:^{
                [self.channel invokeMethod:@"cardEntryComplete" arguments:nil];
            }];
        }
       
    }
}

- (void)completeCardEntry:(FlutterResult)result
{
    if (self.completionHandler) {
        self.completionHandler(nil);
        self.completionHandler = nil;
    }
    result(nil);
}

- (void)showCardProcessingError:(FlutterResult)result errorMessage:(NSString *)errorMessage
{
    if (self.completionHandler) {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)
                                   };
        NSError *error = [NSError errorWithDomain:NSGlobalDomain
                                             code:-57
                                         userInfo:userInfo];
        self.completionHandler(error);
    }
    result(nil);
}

- (void)setFormTheme:(FlutterResult)result themeParameters:(NSDictionary *)themeParameters
{
    result(FlutterMethodNotImplemented);
}

#pragma mark - Private Methods
- (SQIPCardEntryViewController *)_makeCardEntryForm;
{
    return [[SQIPCardEntryViewController alloc] initWithTheme:self.theme];
}

@end
