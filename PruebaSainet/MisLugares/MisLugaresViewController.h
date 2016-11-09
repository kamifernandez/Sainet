//
//  MisLugaresViewController.h
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 8/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyCLController.h"
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface MisLugaresViewController : UIViewController{
    CLLocationManager *locationManager;
    //Location
    MyCLController *_MyCLController;
    
    int lat;
    int lon;
    int dataIndexa;
}

@property(nonatomic,weak)IBOutlet MKMapView * mapa;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@property(nonatomic,strong)NSMutableArray *dataMap;

// ViewTable

@property(nonatomic,weak)IBOutlet UIView *viewTable;
@property(nonatomic,weak)IBOutlet UITableView *tabla;
@property (weak,nonatomic) IBOutlet UITableViewCell *celdaTabla;
@property (weak,nonatomic) IBOutlet UIButton *btnTable;

@end
