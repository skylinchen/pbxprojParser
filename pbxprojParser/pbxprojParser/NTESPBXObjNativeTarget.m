//
//  NTESPBXObjNativeTarget.m
//  NTESProtect
//
//  Created by NetEase on 17/4/26.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXObjNativeTarget.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXObjNativeTarget

- (BOOL)parseValue:(NSDictionary *)value forkey:(NSString *)key{
    BOOL bResult = YES;
    
    if (!value || value.count == 0 || !key) {
        return bResult;
    }
    
    self.guid = key;
    self.isaValue = value[PBXOBJ_ISA_KEY];
    self.buildConfigurationList = value[PBXOBJ_Target_Native_BCL];
    self.productReference = value[PBXOBJ_Target_Native_PR];
    self.productType = value[PBXOBJ_Target_Native_PT];
    self.productName = value[PBXOBJ_Target_Native_PN];
    self.buildPhases = value[PBXOBJ_Target_Native_BP];
    self.dependencies = value[PBXOBJ_Target_Native_D];
    self.name = value[PBXOBJ_Target_Native_N];
    self.buildRules = value[PBXOBJ_Target_Native_BR];
    
    return bResult;
}

@end
