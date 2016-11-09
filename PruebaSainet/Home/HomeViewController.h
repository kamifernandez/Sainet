//
//  HomeViewController.h
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 7/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"

@interface HomeViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    CLLocationManager *locationManager;
    //Location
    MyCLController *_MyCLController;
}


@property(nonatomic,strong)IBOutlet UIView *viewContentImage;

@property(nonatomic,strong)IBOutlet UIImageView *imgPlace;
@property(nonatomic,strong)IBOutlet UITextField *txtName;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@property(nonatomic,strong)NSMutableDictionary *dataPlace;

@end
