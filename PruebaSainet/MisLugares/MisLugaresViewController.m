//
//  MisLugaresViewController.m
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 8/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import "MisLugaresViewController.h"
#import "SlideNavigationController.h"
#import "PostRequest.h"
#import "MyAnnotationView.h"
#import "utility.h"
#import "myAnnotation.h"
#import "DetalleViewController.h"

@interface MisLugaresViewController ()

@end

@implementation MisLugaresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
    
    [_defaults setObject:[_defaults objectForKey:@"latitud"] forKey:@"latitudMap"];
    [_defaults setObject:[_defaults objectForKey:@"longitud"] forKey:@"longitudMap"];
    
    double latitud = [[_defaults objectForKey:@"latitud"] doubleValue];
    double longitud = [[_defaults objectForKey:@"longitud"] doubleValue];
    
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = latitud;
    region.center.longitude = longitud;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.mapa setRegion:region animated:YES];
    
    float version=[[UIDevice currentDevice].systemVersion floatValue];
    if(version >=8.0){
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:(id)self];
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager requestWhenInUseAuthorization];
        [locationManager startMonitoringSignificantLocationChanges];
        [locationManager startUpdatingLocation];
    }else{
        //Location
        _MyCLController = [[MyCLController alloc] init];
        [_MyCLController.locationManager startUpdatingLocation];
    }
    
    //[self updateMap];
}

