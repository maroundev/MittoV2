//
//  MAppDelegate.m
//  Mitto
//
//  Created by Maroun Abi ramia on 8/23/14.
//  Copyright (c) 2014 MAR. All rights reserved.
//

#import "MAppDelegate.h"
#import <FYX/FYX.h>
#import <FYX/FYXLogging.h>

@implementation MAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Opacity Bar.png"] forBarMetrics:UIBarMetricsDefault];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
   // [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:19.0/255.0 green:46.0/255.0 blue:64.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Century Gothic" size:21.0], NSFontAttributeName, nil]];

    
    
    [self registerInitialValuesForUserDefaults];
    
    [FYX setAppId:@"c103e34936c21944dc1ab577d382838cbc489427d8ce5c4b8f238999b081ea74"
        appSecret:@"8fa1e4d469c17469503d1ba251bc86f69e0369b1dee2f48cf2d843703a6f4e2d"
      callbackUrl:@"testfindmystuff://authcode"];
    [FYXLogging setLogLevel:FYX_LOG_LEVEL_INFO];
    
  /*  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    if ([self isProximityEnabled])
    {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    }
    else
    {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoadingPage"];
    }*/
    
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)isProximityEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"fyx_service_started_key"];
}


- (void)registerInitialValuesForUserDefaults {
    
    // Get the path of the settings bundle (Settings.bundle)
    NSString *settingsBundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if (!settingsBundlePath) {
        NSLog(@"ERROR: Unable to locate Settings.bundle within the application bundle!");
        return;
    }
    
    // Get the path of the settings plist (Root.plist) within the settings bundle
    NSString *settingsPlistPath = [[NSBundle bundleWithPath:settingsBundlePath] pathForResource:@"Root" ofType:@"plist"];
    if (!settingsPlistPath) {
        NSLog(@"ERROR: Unable to locate Root.plist within Settings.bundle!");
        return;
    }
    
    // Create a new dictionary to hold the default values to register
    NSMutableDictionary *defaultValuesToRegister = [NSMutableDictionary new];
    
    // Iterate over the preferences found in the settings plist
    NSArray *preferenceSpecifiers = [[NSDictionary dictionaryWithContentsOfFile:settingsPlistPath] objectForKey:@"PreferenceSpecifiers"];
    for (NSDictionary *preference in preferenceSpecifiers) {
        
        NSString *key = [preference objectForKey:@"Key"];
        id defaultValueObject = [preference objectForKey:@"DefaultValue"];
        
        if (key && defaultValueObject) {
            // If a default value was found, add it to the dictionary
            [defaultValuesToRegister setObject:defaultValueObject forKey:key];
        }
    }
    
    // Register the initial values in UserDefaults that were found in the settings bundle
    if (defaultValuesToRegister.count > 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults registerDefaults:defaultValuesToRegister];
        [userDefaults synchronize];
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
