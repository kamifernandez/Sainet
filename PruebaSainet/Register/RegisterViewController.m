//
//  RegisterViewController.m
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 8/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import "RegisterViewController.h"
#import "PostRequest.h"
#import "HomeViewController.h"
#import "utility.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
    [self performSelector:@selector(configurarLayouts) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Own methods

-(void)changeView:(BOOL)animation{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *fotosViewController = [story instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:fotosViewController animated:animation];
}

-(void)configurerView{
    self.viewMail.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewMail.layer.borderWidth = 1.0f;
    self.viewMail.layer.cornerRadius = 5;
    
    self.viewConfirmMail.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewConfirmMail.layer.borderWidth = 1.0f;
    self.viewConfirmMail.layer.cornerRadius = 5;
    
    self.viewPass.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewPass.layer.borderWidth = 1.0f;
    self.viewPass.layer.cornerRadius = 5;
    
    self.viewConfrimPass.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewConfrimPass.layer.borderWidth = 1.0f;
    self.viewConfrimPass.layer.cornerRadius = 5;
    
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
}

-(void)configurarLayouts{
    [super updateViewConstraints];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    NSLog(@"%f,%f",bounds.size.width,bounds.size.height);
    if (([[UIScreen mainScreen] bounds].size.height == 480)) {
        
    }else if (([[UIScreen mainScreen] bounds].size.height == 568)) {
        [self.viewContentCreateAccount.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewMail) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 70;
            }
        }];
        
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        [self.viewContentCreateAccount.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewMail) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 120;
            }
        }];
        
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        
        [self.viewContentCreateAccount.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewMail) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 140;
            }
        }];
    }
}

#pragma mark IBActions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)registerAccount:(id)sender{
    accountFacebook = NO;
    if ([self.txtMail.text isEqualToString:@""] || [self.txtConfirmMail.text isEqualToString:@""] || [self.txtPass.text isEqualToString:@""] || [self.txtConfrimPass.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Alguno de los campos se encuentra vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if(![utility validateEmailWithString:self.txtMail.text]){
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor verifica que el correo sea un correo valido" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
            [msgDict setValue:@"" forKey:@"Aceptar"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            if ([self.txtMail.text isEqualToString:self.txtConfirmMail.text]) {
                if ([utility isPasswordStrong:self.txtPass.text]) {
                    if ([self.txtPass.text isEqualToString:self.txtConfrimPass.text]) {
                            [self requestServerCreateAccount];
                    }else{
                        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                        [msgDict setValue:@"Atención" forKey:@"Title"];
                        [msgDict setValue:@"Por favor verifica que los campos de contraseña coincidan" forKey:@"Message"];
                        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
                        [msgDict setValue:@"" forKey:@"Aceptar"];
                        
                        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                            waitUntilDone:YES];
                    }
                }else{
                    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                    [msgDict setValue:@"Atención" forKey:@"Title"];
                    [msgDict setValue:@"La contraseña debe contener como mínimo 8 y máximo 15 caracteres. No debe contener espacios y tener al menos un caracter numérico." forKey:@"Message"];
                    [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
                    [msgDict setValue:@"" forKey:@"Aceptar"];
                    
                    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                        waitUntilDone:YES];
                }
            }else{
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Por favor verifica que los campos de correo coincidan" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
                [msgDict setValue:@"" forKey:@"Aceptar"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            }
        }
    }
}

-(IBAction)registerButtonClickedFaceBook:(id)sender
{
    [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){}];
    [self mostrarCargando];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends", @"user_birthday"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
             [msgDict setValue:@"Atención" forKey:@"Title"];
             [msgDict setValue:[error localizedDescription] forKey:@"Message"];
             [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
             [msgDict setValue:@"" forKey:@"Aceptar"];
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                 waitUntilDone:YES];
             [self mostrarCargando];
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
             [msgDict setValue:@"Atención" forKey:@"Title"];
             [msgDict setValue:@"Cancelled" forKey:@"Message"];
             [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
             [msgDict setValue:@"" forKey:@"Aceptar"];
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                 waitUntilDone:YES];
             [self mostrarCargando];
         } else {
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,first_name,email,last_name,birthday,gender" forKey:@"fields"];
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                  if (!error) {
                      NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
                      
                      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                      dispatch_async(queue, ^{
                          dispatch_sync(dispatch_get_main_queue(), ^{
                              
                              if (![result objectForKey:@"id"]) {
                                  [_defaults setObject:@"-" forKey:@"id"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"id"] forKey:@"id"];
                              }
                              
                              if (![result objectForKey:@"name"]) {
                                  [_defaults setObject:@"-" forKey:@"user"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"name"] forKey:@"user"];
                              }
                              
                              if (![result objectForKey:@"first_name"]) {
                                  [_defaults setObject:@"-" forKey:@"nombre"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"first_name"] forKey:@"nombre"];
                              }
                              
                              if (![result objectForKey:@"last_name"]) {
                                  [_defaults setObject:@"-" forKey:@"apellido"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"last_name"] forKey:@"apellido"];
                              }
                              
                              if (![result objectForKey:@"email"]) {
                                  [_defaults setObject:@"-" forKey:@"email"];
                              }else{
                                  [self.txtMail setText:[result objectForKey:@"email"]];
                                  [_defaults setObject:[result objectForKey:@"email"] forKey:@"email"];
                              }
                              
                              
                              if (![result objectForKey:@"gender"]) {
                                  //[_defaults setObject:@"-" forKey:@"genero"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"gender"] forKey:@"genero"];
                              }
                              
                              
                              if (![result objectForKey:@"birthday"]) {
                                  [_defaults setObject:@"-" forKey:@"cumpleaños"];
                              }else{
                                  [_defaults setObject:[result objectForKey:@"birthday"] forKey:@"cumpleaños"];
                              }
                              accountFacebook = YES;
                              [self requestServerCreateAccount];
                          });
                      });
                  }
                  else{
                      NSLog(@"%@", [error localizedDescription]);
                  }
              }];
         }
     }];
}

