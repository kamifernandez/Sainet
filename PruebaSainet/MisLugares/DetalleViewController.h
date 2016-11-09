//
//  DetalleViewController.h
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 8/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface DetalleViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIImageView *imgPlace;
@property(nonatomic,strong)IBOutlet UITextField *txtName;

@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *indicator;

@property(nonatomic,strong)NSString *tittle;

@end
