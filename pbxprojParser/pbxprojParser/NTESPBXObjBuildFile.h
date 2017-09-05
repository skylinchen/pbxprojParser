//
//  NTESPBXBuildFile.h
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESPBXObjBase.h"

@interface NTESPBXObjBuildFile : NTESPBXObjBase

@property(nonatomic, strong)NSString *fileRef;
@property(nonatomic, strong)NSDictionary *settings;
@property(nonatomic, strong)NSString *settings_attr;

//- (BOOL)parseValue:(NSDictionary *)value forkey:(NSString *)key;

@end
