//
//  OLRequestManager.m
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import "OLRequestManager.h"
#import "NSDictionary+Sign.h"

@implementation OLRequestManager

// 图片存储的地址
static NSString * const kServerImagePath = @"file";

+ (OLRequestManager *)sharedManager
{
    static OLRequestManager *centeral = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        centeral = [[OLRequestManager alloc] init];
    });
    return centeral;
}

- (void)requestGET:(NSString *)URLString
            params:(NSDictionary *)params
  configureHandler:(void (^)(AFHTTPSessionManager *))configureHandler
    successHandler:(serverSuccessHandler)successHandler
      errorHandler:(serverErrorHandler)errorHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (configureHandler) {
        configureHandler(manager);
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*"]];
    
    NSError *error = nil;
    NSURLRequest *request = [[manager requestSerializer] requestWithMethod:@"GET" URLString:URLString parameters:params error:&error];
    
    if (error && errorHandler) {
        errorHandler(error,nil);
    } else {        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
            [manager invalidateSessionCancelingTasks:YES];
            NSLog(@"\n请求路径 == %@ \n请求参数 == %@ \nresponseObject = %@ \nerror = %@ \n",URLString,params,responseObject,error);
            
            [self serverHandleResponseWithReponseObject:responseObject
                                                  error:error
                                   serverSuccessHandler:successHandler
                                     serverErrorHandler:errorHandler
                                             parameters:nil];
        }];
        [dataTask resume];
    }
}

- (void)requestPOST:(NSString *)URLString
             params:(NSDictionary *)params
   configureHandler:(void (^)(AFHTTPSessionManager *))configureHandler
     successHandler:(serverSuccessHandler)successHandler
       errorHandler:(serverErrorHandler)errorHandler
{
    NSAssert(URLString, @"请求URL路径不能为空");
    
    AFHTTPSessionManager *manager = [self defaultSessionManagerIsLogin:NO];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    NSError *error = nil;
    NSURLRequest *URLRequest = [[manager requestSerializer] requestWithMethod:@"POST" URLString:URLString parameters:params error:&error];
    if (error && errorHandler) {
        errorHandler(error,params);
    } else {
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:URLRequest completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
            [manager invalidateSessionCancelingTasks:YES];
            NSLog(@"\n请求路径 == %@",URLString);
            NSLog(@"\n请求参数 == %@",params);
            NSLog(@"\nresponseObject = %@",responseObject);
            NSLog(@"\nerror = %@",error);
            
            [self serverHandleResponseWithReponseObject:responseObject
                                                  error:error
                                   serverSuccessHandler:successHandler
                                     serverErrorHandler:errorHandler
                                             parameters:params];
        }];
        [dataTask resume];
    }
}


- (void)requestUploadPOST:(NSString *)URLString
                   params:(NSDictionary *)params
                   images:(NSArray *)images
           successHandler:(serverSuccessHandler)successHandler
             errorHandler:(serverErrorHandler)errorHandler
{
    NSAssert(URLString, @"请求URL路径不能为空");
    
    AFHTTPSessionManager *manager = [self defaultSessionManagerIsLogin:NO];
    
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:URLString
                                                                                             parameters:[self handleMultipartParameters:params]
                                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                  for (UIImage *image in images)
                                                                                  {
                                                                                      if ([image isKindOfClass:[UIImage class]])
                                                                                      {
                                                                                          NSData *data = [self compressImage:image toMaxFileSize:1024];
                                                                                          [formData appendPartWithFileData:data
                                                                                                                      name:kServerImagePath
                                                                                                                  fileName:@".png"
                                                                                                                  mimeType:@"image/png"];
                                                                                      }
                                                                                  }
                                                                              } error:&error];
    
    if (error && errorHandler)
    {
        errorHandler(error,params);
    } else {
        NSURLSessionUploadTask *dataTask = [manager uploadTaskWithStreamedRequest:request
                                                                         progress:nil
                                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                    [manager invalidateSessionCancelingTasks:YES];
                                                                    [self serverHandleResponseWithReponseObject:responseObject
                                                                                                          error:error
                                                                                           serverSuccessHandler:successHandler
                                                                                             serverErrorHandler:errorHandler
                                                                                                     parameters:params];
                                                                }];
        [dataTask resume];
    }
}

- (void)serverHandleResponseWithReponseObject:(id)responseObject
                                        error:(NSError *)error
                         serverSuccessHandler:(serverSuccessHandler)serverSuccessHandler
                           serverErrorHandler:(serverErrorHandler)serverErrorHandler
                                   parameters:(NSDictionary *)parameters {
    
    if (error) {
        serverErrorHandler(error,parameters);
    }else {
        if (responseObject) {
            serverSuccessHandler(responseObject,parameters);
        }else{
            NSError * error2 = [NSError errorWithDomain:NSNetServicesErrorDomain code:error.code userInfo:nil];
            serverErrorHandler(error2,parameters);
        }
    }
    
}

- (AFHTTPSessionManager *)defaultSessionManagerIsLogin:(BOOL)isLogin
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*"]];
    return manager;
}


- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return imageData;
}

- (NSDictionary *)handleMultipartParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSString *key in parameters.allKeys)
    {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]])
        {
            [dict setObject:[value dictTransformToJSONStringWithParameters:value] forKey:key];
        }
        else
        {
            [dict setObject:value forKey:key];
        }
    }
    return dict;
}


@end