#pragma mark - RequestServer

-(void)requestServerCreateAccount{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        if (!accountFacebook) {
            [self mostrarCargando];
        }
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerCreateAccount) object:nil];
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

-(void)envioServerCreateAccount{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:self.txtMail.text forKey:@"name"];
    [data setObject:self.txtPass.text forKey:@"pass"];
    [data setObject:self.txtMail.text forKey:@"mail"];
    [data setObject:self.txtMail.text forKey:@"init"];
    [data setObject:@"authenticated user" forKey:@"roles"];
    [data setObject:@"1" forKey:@"status"];
    
    _dataAccount = nil;
    if (accountFacebook){
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [data setObject:[_defaults objectForKey:@"id"] forKey:@"identifier"];
        [data setObject:[_defaults objectForKey:@"user"] forKey:@"username"];
        [data setObject:[_defaults objectForKey:@"user"] forKey:@"displayName"];
        [data setObject:[_defaults objectForKey:@"nombre"] forKey:@"firstName"];
        [data setObject:[_defaults objectForKey:@"apellido"] forKey:@"lastName"];
        [data setObject:[_defaults objectForKey:@"genero"] forKey:@"gender"];
        [data setObject:@"es" forKey:@"language"];
        [data setObject:@"description" forKey:@"description"];
        [data setObject:self.txtMail.text forKey:@"email"];
        [data setObject:self.txtMail.text forKey:@"emailVerified"];
        [data setObject:[NSString stringWithFormat:@"%@-%@",[_defaults objectForKey:@"administraUsuario"],[_defaults objectForKey:@"codePaisUsuario"]] forKey:@"region"];
        [data setObject:[_defaults objectForKey:@"ciudadUsuario"] forKey:@"city"];
        [data setObject:[_defaults objectForKey:@"paisUsuario"] forKey:@"country"];
        
        NSArray * splitBirthDay = [[_defaults objectForKey:@"cumpleaños"] componentsSeparatedByString:@"/"];
        if ([splitBirthDay count]>0) {
            [data setObject:[splitBirthDay objectAtIndex:0] forKey:@"birthDay"];
            [data setObject:[splitBirthDay objectAtIndex:1] forKey:@"birthMonth"];
            [data setObject:[splitBirthDay objectAtIndex:2] forKey:@"birthYear"];
        }
        [data setObject:@"123456789" forKey:@"token"];
        _dataAccount = [PostRequest createAccountFacebook:data];
    }else
        _dataAccount = [PostRequest createAccount:data];
    [self performSelectorOnMainThread:@selector(ocultarCargandoCreateAccount) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoCreateAccount{
    if ([_dataAccount count] > 0) {
        [self.txtMail setText:@""];
        [self.txtPass setText:@""];
        [self.txtConfirmMail setText:@""];
        [self.txtConfrimPass setText:@""];
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:[self.dataAccount objectForKey:@"id"] forKey:@"uid"];
        [_defaults setObject:@"YES" forKey:@"login"];
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Bienvenido" forKey:@"Title"];
        [msgDict setValue:@"¡Usuario creado con exito!" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
        //[self changeView:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Su usuario ya fue creado, por favor ingresa por la sección de login" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark Metodos Teclado

-(void)mostrarTeclado:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width-60, 0.0);
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _scroll.frame;
    aRect.size.height -= kbSize.width;
    
    if (!CGRectContainsPoint(aRect, _viewSelected.frame.origin) ) {
        // El 160 es un parametro que depende de la vista en la que se encuentra, se debe ajustar dependiendo del caso
        float tamano = 0.0;
        
        float version=[[UIDevice currentDevice].systemVersion floatValue];
        if(version <7.0){
            tamano = _viewSelected.frame.origin.y-100;
        }else{
            tamano = _viewSelected.frame.origin.y-120;
        }
        if(tamano<0)
            tamano=0;
        CGPoint scrollPoint = CGPointMake(0.0, tamano);
        [_scroll setContentOffset:scrollPoint animated:YES];
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         _scroll.contentInset = contentInsets;
         _scroll.scrollIndicatorInsets = contentInsets;
     }completion:^(BOOL finished){
         
     }];
}


