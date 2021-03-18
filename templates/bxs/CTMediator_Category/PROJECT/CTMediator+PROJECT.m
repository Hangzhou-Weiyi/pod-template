//
//  CTMediator+PROJECT.m
//  CTMediator_Category
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CTMediator+PROJECT.h"

static NSString *const PROJECTTarget = @"PROJECT";

@implementation CTMediator (PROJECT)

// - (UIViewController *)PROJECTViewController{
//     return [self performTarget:PROJECTTarget action:@"PROJECTViewController" params:nil shouldCacheTarget:YES];
// }

// - (UIViewController *)PROJECTViewControllerWithUuid:(NSString *)uuid {
//     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
//     params[@"uuid"] = uuid;
//     return [self performTarget:PROJECTTarget action:@"PROJECTViewController" params:[params copy] shouldCacheTarget:YES];
// }

// - (void)PROJECTViewController:(UIViewController *)vc setBlock:(void(^)(NSDictionary *dic))block {
//     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
//     params[@"vc"] = vc;
//     params[@"block"] = block;
//     [self performTarget:PROJECTTarget action:@"PROJECTViewController_setBlock" params:[params copy] shouldCacheTarget:YES];
// }

@end
