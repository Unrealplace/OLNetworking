//
//  OLRequestManager.h
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ serverSuccessHandler)(id responseObject, NSDictionary *params);
typedef void (^ serverErrorHandler)(NSError *error, NSDictionary *params);

@interface OLRequestManager : NSObject

+ (OLRequestManager *)sharedManager;

- (void)requestGET:(NSString *)URLString
            params:(NSDictionary *)params
  configureHandler:(void(^)(AFHTTPSessionManager * manager))configureHandler
    successHandler:(serverSuccessHandler)successHandler
      errorHandler:(serverErrorHandler)errorHandler;

- (void)requestPOST:(NSString *)URLString
             params:(NSDictionary *)params
   configureHandler:(void(^)(AFHTTPSessionManager * manager))configureHandler
     successHandler:(serverSuccessHandler)successHandler
       errorHandler:(serverErrorHandler)errorHandler;

- (void)requestUploadPOST:(NSString *)URLString
                   params:(NSDictionary *)params
                   images:(NSArray *)images
           successHandler:(serverSuccessHandler)successHandler
             errorHandler:(serverErrorHandler)errorHandler;

@end

NS_ASSUME_NONNULL_END
