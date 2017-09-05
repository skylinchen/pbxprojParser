//
//  NTESPBXObjFileElement.h
//  pbxprojParser
//
//  Created by NetEase on 17/4/5.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESPBXObjBase.h"

@interface NTESPBXObjFileElement : NTESPBXObjBase

@property(nonatomic, assign)NSInteger fileEncoding;

@property(nonatomic, strong)NSString *explicitFileType;
@property(nonatomic, strong)NSString *lastKnownFileType;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *path;
@property(nonatomic, strong)NSString *sourceTree;
@property(nonatomic, strong)NSString *includeInIndex;

//- (BOOL)parseValue:(NSDictionary *)value forkey:(NSString *)key;

@end
