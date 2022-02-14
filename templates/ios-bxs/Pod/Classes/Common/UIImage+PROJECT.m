//
//  UIImage+PROJECT.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "UIImage+PROJECT.h"
#import <bxs_base_lib/UIImage+BXSEnv.h>

@implementation UIImage (PROJECT)

+ (UIImage *)PROJECT_imageNamed:(NSString *)name {
   return [UIImage wy_imageNamed:name forPod:@"PROJECT"];
}

@end
