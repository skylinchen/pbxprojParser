//
//  NTESPBXObjNativeTarget.h
//  NTESProtect
//
//  Created by NetEase on 17/4/26.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESPBXObjBase.h"

@interface NTESPBXObjNativeTarget : NTESPBXObjBase

@property(nonatomic, strong)NSString *buildConfigurationList;
@property(nonatomic, strong)NSString *productReference;
@property(nonatomic, strong)NSString *productType;
@property(nonatomic, strong)NSString *productName;
@property(nonatomic, strong)NSArray *buildPhases;
@property(nonatomic, strong)NSArray *dependencies;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSArray *buildRules;

@end
