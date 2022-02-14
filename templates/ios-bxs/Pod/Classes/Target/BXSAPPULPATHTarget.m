//
//  BXSAPPULPATHTarget.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "BXSAPPULPATHTarget.h"

@implementation BXSAPPULPATHTarget

- (id)actionHome:(NSDictionary *)params {
   PROJECTViewController *vc = [[PROJECTViewController alloc] init];
//    vc.title = @"";
//    vc.uuid = params[@"uuid"];
   [self presentOrPushViewController:vc];
   return @(YES);
}

@end
