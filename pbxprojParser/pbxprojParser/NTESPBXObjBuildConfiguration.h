//
//  NTESPBXObjBuildConfiguration.h
//  pbxprojParser
//
//  Created by NetEase on 17/4/21.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESPBXObjBase.h"

@interface NTESPBXObjBuildConfiguration : NTESPBXObjBase

@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSDictionary *buildSettings;

// buildSettings包含的字段
@property(nonatomic, strong)NSString *settings_bundle_id;
@property(nonatomic, strong)NSString *settings_code_sign_identify;
@property(nonatomic, strong)NSString *settings_combine_hidpi_images;
@property(nonatomic, strong)id settings_search_path_framework;  // 可能为字串，可能为数组
@property(nonatomic, strong)id settings_search_path_library;
@property(nonatomic, strong)id settings_search_path_ld_runpath;
@property(nonatomic, strong)NSString *settings_infoplist_file;
@property(nonatomic, strong)NSString *settings_appicon_name;
@property(nonatomic, strong)NSString *settings_development_team;
@property(nonatomic, strong)NSString *settings_product_name;
@property(nonatomic, strong)NSString *settings_sdkroot;
@property(nonatomic, strong)NSString *settings_deployment_target;

@end
