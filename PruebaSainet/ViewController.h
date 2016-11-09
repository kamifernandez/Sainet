//
//  ViewController.h
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 7/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController : UIViewController{
    CLLocationManager *locationManager;
    
    //Location
    MyCLController *_MyCLController;
    bool loginFacebook;
}

@property(nonatomic,strong)IBOutlet UIView *viewContentUser;

@property(nonatomic,strong)IBOutlet UIView *viewContentPassword;

@property(nonatomic,strong)IBOutlet UITextField *txtUser;

@property(nonatomic,strong)IBOutlet UITextField *txtPassword;

@property(nonatomic,strong)NSMutableDictionary *dataLogin;

@property(nonatomic,strong)NSMutableArray *dataLoginFacebook;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end

