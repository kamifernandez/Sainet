//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
//#import "AlbumViewController.h"
//#import "PostViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    if (([[UIScreen mainScreen] bounds].size.height == 480)) {
        [self.tableView setScrollEnabled:YES];
    }
    
    self.identifierStory = @"HomeViewController";
    
	self.tableView.separatorColor = [UIColor clearColor];
    self.descripcionCelda = [[NSMutableArray alloc] init];
    for (int i = 0; i<3; i++) {
        NSMutableDictionary * dataTemp = [NSMutableDictionary new];
        if (i == 0) {
            [dataTemp setObject:@"ic_add_location_white.png" forKeyedSubscript:@"icono"];
            [dataTemp setObject:@"Crear Lugar" forKeyedSubscript:@"tittle"];
        }else if (i == 1){
            [dataTemp setObject:@"ic_find_replace_white.png" forKeyedSubscript:@"icono"];
            [dataTemp setObject:@"Mis Lugares" forKeyedSubscript:@"tittle"];
        }else if (i == 2){
            [dataTemp setObject:@"ic_do_not_disturb_off_white.png" forKeyedSubscript:@"icono"];
            [dataTemp setObject:@"Cerrar sesión" forKeyedSubscript:@"tittle"];
        }
        [_descripcionCelda addObject:dataTemp];
    }
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_descripcionCelda count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"CellLeftMenu";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CellLeftMenu" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla=nil;
    }
    
    UIImageView *imgIcono = (UIImageView *)[cell viewWithTag:1];
    [imgIcono setImage:[UIImage imageNamed:[[_descripcionCelda objectAtIndex:indexPath.row] objectForKey:@"icono"]]];
    
    UILabel *lblTittle = (UILabel *)[cell viewWithTag:2];
    [lblTittle setText:[[_descripcionCelda objectAtIndex:indexPath.row] objectForKey:@"tittle"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	UIViewController *vc ;
	
	switch (indexPath.row)
    {
        case 0:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
            self.identifierStory = @"HomeViewController";
            break;
            
        case 1:{
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MisLugaresViewController"];
            self.identifierStory = @"MisLugaresViewController";
            break;
        }case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier:self.identifierStory];
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"¿Desea cerrar la sesión actual?" forKey:@"Message"];
            [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"101" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
            break;
    }
	
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - showAlert metodo

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
#pragma mark -
#pragma mark Delegates alertas

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:@"NO" forKey:@"login"];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle: nil];
            UIViewController *vc ;
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ViewController"];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                     withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                             andCompletion:nil];
            
        }
    }
}


@end
