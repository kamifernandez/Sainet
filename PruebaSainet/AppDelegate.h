//
//  AppDelegate.h
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 7/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@property (strong, nonatomic) UIWindow *window;


@end