-(void)updateMap{
    BOOL gpsActivo = [utility consultarGpsActivo];
    if (gpsActivo) {
        [self requestServerPlaces];
    }else{
        //[self mapaGoogle];
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Leal" forKey:@"Title"];
        [msgDict setValue:@"¿GPS no está activado desea activarlo?" forKey:@"Message"];
        [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
        [msgDict setValue:@"1" forKey:@"alert"];
        [msgDict setValue:@"Activarlo" forKey:@"Aceptar"];
        [msgDict setValue:@"102" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

#pragma mark IBActions

-(IBAction)openMenu:(id)sender{
    [self.view endEditing:YES];
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

-(IBAction)mostrarTable:(id)sender{
    [[NSBundle mainBundle] loadNibNamed:@"TableMisLugares" owner:self options:nil];
    [_viewTable setAlpha:0.0];
    [_viewTable setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_viewTable];
    [_tabla reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        [_viewTable setAlpha:1.0];
    }completion:^(BOOL finished){
    }];
}

-(IBAction)backTable:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{
        [_viewTable setAlpha:0.0];
    }completion:^(BOOL finished){
        [_viewTable removeFromSuperview];
        _viewTable = nil;
    }];
}

#pragma mark - RequestServer

-(void)requestServerPlaces{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerLogin) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerLogin{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"];
   
    _dataMap = nil;
    _dataMap = [PostRequest getPLaces:data];
    [self performSelectorOnMainThread:@selector(ocultarCargandoPlace) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoPlace{
    if ([_dataMap count] > 0) {
        [self.btnTable setEnabled:true];
        [self setcoords];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tienes lugares para mostrar, Disfruta creando uno y compartiendo." forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - Metodos Vista Cargando

-(void)mostrarCargando{
    @autoreleasepool {
        if (_vistaWait.hidden == TRUE) {
            _vistaWait.hidden = FALSE;
            CALayer * l = [_vistaWait layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            // You can even add a border
            [l setBorderWidth:1.5];
            [l setBorderColor:[[UIColor whiteColor] CGColor]];
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

#pragma mark - Alert

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

#pragma mark - Map Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%f",annotation.coordinate.latitude);
    NSLog(@"%f",[[_defaults objectForKey:@"latitud"] doubleValue]);
    
    
    /*if (annotation.coordinate.latitude == [[_defaults objectForKey:@"latitud"] doubleValue]) {
        return nil;
    }*/
    
    int b=0;
    int tmpIndex = 0;
    while(b<[_dataMap count]){
        NSMutableDictionary * dataPin = [[_dataMap objectAtIndex:b] objectForKey:@"field_geofield"];
        float viewActual = annotation.coordinate.latitude;
        float pin = [[dataPin objectForKey:@"lat"] floatValue];
        NSLog(@"viewActual %f",pin);
        NSLog(@"viewActual %f",viewActual);
        if(viewActual == pin){
            tmpIndex=b;
            break;
        }
        b=b+1;
    }
    
    static NSString *identifier = @"myAnnotation";
    MyAnnotationView * annotationView = (MyAnnotationView *)[self.mapa dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CGRectMake(0, 0, 37, 56);
    button.tag = tmpIndex;
    annotationView.rightCalloutAccessoryView = button;
    
    if (!annotationView)
    {
        annotationView = [[MyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.image = [UIImage imageNamed:@"ic_pin_drop.png"];
        
    }else {
        annotationView = [[MyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.image = [UIImage imageNamed:@"ic_pin_drop.png"];
        annotationView.annotation = annotation;
    }
    annotationView.tag = tmpIndex;
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if (![view.annotation isKindOfClass:[MKUserLocation class]]){
        int indexMapa = (int)view.tag;
        NSMutableDictionary * dataPin = [[_dataMap objectAtIndex:indexMapa] objectForKey:@"field_geofield"];
        float latitude = [[dataPin objectForKey:@"lat"] floatValue];
        float longitude = [[dataPin objectForKey:@"lon"] floatValue];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude;
        coordinate.longitude = longitude;
        
        [mapView setCenterCoordinate:coordinate animated:YES];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetalleViewController *fotosViewController = [story instantiateViewControllerWithIdentifier:@"DetalleViewController"];
        fotosViewController.tittle = [[_dataMap objectAtIndex:indexMapa] objectForKey:@"title"];
        [self.navigationController pushViewController:fotosViewController animated:YES];
        
    }
}

#pragma mark - Delegate Location

- (void)requestAlwaysAuthorization{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"Para utilizar la localización debe activar esta opción en Ajustes -> Servicios de localización -> Siempre";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if (status == kCLAuthorizationStatusDenied) {
        // permission denied
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways) {
        //[self updateMap];
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_defaults setObject:@"YES" forKey:@"verifyGps"];
        [self updateMap];
    }
    [_defaults setObject:@"YES" forKey:@"gps"];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    /*UIAlertView *errorAlert = [[UIAlertView alloc]
     initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [errorAlert show];*/
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
        //NSLog(@"longitud: %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        //NSLog(@"latitude: %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        [_defaults setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:@"latitud"];
        [_defaults setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:@"longitud"];
        [_defaults setObject:@"0" forKey:@"ciudadUsuario"];
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark * placemark in placemarks) {
                [_defaults setObject:placemark.locality forKey:@"ciudadUsuario"];
            }
        }];
    }
}

//Mapa
- (void)setcoords{
    
    lat = 0.5;
    lon = 0.5;
    
    MKCoordinateSpan span;
    
    span.latitudeDelta=lat;
    span.longitudeDelta=lat;
    
    dataIndexa=0;
    
    NSArray *annotationArrs = self.mapa.annotations;
    if(annotationArrs!=nil)
    {
        [self.mapa removeAnnotations:annotationArrs];
    }
    
    CLLocationCoordinate2D location;
    NSMutableArray *temp = _dataMap;
    while (dataIndexa < [temp count]) {
        NSMutableDictionary * dataPin = [[temp objectAtIndex:dataIndexa] objectForKey:@"field_geofield"];
        NSString * lati = [[dataPin objectForKey:@"lat"] stringByReplacingOccurrencesOfString:@"," withString:@"."];
        NSString * longi = [[dataPin objectForKey:@"lon"] stringByReplacingOccurrencesOfString:@"," withString:@"."];
        location.latitude=[lati doubleValue];
        location.longitude=[longi doubleValue];
        myAnnotation *addAnnotation = [[myAnnotation alloc] initWithCoordinate:location title:@" " subTitle:@" " subImagen:@" "];
        [self.mapa addAnnotation:addAnnotation];
        dataIndexa = dataIndexa +1;
        
    }
    
    if ([temp count]>0) {
        [self recenterMap];
    }
}

- (void)recenterMap {
    
    NSArray *coordinates = [self.mapa valueForKeyPath:@"annotations.coordinate"];
    
    
    CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
    
    CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
    
    
    for(NSValue *value in coordinates) {
        
        CLLocationCoordinate2D coord = {0.0f, 0.0f};
        
        [value getValue:&coord];
        
        if(coord.longitude > maxCoord.longitude) {
            
            maxCoord.longitude = coord.longitude;
            
        }
        
        if(coord.latitude > maxCoord.latitude) {
            
            maxCoord.latitude = coord.latitude;
            
        }
        
        if(coord.longitude < minCoord.longitude) {
            
            minCoord.longitude = coord.longitude;
            
        }
        
        if(coord.latitude < minCoord.latitude) {
            
            minCoord.latitude = coord.latitude;
            
        }
        
    }
    
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    
    region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
    
    region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
    
    region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
    
    region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
    
    [self.mapa setRegion:region animated:YES];
}

#pragma mark Table Methods
//Numero de secciones de la tabla
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//Numero de registros en la tabla.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataMap count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"CellTabla";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CellTabla" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla=nil;
    }
    
    NSMutableDictionary * dataPin = [[_dataMap objectAtIndex:indexPath.row] objectForKey:@"field_geofield"];
    
    NSMutableDictionary * dataGetImage = [[_dataMap objectAtIndex:indexPath.row] objectForKey:@"field_image"];
    
    NSMutableDictionary * dataImage = [dataGetImage objectForKey:@"file"];
    
    UIImageView *imgPhoto = (UIImageView *)[cell viewWithTag:1];
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:5];
    
    //NSString * urlImage = [dataImage objectForKey:@"uri"];
    NSString * urlImage = @"http://108.179.199.76/~pruebadesarrollo/sites/default/files/image_1478624605.png";
    
    //NSURL *imageURL = [NSURL URLWithString:[dataImage objectForKey:@"uri"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
    NSString *key = [urlImage MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        [indicator stopAnimating];
        UIImage *image = [UIImage imageWithData:data];
        imgPhoto.image = image;
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                imgPhoto.image = image;
            });
        });
    }
    
    UILabel *lblTittle = (UILabel *)[cell viewWithTag:2];
    [lblTittle setText:[NSString stringWithFormat:@"Lugar: %@",[[_dataMap objectAtIndex:indexPath.row] objectForKey:@"title"]]];
    
    UILabel *lblLat = (UILabel *)[cell viewWithTag:3];
    [lblLat setText:[NSString stringWithFormat:@"Latitud: %@",[dataPin objectForKey:@"lat"]]];
    
    UILabel *lblLon = (UILabel *)[cell viewWithTag:4];
    [lblLon setText:[NSString stringWithFormat:@"Longitud: %@",[dataPin objectForKey:@"lon"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
