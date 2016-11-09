//
//  utility.h
//  Leal
//
//  Created by KUBO on 1/7/16.
//  Copyright © 2016 KUBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface utility : NSObject

+ (NSString *) md5:(NSString *) input;

+(BOOL)consultarGpsActivo;

+(NSString *)decimalNumberFormatDoubleTotales:(double)decimalNumber;

+(NSString *)Base64ToString:(UIImage *)image;

+ (BOOL)validateEmailWithString:(NSString*)checkString;

+(BOOL)isPasswordStrong:(NSString *)password;

@end
