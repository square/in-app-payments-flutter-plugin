#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@import SquareMobileCommerceSDK;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [SQMCMobileCommerceSDK initializeWithApplicationID:@"sq0idp-aDbtFl--b2VU5pcqQD7wmg"];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
