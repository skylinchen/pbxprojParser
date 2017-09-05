//
//  NTESPBXRootObjects.m
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXRootObjects.h"
#import "NTESPBXDefine.h"

@implementation NTESPBXRootObjects

- (id)init {
    if (self = [super init]) {
        // Initialize self.
        self.key = PBXPRJ_PROJECT_ROOTOBJ;
    }
    return self;
}

- (BOOL)parseRootObject:(NSString *)object{
    BOOL bResult = YES;
    
    if (object && object.length > 0) {
        self.value = object;
    }
    
    return bResult;
}

@end
