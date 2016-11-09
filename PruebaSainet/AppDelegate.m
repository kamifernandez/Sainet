//
//  AppDelegate.m
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 7/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to host exists
    hostReachable = [Reachability reachabilityWithHostName:@"http://www.google.com"];
    [hostReachable startNotifier];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if (![_defaults objectForKey:@"login"]) {
        [_defaults setObject:@"NO" forKey:@"login"];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) checkNetworkStatus:(NSNotification *)notice{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:NSLocalizedString(@"atencion", nil) forKey:@"Title"];
            [msgDict setValue:NSLocalizedString(@"networkError", nil) forKey:@"Message"];
            [msgDict setValue:NSLocalizedString(@"btnAcceptAlert", nil) forKey:@"Cancel"];
            [msgDict setValue:@"0" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
            
            [_defaults setObject:@"NO" forKey:@"connectioninternet"];
            [_defaults synchronize];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            //hayConexionInternet = YES;
            [_defaults setObject:@"YES" forKey:@"connectioninternet"];
            [_defaults synchronize];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            //hayConexionInternet = YES;
            [_defaults setObject:@"YES" forKey:@"connectioninternet"];
            [_defaults synchronize];
            break;
        }
    }
}

-(void)showAlert:(NSMutableDictionary *)msgDict{
    if ([[msgDict objectForKey:@"Aceptar"] length]>0) {
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:[msgDict objectForKey:@"Title"]
                            message:[msgDict objectForKey:@"Message"]
                            delegate:self
                            cancelButtonTitle:[msgDict objectForKey:@"Cancel"]
                            otherButtonTitles:[msgDict objectForKey:@"Aceptar"],nil];
        [alert setTag:[[msgDict objectForKey:@"Tag"] intValue]];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:[msgDict objectForKey:@"Title"]
                            message:[msgDict objectForKey:@"Message"]
                            delegate:self
                            cancelButtonTitle:[msgDict objectForKey:@"Cancel"]
                            otherButtonTitles:nil];
        [alert setTag:[[msgDict objectForKey:@"Tag"] intValue]];
        [alert show];
    }
}

#pragma mark - FaceBook Request

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


@end
