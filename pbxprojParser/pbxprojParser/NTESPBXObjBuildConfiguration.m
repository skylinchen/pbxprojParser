//
//  NTESPBXObjBuildConfiguration.m
//  pbxprojParser
//
//  Created by NetEase on 17/4/21.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXObjBuildConfiguration.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXObjBuildConfiguration

- (id)init {
    if (self = [super init]) {
        // Initialize self.
        self.isaValue = PBXOBJ_BuildConfiguration;
    }
    return self;
}

- (BOOL)parseValue:(NSDictionary *)value forkey:(NSString *)key{
    
    BOOL bResult = YES;
    
    if (!value || value.count == 0 || !key) {
        return NO;
    }
    
    self.guid = key;
    self.name = value[PBXOBJ_BC_NAME];
    self.buildSettings = value[PBXOBJ_BC_BUILDSETTINGS];
    //if (self.buildSettings && [self.buildSettings.allKeys containsObject:PBXOBJ_BC_BS_BUNDLE_IDENTIFIER]) {
    if (self.buildSettings){
        self.settings_bundle_id = self.buildSettings[PBXOBJ_BC_BS_BUNDLE_IDENTIFIER];
        self.settings_search_path_framework = self.buildSettings[PBXOBJ_BC_BS_SEARCH_PATHS_FRAMEWORK];
        self.settings_search_path_library = self.buildSettings[PBXOBJ_BC_BS_SEARCH_PATHS_LIB];
        self.settings_search_path_ld_runpath = self.buildSettings[PBXOBJ_BC_BS_SEARCH_PATHS_LD];
        self.settings_appicon_name = self.buildSettings[PBXOBJ_BC_BS_APPICON_NAME];
        self.settings_product_name = self.buildSettings[PBXOBJ_BC_BS_PRODUCT_NAME];
        self.settings_infoplist_file = self.buildSettings[PBXOBJ_BC_BS_INFOPLIST_FILE];
        self.settings_development_team = self.buildSettings[PBXOBJ_BC_BS_DEVELOPMENT_TEAM];
        self.settings_code_sign_identify = self.buildSettings[PBXOBJ_BC_BS_CODE_SIGN_IDENTITY];
        self.settings_combine_hidpi_images = self.buildSettings[PBXOBJ_BC_BS_COMBINE_HIDPI_IMAGES];
        self.settings_sdkroot = self.buildSettings[PBXOBJ_BC_BS_SDKROOT];
    }
    
    return bResult;
}

@end
