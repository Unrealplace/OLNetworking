//
//  OLRequest.m
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import "OLRequest.h"
#import "OLRequestManager.h"
#import "OLNetworkConfigure.h"
#import "NSDictionary+Sign.h"

@implementation OLRequest

+ (void)requestWithPostMethodParams:(NSDictionary*)params
                                url:(NSString *)url
                  completionHandler:(serverSuccessHandler)completionHandler
                       errorHandler:(serverErrorHandler)errorHandler {
    NSString *domain = [OLNetworkConfigure domainWithModuleType:OLNetworkModuleTypeDefault];
    url = [domain stringByAppendingFormat:@"%@",url];
    [self requestWithPostMethodParams:params
                                  url:url
                    completionHandler:completionHandler
                         errorHandler:errorHandler];
}

//多模块，多域名
+ (void)requestWithPostMethodParams:(NSDictionary*)params
                            urlType:(OLURLType)urlType
                            loading:(BOOL)isLoading
                  completionHandler:(serverSuccessHandler)completionHandler
                       errorHandler:(serverErrorHandler)errorHandler {
    NSString *url = [OLNetworkConfigure URLWithType:urlType];
    params = [params signParameters];
    [self requestWithPostMethodParams:params
                                  url:url
                    completionHandler:completionHandler
                         errorHandler:errorHandler];
}


+ (void)requestWithPostMethodParams:(NSDictionary*)params
                                url:(NSString *)url
                            loading:(BOOL)isLoading
                  completionHandler:(serverSuccessHandler)completionHandler
                       errorHandler:(serverErrorHandler)errorHandler {
    if (isLoading) {
        
    }
    params = [params signParameters];
    extracted(completionHandler, errorHandler, params, url);
    
}


static void extracted(serverSuccessHandler completionHandler, serverErrorHandler errorHandler, NSDictionary *params, NSString *stringURL) {
    [[OLRequestManager sharedManager] requestPOST:stringURL
                                           params:params
                                 configureHandler:nil
                                   successHandler:^(id responseObject, NSDictionary *params) {
                                       completionHandler(responseObject,params);
                                   } errorHandler:errorHandler];
}


@end
