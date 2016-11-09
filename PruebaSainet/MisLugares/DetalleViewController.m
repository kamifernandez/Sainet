//
//  DetalleViewController.m
//  PruebaSainet
//
//  Created by Christian camilo fernandez on 8/11/16.
//  Copyright © 2016 Christian Camilo Fernandez. All rights reserved.
//

#import "DetalleViewController.h"

@interface DetalleViewController ()

@end

@implementation DetalleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    NSString * urlImage = @"http://108.179.199.76/~pruebadesarrollo/sites/default/files/image_1478624605.png";
    
    //NSURL *imageURL = [NSURL URLWithString:[dataImage objectForKey:@"uri"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
    NSString *key = [urlImage MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        [self.indicator stopAnimating];
        UIImage *image = [UIImage imageWithData:data];
        self.imgPlace.image = image;
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.indicator stopAnimating];
                self.imgPlace.image = image;
            });
        });
    }
    [self.txtName setText:self.tittle];
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
