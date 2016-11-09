//
//  HomeViewController.m
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 7/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SlideNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import "utility.h"
#import "PostRequest.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Own methods

-(void)configurerView{
    self.viewContentImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewContentImage.layer.borderWidth = 1.0f;
    self.viewContentImage.layer.cornerRadius = 5;
    
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
    
    [self updateMap];
}

-(void)updateMap{
    BOOL gpsActivo = [utility consultarGpsActivo];
    if (gpsActivo) {
        
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

-(IBAction)getPhoto:(id) sender {
    [self.view endEditing:TRUE];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Seleccione"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button one");
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Cámara" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Tu dispositivo no soporta esta función" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
                [msgDict setValue:@"" forKey:@"Aceptar"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            }
        } else if(authStatus == AVAuthorizationStatusDenied){
            // denied
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // restricted, normally won't happen
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    NSLog(@"Granted access to %@", AVMediaTypeVideo);
                    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:picker animated:YES completion:nil];
                } else {
                    NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                }
            }];
        } else {
            // impossible, unknown authorization status
        }
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"Biblioteca" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            [self presentViewController:picker animated:YES completion:nil];
        } else if(authStatus == AVAuthorizationStatusDenied){
            // denied
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // restricted, normally won't happen
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    NSLog(@"Granted access to %@", AVMediaTypeVideo);
                    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    
                    [self presentViewController:picker animated:YES completion:nil];
                } else {
                    NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                }
            }];
        } else {
            // impossible, unknown authorization status
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [alert addAction:archiveAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)registerPlace:(id)sender{
    if (self.imgPlace.image == nil){
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No puedes crear un lugar sin imagen, por favor selecciona alguna imagen para esta operación" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([self.txtName.text isEqualToString:@""]) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor, asignale un nombre a tu lugar" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
            [msgDict setValue:@"" forKey:@"Aceptar"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            [self requestServerLogin];
        }
    }
}

#pragma mark - RequestServer

-(void)requestServerLogin{
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
    NSString * base64Image = [utility Base64ToString:self.imgPlace.image];
    [data setObject:@"place" forKey:@"type"];
    [data setObject:self.txtName.text forKey:@"title"];
    [data setObject:[NSString stringWithFormat:@"data:image/png;base64,%@",base64Image] forKey:@"field_image"];
    [data setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"];
    [data setObject:[_defaults objectForKey:@"latitud"] forKey:@"lat"];
    [data setObject:[_defaults objectForKey:@"longitud"] forKey:@"lon"];
    
    _dataPlace = nil;
    _dataPlace = [PostRequest crearLugar:data];
    [self performSelectorOnMainThread:@selector(ocultarCargandoPlace) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoPlace{
    if ([_dataPlace count] > 0) {
        [self.txtName setText:@""];
        [self.imgPlace setImage:nil];
        [self.view endEditing:true];
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Lugar creado satisfactoriamente" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Su usuario o contraseñan son incorrectos" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark Metodos Camera Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //self.imgPhoto.image = self.imgPhoto.image = [self imageByCropping:[info objectForKey:@"UIImagePickerControllerOriginalImage"] toSize:CGSizeMake(600, 600)];
    self.imgPlace.image = [self scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
}

- (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 3000; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),      CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

#pragma mark -
#pragma mark alert Thread

-(void)showAlert:(NSMutableDictionary *)msgDict
{
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtName isEqual:textField]) {
        [self.view endEditing:TRUE];
    }
    return true;
}

@end
