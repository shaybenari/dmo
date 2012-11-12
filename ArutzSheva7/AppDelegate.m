//
//  AppDelegate.m
//  arutz7
//
//  Created by Admin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "../MySHKConfigurator.h"
#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#define PRIVATEURL @"http://www.inn.co.il/wap/imapp.aspx"
#define UPDATEURL @"http://www.inn.co.il/wap/JS.ashx?act=loginios"
@implementation AppDelegate

@synthesize window = _window;
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"My token is: %@", deviceToken);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* oldtoken = [prefs stringForKey:@"token"];
    NSString* randnumber = [prefs stringForKey:@"random"];
    
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [prefs setObject:newToken forKey:@"token"];
    [prefs synchronize];
    
    if(randnumber.length<1){
        
        ViewController* vc= ((ViewController*)self.window.rootViewController);
        [vc showBar];
        
    }
    
    
    
    else
        if(![oldtoken isEqualToString:newToken]){
            NSString* idnumber = [prefs stringForKey:@"id"];
            NSString* session = [prefs stringForKey:@"session"];
            
            NSString *post = [NSString stringWithFormat:@"userid=%@&usercode=%@&session=%@&token=%@",idnumber,randnumber,session,newToken];
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSURL *kjsonURL = [NSURL URLWithString:UPDATEURL];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kjsonURL];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:postData];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)  {
                
                if(((NSHTTPURLResponse*)response).statusCode==200) {
                }
            }];
        }
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    
    NSString *message = nil;
    id alert = [userInfo objectForKey:@"aps"];
    if ([alert isKindOfClass:[NSString class]]) {
        message = alert;
    } else if ([alert isKindOfClass:[NSDictionary class]]) {
        message = [alert objectForKey:@"alert"];
    }
    if (alert) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"הודעה חדשה מערוץ 7",nil)
                                                            message:message  delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    NSString* type = [userInfo objectForKey:@"type"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* randnumber = [prefs stringForKey:@"random"];
    NSString* idnumber = [prefs stringForKey:@"id"];
    NSString* session = [prefs stringForKey:@"session"];
    NSString* token = [prefs stringForKey:@"token"];
    ViewController* vc= ((ViewController*)self.window.rootViewController);
    //    NSString* link = [[userInfo valueForKey:@"aps"] valueForKey:@"link"];
    //    NSString *fulllink = [NSString stringWithFormat:@"%@%@",PRIVATEURL,link];
    [vc loadPage:PRIVATEURL withPostData:[NSString stringWithFormat:@"userid=%@&usercode=%@&session=%@&token=%@&type=%@",idnumber,randnumber,session,token,type]];
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //UIImageView * myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgkarov.jpg"]];
    
    //[self.window.rootViewController.view addSubview:myGraphic];
    //[self.window.rootViewController.view sendSubviewToBack:myGraphic];
    
    ////self.window.rootViewController = self.viewController;
    //[_window makeKeyAndVisible];
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
    // (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //NSLog(@"Registering for push notifications...");
   /* if (launchOptions != nil)
	{
        
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"Launched from push notification: %@", dictionary);
        if (dictionary != nil)
		{
            NSString* message = [[dictionary objectForKey:@"aps" ] objectForKey:@"alert"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"הודעה חדשה מערוץ 7",nil)
                                                                message:message  delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                      otherButtonTitles:nil];
            [alertView show];
            
            
            NSString* type = [dictionary valueForKey:@"type"];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString* randnumber = [prefs stringForKey:@"random"];
            NSString* idnumber = [prefs stringForKey:@"id"];
            NSString* session = [prefs stringForKey:@"session"];
            NSString* token = [prefs stringForKey:@"token"];
            ViewController* vc= ((ViewController*)self.window.rootViewController);
            //    NSString* link = [[userInfo valueForKey:@"aps"] valueForKey:@"link"];
            //    NSString *fulllink = [NSString stringWithFormat:@"%@%@",PRIVATEURL,link];
            [vc loadPage:PRIVATEURL withPostData:[NSString stringWithFormat:@"userid=%@&usercode=%@&session=%@&token=%@&type=%@",idnumber,randnumber,session,token,type]];
		}
	}
    DefaultSHKConfigurator *configurator = [[MySHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];*/
    return YES;
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
- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}
@end
