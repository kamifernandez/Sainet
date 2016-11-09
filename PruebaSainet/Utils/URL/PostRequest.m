//
//  PostRequest.m
//  Leal
//
//  Created by KUBO on 1/6/16.
//  Copyright © 2016 KUBO. All rights reserved.
//

#import "PostRequest.h"
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"

static NSString *domain = @"http://108.179.199.76/~pruebadesarrollo/";
static NSString *appKey = @"Basic cmVzdF9hcGk6MTIzNDU2Nzg5";
static NSString *x_CSRF_Token = @"VMFkPxFNzU-4SOJ3WFTe8PGa1dpwg4bbAfteXC6AUC4";

static NSString *user = @"rest_api";
static NSString *pass = @"123456789";

@implementation PostRequest

+(NSMutableDictionary *)createAccount:(NSMutableDictionary *)datos{
    //NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * name = [datos objectForKey:@"name"];
    NSString * passUser = [datos objectForKey:@"pass"];
    NSString * mail = [datos objectForKey:@"mail"];
    NSString * init = [datos objectForKey:@"init"];
    NSString * roles = [datos objectForKey:@"roles"];
    NSString * status = [datos objectForKey:@"status"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  name, @"name",
                                  passUser, @"pass",
                                  mail, @"mail",
                                  init, @"init",
                                  roles, @"roles",
                                  status, @"status",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@user",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)createAccountFacebook:(NSMutableDictionary *)datos{
    //NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * name = [datos objectForKey:@"name"];
    NSString * passUser = [datos objectForKey:@"pass"];
    NSString * mail = [datos objectForKey:@"mail"];
    NSString * init = [datos objectForKey:@"init"];
    NSString * roles = [datos objectForKey:@"roles"];
    NSString * status = [datos objectForKey:@"status"];
    
    NSString * identifier = [datos objectForKey:@"identifier"];
    NSString * username = [datos objectForKey:@"username"];
    NSString * displayName = [datos objectForKey:@"displayName"];
    NSString * firstName = [datos objectForKey:@"firstName"];
    NSString * lastName = [datos objectForKey:@"lastName"];
    NSString * gender = [datos objectForKey:@"gender"];
    NSString * language = [datos objectForKey:@"language"];
    NSString * description = [datos objectForKey:@"description"];
    NSString * email = [datos objectForKey:@"email"];
    NSString * emailVerified = [datos objectForKey:@"emailVerified"];
    NSString * region = [datos objectForKey:@"region"];
    NSString * city = [datos objectForKey:@"city"];
    NSString * country = [datos objectForKey:@"country"];
    NSString * birthDay = [datos objectForKey:@"birthDay"];
    NSString * birthMonth = [datos objectForKey:@"birthMonth"];
    NSString * birthYear = [datos objectForKey:@"birthYear"];
    NSString * token = [datos objectForKey:@"token"];
    
    //NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSMutableDictionary * dictioData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        identifier, @"identifier",
                                        username, @"username",
                                        displayName, @"displayName",
                                        firstName, @"firstName",
                                        lastName, @"lastName",
                                        gender, @"gender",
                                        language, @"language",
                                        description, @"description",
                                        email, @"email",
                                        emailVerified, @"emailVerified",
                                        region, @"region",
                                        city, @"city",
                                        country, @"country",
                                        birthDay, @"birthDay",
                                        birthMonth, @"birthMonth",
                                        birthYear, @"birthYear",
                                        token, @"token",
                                        nil];
    //[dataArray addObject:dictioData];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  name, @"name",
                                  passUser, @"pass",
                                  mail, @"mail",
                                  init, @"init",
                                  roles, @"roles",
                                  status, @"status",
                                  dictioData,@"data",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@user",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)login:(NSMutableDictionary *)datos{
    //NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * userLogin = [datos objectForKey:@"user"];
    NSString * password = [datos objectForKey:@"password"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     userLogin, @"username",
                                     password, @"password",
                                     nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];

    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@app_login",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [[respuesta objectForKey:@"user"] mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableArray *)loginFacebook:(NSMutableDictionary *)datos{
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    NSError *error;
    NSString * mail = [datos objectForKey:@"user"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@user?mail=%@",domain,mail];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    //[request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if ([respuesta count]>0) {
            stringDictio = [[respuesta objectForKey:@"list"] mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)crearLugar:(NSMutableDictionary *)datos{
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * type = [datos objectForKey:@"type"];
    NSString * title = [datos objectForKey:@"title"];
    NSString * field_image = [datos objectForKey:@"field_image"];
    NSString * uid = [datos objectForKey:@"uid"];
    NSString * lat = [datos objectForKey:@"lat"];
    NSString * lon = [datos objectForKey:@"lon"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  type, @"type",
                                  title, @"title",
                                  field_image, @"field_image",
                                  uid, @"uid",
                                  lat, @"lat",
                                  lon, @"lon",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@node",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if ([respuesta count]>0) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableArray *)getPLaces:(NSMutableDictionary *)datos{
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    NSError *error;
    NSString * uid = [datos objectForKey:@"uid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@node?type=place&author=%@",domain,uid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    //[request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if ([respuesta count]>0) {
            stringDictio = [[respuesta objectForKey:@"list"] mutableCopy];
        }
    }
    
    return stringDictio;
}

@end
