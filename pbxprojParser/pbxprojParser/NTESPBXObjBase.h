//
//  NTESPBXObjBase.h
//  pbxprojParser
//
//  Created by NetEase on 17/4/1.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESPBXObjBase : NSObject

@property(nonatomic, strong)NSString *isaValue;
@property(nonatomic, strong)NSString *guid;

- (BOOL)parseValue:(NSDictionary *)value forkey:(NSString *)key;

@end
