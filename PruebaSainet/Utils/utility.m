//
//  utility.m
//  Leal
//
//  Created by KUBO on 1/7/16.
//  Copyright © 2016 KUBO. All rights reserved.
//

#import "utility.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@implementation utility

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+(BOOL)consultarGpsActivo{
    BOOL locationAllowed = NO;
    locationAllowed = [self locationAuthorized];
    
    if (locationAllowed==NO) {
        locationAllowed = NO;
    } else {
        locationAllowed = YES;
    }
    return locationAllowed;
}

+(BOOL)locationAuthorized {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        return (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse);
    }
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

+(NSString *)decimalNumberFormatDoubleTotales:(double)decimalNumber{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:decimalNumber]];
    
    return numberString;
}

#pragma mark - Validate Email

+ (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Encode Base64

+(NSString *)Base64ToString:(UIImage *)image{
    UIImage* smallImage = [self scaleToSize:CGSizeMake(100.0f,100.0f) image:image];
    NSData *imgData= UIImageJPEGRepresentation(smallImage,0.1);
    UIImage *imageCompress=[UIImage imageWithData:imgData];
    return [UIImagePNGRepresentation(imageCompress) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage*)scaleToSize:(CGSize)size image:(UIImage *)toImage{
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), toImage.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+(BOOL)isPasswordStrong:(NSString *)password {
    /*
     8-15 chars
     at least one letter
     at least one number OR special character
     no more than 3 repeated characters
     */
    NSString *strongPass= @"^(?!.*(.)\\1{3})((?=.*[\\d])(?=.*[A-Za-z])|(?=.*[^\\w\\d\\s])(?=.*[A-Za-z])).{8,15}$";;
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strongPass];
    
    return [regexTest evaluateWithObject:password];
}

@end
