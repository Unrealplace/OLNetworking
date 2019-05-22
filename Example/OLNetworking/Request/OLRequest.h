//
//  OLRequest.h
//  OLNetworking_Example
//
//  Created by LiYang on 2019/5/22.
//  Copyright © 2019 Unrealplace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLRequestManager.h"
#import "OLNetworkConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface OLRequest : NSObject
//单一域名
+ (void)requestWithPostMethodParams:(NSDictionary*)params
                                url:(NSString *)url
                      completionHandler:(serverSuccessHandler)completionHandler
                           errorHandler:(serverErrorHandler)errorHandler ;

//多模块，多域名
+ (void)requestWithPostMethodParams:(NSDictionary*)params
                            urlType:(OLURLType)urlType
                            loading:(BOOL)isLoading
                  completionHandler:(serverSuccessHandler)completionHandler
                       errorHandler:(serverErrorHandler)errorHandler ;

+ (void)requestWithPostMethodParams:(NSDictionary*)params
                                url:(NSString *)url
                            loading:(BOOL)isLoading
                  completionHandler:(serverSuccessHandler)completionHandler
                       errorHandler:(serverErrorHandler)errorHandler ;

@end

NS_ASSUME_NONNULL_END
