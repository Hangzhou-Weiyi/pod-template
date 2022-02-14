//
//  CTMediator+PROJECT.m
//  CTMediator_Category
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CTMediator+PROJECT.h"

static NSString *const BXSModuleTargetName = @"PROJECTTarget";

/// swift 跨模块调用需要Module Name
/// 因此如果target是swift需要传入，oc不需要传入
static NSString *const BXSModuleName = @"PROJECT";

@implementation CTMediator (PROJECT)

- (UIViewController *)PROJECTViewController{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kCTMediatorParamsKeySwiftTargetModuleName] = BXSModuleName;

    return [self performTarget:BXSModuleTargetName action:@"DWTestModuleViewController" params:params shouldCacheTarget:YES];
}

// - (UIViewController *)PROJECTViewControllerWithUuid:(NSString *)uuid {
//     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
//     params[@"uuid"] = uuid;
//     return [self performTarget:BXSModuleTargetName action:@"PROJECTViewController" params:[params copy] shouldCacheTarget:YES];
// }

// - (void)PROJECTViewController:(UIViewController *)vc setBlock:(void(^)(NSDictionary *dic))block {
//     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
//     params[@"vc"] = vc;
//     params[@"block"] = block;
//     [self performTarget:BXSModuleTargetName action:@"PROJECTViewController_setBlock" params:[params copy] shouldCacheTarget:YES];
// }

@end
