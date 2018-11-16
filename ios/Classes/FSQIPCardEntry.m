#import "FSQIPCardEntry.h"
#import "FSQIPErrorUtilities.h"
#import "Converters/SQIPCardDetails+FSQIPAdditions.h"
#import "Converters/UIFont+FSQIPAdditions.h"
#import "Converters/UIColor+FSQIPAdditions.h"

typedef void (^CompletionHandler)(NSError * _Nullable);

@interface FSQIPCardEntry()

@property (strong, readwrite) FlutterMethodChannel* channel;
@property (strong, readwrite) SQIPTheme *theme;
@property (strong, readwrite) CompletionHandler completionHandler;

@end

@implementation FSQIPCardEntry

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

- (void)showCardNonceProcessingError:(FlutterResult)result errorMessage:(NSString *)errorMessage
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

- (void)setTheme:(FlutterResult)result themeConfiguration:(NSDictionary *)themeConfiguration
{
    // Create a new theme with default value
    self.theme = [[SQIPTheme alloc] init];
    if (themeConfiguration[@"font"]) {
        self.theme.font = [self.theme.font fromJsonDictionary:themeConfiguration[@"font"]];
    }
    if (themeConfiguration[@"emphasisFont"]) {
        self.theme.emphasisFont = [self.theme.emphasisFont fromJsonDictionary:themeConfiguration[@"emphasisFont"]];
    }
    if (themeConfiguration[@"backgroundColor"]) {
        self.theme.backgroundColor = [self.theme.backgroundColor fromJsonDictionary:themeConfiguration[@"backgroundColor"]];
    }
    if (themeConfiguration[@"foregroundColor"]) {
        self.theme.foregroundColor = [self.theme.foregroundColor fromJsonDictionary:themeConfiguration[@"foregroundColor"]];
    }
    if (themeConfiguration[@"textColor"]) {
        self.theme.textColor = [self.theme.textColor fromJsonDictionary:themeConfiguration[@"textColor"]];
    }
    if (themeConfiguration[@"placeholderTextColor"]) {
        self.theme.placeholderTextColor = [self.theme.placeholderTextColor fromJsonDictionary:themeConfiguration[@"placeholderTextColor"]];
    }
    if (themeConfiguration[@"tintColor"]) {
        self.theme.tintColor = [self.theme.tintColor fromJsonDictionary:themeConfiguration[@"tintColor"]];
    }
    if (themeConfiguration[@"messageColor"]) {
        self.theme.messageColor = [self.theme.messageColor fromJsonDictionary:themeConfiguration[@"messageColor"]];
    }
    if (themeConfiguration[@"errorColor"]) {
        self.theme.errorColor = [self.theme.errorColor fromJsonDictionary:themeConfiguration[@"errorColor"]];
    }
    if (themeConfiguration[@"saveButtonTitle"]) {
        self.theme.saveButtonTitle = themeConfiguration[@"saveButtonTitle"];
    }
    if (themeConfiguration[@"saveButtonTextColor"]) {
        self.theme.saveButtonTextColor = [self.theme.saveButtonTextColor fromJsonDictionary:themeConfiguration[@"saveButtonTextColor"]];
    }
    if (themeConfiguration[@"keyboardAppearance"]) {
        self.theme.keyboardAppearance = [self _keyboardAppearanceFromString:themeConfiguration[@"keyboardAppearance"]];
    }
    
    result(nil);
}

#pragma mark - Private Methods
- (SQIPCardEntryViewController *)_makeCardEntryForm
{
    return [[SQIPCardEntryViewController alloc] initWithTheme:self.theme];
}

- (UIKeyboardAppearance)_keyboardAppearanceFromString:(NSString *)keyboardTypeName
{
    if([keyboardTypeName isEqualToString:@"Dark"]) {
        return UIKeyboardAppearanceDark;
    } else if ([keyboardTypeName isEqualToString:@"Light"]) {
        return UIKeyboardAppearanceLight;
    } else {
        return UIKeyboardAppearanceDefault;
    }
}

@end
