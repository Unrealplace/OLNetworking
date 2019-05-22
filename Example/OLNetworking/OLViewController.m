//
//  OLViewController.m
//  OLNetworking
//
//  Created by Unrealplace on 05/22/2019.
//  Copyright (c) 2019 Unrealplace. All rights reserved.
//

#import "OLViewController.h"
#import "Request/OLRequest.h"
@interface OLViewController ()

@end

@implementation OLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [OLRequest requestWithPostMethodParams:@{}
                                       url:@"/hello/page"
                         completionHandler:^(id  _Nonnull responseObject, NSDictionary * _Nonnull params) {
                             
                         } errorHandler:^(NSError * _Nonnull error, NSDictionary * _Nonnull params) {
                             
                         }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
