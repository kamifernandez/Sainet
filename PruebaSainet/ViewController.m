//
//  ViewController.m
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 7/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import "ViewController.h"
#import "PostRequest.h"
#import "utility.h"
#import "HomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(configurarLayouts) withObject:nil afterDelay:0.1];
    [self configurerView];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"login"] isEqualToString:@"YES"]) {
        [self changeView:NO];
    }
}

-(void)configurerView{
    loginFacebook = NO;
    self.viewContentUser.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewContentUser.layer.borderWidth = 1.0f;
    self.viewContentUser.layer.cornerRadius = 5;
    
    self.viewContentPassword.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewContentPassword.layer.borderWidth = 1.0f;
    self.viewContentPassword.layer.cornerRadius = 5;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurarLayouts{
    [super updateViewConstraints];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    NSLog(@"%f,%f",bounds.size.width,bounds.size.height);
    if (([[UIScreen mainScreen] bounds].size.height == 480)) {
        
    }else if (([[UIScreen mainScreen] bounds].size.height == 568)) {
        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewContentUser) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 70;
            }
        }];
        
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewContentUser) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 120;
            }
        }];
        
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        
        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ((constraint.firstItem == self.viewContentUser) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
                constraint.constant = 140;
            }
        }];
    }
}

#pragma mark - RequestServer

-(void)requestServerLogin{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        if (!loginFacebook) {
            [self mostrarCargando];
        }
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
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    _dataLogin = nil;
    if (loginFacebook) {
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [data setObject:[_defaults objectForKey:@"email"] forKey:@"user"];
        _dataLoginFacebook = nil;
        _dataLoginFacebook = [PostRequest loginFacebook:data];
    }else{
        [data setObject:self.txtUser.text forKey:@"user"];
        [data setObject:self.txtPassword.text forKey:@"password"];
        _dataLogin = [PostRequest login:data];
    }
    [self performSelectorOnMainThread:@selector(ocultarCargandoLogin) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoLogin{
    if ([_dataLogin count] > 0 || [_dataLoginFacebook count]>0) {
        [self.txtUser setText:@""];
        [self.txtPassword setText:@""];
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        if (loginFacebook) {
            [_defaults setObject:[[self.dataLoginFacebook objectAtIndex:0] objectForKey:@"uid"] forKey:@"uid"];
        }else{
            [_defaults setObject:[self.dataLogin objectForKey:@"uid"] forKey:@"uid"];
        }
        [_defaults setObject:@"YES" forKey:@"login"];
        [self changeView:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        if (loginFacebook) {
            [msgDict setValue:@"Tu usuario no se encuentra creado por facebook, por favor crea una cuenta para este usuario" forKey:@"Message"];
        }else{
            [msgDict setValue:@"Su usuario o contraseñan son incorrectos" forKey:@"Message"];
        }
        
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark -
#pragma mark Own Methods

-(void)changeView:(BOOL)animation{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *fotosViewController = [story instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:fotosViewController animated:animation];
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

#pragma mark IBActions

-(IBAction)login:(id)sender{
    loginFacebook = NO;
    if ([self.txtUser.text isEqualToString:@""] || [self.txtPassword.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Alguno de los campos se encuentra vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
        [msgDict setValue:@"" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if(![utility validateEmailWithString:self.txtUser.text]){
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor verifica que el correo sea un correo valido" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Cancel"];
            [msgDict setValue:@"" forKey:@"Aceptar"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            [self requestServerLogin];
        }
    }
}

-(IBAction)loginButtonClickedFaceBook:(id)sender
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
                              loginFacebook = YES;
                              [self requestServerLogin];
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

#pragma mark Metodos TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtUser isEqual:textField]) {
        [_txtPassword becomeFirstResponder];
    }else if ([_txtPassword isEqual:textField]){
        [self.view endEditing:TRUE];
    }
    return true;
}

@end