#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _txtSeleccionado = textField;
    _viewSelected = textField.superview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtMail isEqual:textField]) {
        [_txtConfirmMail becomeFirstResponder];
    }else if ([_txtConfirmMail isEqual:textField]){
        [_txtPass becomeFirstResponder];
    }else if ([_txtPass isEqual:textField]){
        [_txtConfrimPass becomeFirstResponder];
    }else if ([_txtConfrimPass isEqual:textField]){
        [self.view endEditing:TRUE];
    }
    return true;
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

#pragma mark -
#pragma mark Delegates alertas

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        [self changeView:YES];
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
        [_defaults setObject:@"-" forKey:@"codePaisUsuario"];
        [_defaults setObject:@"-" forKey:@"paisUsuario"];
        [_defaults setObject:@"-" forKey:@"codePostalUsuario"];
        [_defaults setObject:@"-" forKey:@"administraUsuario"];
        [_defaults setObject:@"-" forKey:@"ciudadUsuario"];
        [_defaults setObject:@"-" forKey:@"subLocalUsuario"];
        [_defaults setObject:@"-" forKey:@"subThoroughfare"];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:newLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                           
                           if (error){
                               NSLog(@"Geocode failed with error: %@", error);
                               return;
                               
                           }
                           
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           [_defaults setObject:placemark.ISOcountryCode forKey:@"codePaisUsuario"];
                           [_defaults setObject:placemark.country forKey:@"paisUsuario"];
                           [_defaults setObject:placemark.postalCode forKey:@"codePostalUsuario"];
                           [_defaults setObject:placemark.administrativeArea forKey:@"administraUsuario"];
                           [_defaults setObject:placemark.locality forKey:@"ciudadUsuario"];
                           [_defaults setObject:placemark.subLocality forKey:@"subLocalUsuario"];
                           [_defaults setObject:placemark.subThoroughfare forKey:@"subThoroughfare"];
                           NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                           NSLog(@"placemark.country %@",placemark.country);
                           NSLog(@"placemark.postalCode %@",placemark.postalCode);
                           NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
                           NSLog(@"placemark.locality %@",placemark.locality);
                           NSLog(@"placemark.subLocality %@",placemark.subLocality);
                           NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
                           
                       }];
        
    }
}

@end
