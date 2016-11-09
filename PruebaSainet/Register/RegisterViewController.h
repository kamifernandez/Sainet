//
//  RegisterViewController.h
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 8/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MyCLController.h"

@interface RegisterViewController : UIViewController{
    BOOL accountFacebook;
    CLLocationManager *locationManager;
    //Location
    MyCLController *_MyCLController;
}

@property(nonatomic,strong)IBOutlet UIView *viewMail;
@property(nonatomic,strong)IBOutlet UIView *viewConfirmMail;

@property(nonatomic,strong)IBOutlet UIView *viewPass;
@property(nonatomic,strong)IBOutlet UIView *viewConfrimPass;

@property(nonatomic,strong)IBOutlet UITextField *txtMail;
@property(nonatomic,strong)IBOutlet UITextField *txtConfirmMail;

@property(nonatomic,strong)IBOutlet UITextField *txtPass;
@property(nonatomic,strong)IBOutlet UITextField *txtConfrimPass;

// TXtDelegates

@property(nonatomic,weak)UITextField * txtSeleccionado;
@property(nonatomic,weak)UIView * viewSelected;

//Scroll

@property(nonatomic,weak)IBOutlet UIScrollView * scroll;

@property(nonatomic,weak)IBOutlet UIView * viewContentCreateAccount;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

//Data

@property(nonatomic,strong)NSMutableDictionary *dataAccount;

@end
