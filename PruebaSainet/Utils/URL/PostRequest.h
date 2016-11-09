//
//  PostRequest.h
//  Leal
//
//  Created by KUBO on 1/6/16.
//  Copyright © 2016 KUBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostRequest : NSObject

+(NSMutableDictionary *)createAccount:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)createAccountFacebook:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)login:(NSMutableDictionary *)datos;

+(NSMutableArray *)loginFacebook:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)crearLugar:(NSMutableDictionary *)datos;

+(NSMutableArray *)getPLaces:(NSMutableDictionary *)datos;

@end
