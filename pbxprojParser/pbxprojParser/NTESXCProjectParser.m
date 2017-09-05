//
//  NTESXCProjectParser.m
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESXCProjectParser.h"
#import "NTESPBXDefine.h"


@interface NTESXCProjectParser()

@property(nonatomic, strong)NSString *projectDir;

@property(nonatomic, strong)NTESPBXClasses *pbxprojClasses;
@property(nonatomic, strong)NTESPBXObjectVersion *pbxprojObjVersion;
@property(nonatomic, strong)NTESPBXArchiveVersion *pbxprojArchiveVersion;

@property(nonatomic, strong)NTESPBXObjects *pbxprojObjs;
@property(nonatomic, strong)NTESPBXRootObjects *pbxprojRootObj;

@property(nonatomic, strong)NTESPBXObjGroup *pbxprojRootGroup;
@property(nonatomic, strong)NTESPBXObjProject *pbxprojRootProject;

@property(nonatomic, assign)BOOL bParseStatus;

@end

@implementation NTESXCProjectParser

+ (NTESXCProjectParser *)sharedInstance{
    static dispatch_once_t onceToken = 0;
    static NTESXCProjectParser *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTESXCProjectParser alloc] init];
        sharedObject.bParseStatus = NO;
    });
    
    return sharedObject;
}

- (BOOL)parsePBXProj:(NSString *)file error:(out NSError **)error{
    BOOL bResult = NO;
    
    // 参数的有效性判断
    if (!file || file.length == 0) {
        return bResult;
    }
    
    // 已经成功解析过，就不用再解析了
    if (self.bParseStatus) {
        return YES;
    }
    
    // 文件类型的有效性判断
    if(![file hasSuffix:PBXPRJ_PROJECT_SUFFIX] && ![file hasSuffix:PBXPRJ_WORKSPACE_SUFFIX]){
        return bResult;
    }
    
    // 由".xcodeproj", ".xcworkspace"文件得到对应的".pbxproj"文件
    NSMutableString *pbxprjFile = nil;
    if ([file hasSuffix:PBXPRJ_PROJECT_SUFFIX]) {
        pbxprjFile = [[NSMutableString alloc] initWithString:file];
    }else if ([file hasSuffix:PBXPRJ_WORKSPACE_SUFFIX]) {
        pbxprjFile = [self getProjectFromWorkspace:file];
    }
    
    // 获取项目路径
    NSRange range = [pbxprjFile rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        self.projectDir = [pbxprjFile substringToIndex:range.location];
    }
    
    // 获取project.pbxproj文件路径
    [pbxprjFile appendFormat:@"/%@", PBXPRJ_PROJECT_PBXPROJFILE];
    
    NSFileManager * fileManager =[NSFileManager defaultManager];
    if(fileManager){
        // 文件存在性的判断
        if ([fileManager fileExistsAtPath:file]) {
            NSData *data = [NSData dataWithContentsOfFile:pbxprjFile];
            if (!data){
                NSLog(@"open file failed: %@\n", pbxprjFile);
                return bResult;
            }
            
            NSError *serializeError = nil;
            NSPropertyListFormat plistFormat;
            NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:data
                                                                            options:NSPropertyListImmutable
                                                                             format:&plistFormat
                                                                              error:&serializeError];
            if (serializeError || !plist) {
                NSLog(@"serialize file failed:%@\n", serializeError);
                *error = serializeError;
                return bResult;
            }
            
            bResult = [self analyzePropertyList:plist error:error];
        }
    }
 
//#ifndef __OPTIMIZE__
    //NSLog(@"class:%@\n", self.pbxprojClasses);
    //NSLog(@"ObjVersion:%@\n", self.pbxprojObjVersion);
    //NSLog(@"ArchiveVersion:%@\n", self.pbxprojArchiveVersion);
    //NSLog(@"RootObj:%@\n", self.pbxprojRootObj);
//#endif
    
    self.bParseStatus = bResult;
    
    return bResult;
}

- (NSMutableString *)getProjectFromWorkspace:(NSString *)workspace{
    
    NSMutableString *pbxprjFile = nil;
    
    NSString *workspaceContentDataPath = [NSString stringWithFormat:@"%@/%@", workspace, PBXPRJ_WORKSPACE_CONTENT_DATA];
    NSString *fileContent = [NSString stringWithContentsOfFile:workspaceContentDataPath encoding:NSUTF8StringEncoding error:nil];
    if (fileContent) {
        
        NSString *projectPath = nil;
        if ([fileContent containsString:PBXPRJ_WORKSPACE_CD_END]) {
            projectPath = [self getProjectPathAccordFileref:fileContent];
        }else if([fileContent containsString:PBXPRJ_WORKSPACE_CD_END2]){
            projectPath = [self getProjectPathAccordOther:fileContent];
        }
        
        NSString *upDir = [workspace stringByDeletingLastPathComponent];
        pbxprjFile = [[NSMutableString alloc] initWithFormat:@"%@/%@", upDir, projectPath];
        
    }else{
        // 同级目录去找
        NSRange range = [workspace rangeOfString:PBXPRJ_WORKSPACE_SUFFIX options:NSBackwardsSearch];
        if (range.location == NSNotFound) {
            return pbxprjFile;
        }
        
        NSString *subFile = [workspace substringToIndex:range.location];
        pbxprjFile = [[NSMutableString alloc] initWithString:subFile];
    }
    
    return pbxprjFile;
}

/* ".xcworkspace"文件,需要读取它的contents.xcworkspacedata文件，找到".xcodeproj"文件,而不一定在同目录
 * 含有 </FileRef> 格式
 *  (1) 单个项目
 *  <?xml version="1.0" encoding="UTF-8"?>
    <Workspace
        version = "1.0">
        <FileRef
            location = "group:Dash/Dash iOS.xcodeproj">
        </FileRef>
        <FileRef
            location = "group:Pods/Pods.xcodeproj">
        </FileRef>
    </Workspace>
 
 *  (2)含有多个项目
 *  <?xml version="1.0" encoding="UTF-8"?>
    <Workspace
        version = "1.0">
        <FileRef
            location = "group:MessageDisplayKitLeanchatExample/MessageDisplayKitLeanchatExample.xcodeproj">
        </FileRef>
        <FileRef
            location = "group:MessageDisplayKitWeChatExample/MessageDisplayKitWeChatExample.xcodeproj">
        </FileRef>
        <FileRef
            location = "group:MessageDisplayKitCoreDataExample/MessageDisplayKitCoreDataExample.xcodeproj">
        </FileRef>
        <FileRef
            location = "group:MessageDisplayKitStoryBoradExample/MessageDisplayKitStoryBoradExample.xcodeproj">
        </FileRef>
        <FileRef
            location = "group:MessageDisplayKit/MessageDisplayKit.xcodeproj">
        </FileRef>
        <FileRef
            location = "group:MessageDisplayKitLib/MessageDisplayKitLib.xcodeproj">
        </FileRef>
    </Workspace>
 */
- (NSString *)getProjectPathAccordFileref:(NSString *)fileContent{
 
    NSString *projectPath = nil;
 
    if (!fileContent || fileContent.length == 0) {
        return nil;
    }
    
    if (!self.scheme || self.scheme.length == 0) {
        return nil;
    }
    
    // 先把所有的读取出来
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    NSString *content = fileContent;
    while (1) {
        
        if (!content || content.length == 0) {
            break;
        }
        
        NSRange rangeBegin = [content rangeOfString:PBXPRJ_WORKSPACE_CD_BEGIN];
        if (rangeBegin.location == NSNotFound) {
            break;
        }
        
        NSRange rangeEnd = [content rangeOfString:PBXPRJ_WORKSPACE_CD_END];
        if (rangeEnd.location == NSNotFound) {
            break;
        }
        
        NSInteger begin = rangeBegin.location + rangeBegin.length;
        NSRange range = NSMakeRange(begin, rangeEnd.location - begin);
        NSString *subString = [content substringWithRange:range];
        
        // 删除后面的 "> 符号
        NSRange rangeEnd1 = [subString rangeOfString:PBXPRJ_WORKSPACE_CD_END1];
        if (rangeEnd1.location == NSNotFound) {
            break;
        }
        NSString *group = [subString substringToIndex:rangeEnd1.location];
        
        if( ![group hasPrefix:PBXPRJ_WORKSPACE_CD_PODS]){
            [groups addObject:group];
        }
        
        content = [content substringFromIndex:rangeEnd.location + rangeEnd.length];
    }

    if(groups && groups.count > 1){
        // 判断和scheme相等的
        for (NSString *group in groups) {
            if ([group hasPrefix:self.scheme]) {
                projectPath = group;
                break;
            }
        }
        
        // 没有匹配到，传递第一个
        if (!projectPath || projectPath.length == 0) {
            projectPath = [groups objectAtIndex:0];
        }
        
    }else if(groups && groups.count == 1){
        projectPath = [groups objectAtIndex:0];
    }
    
    return projectPath;
}

/*
*   有些项目的group这里是单引号，并且也没有换行  <FileRef location='group:AGEmojiKeyboardSample.xcodeproj'/>
    <?xml version='1.0' encoding='UTF-8'?><Workspace version='1.0'><FileRef location='group:AGEmojiKeyboardSample.xcodeproj'/><FileRef location='group:Pods/Pods.xcodeproj'/></Workspace>
*/
- (NSString *)getProjectPathAccordOther:(NSString *)fileContent{
    
    NSString *projectPath = nil;
    
    if (!fileContent || fileContent.length == 0) {
        return nil;
    }
    
    if (!self.scheme || self.scheme.length == 0) {
        return nil;
    }
    
    // 先把所有的读取出来
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    NSString *content = fileContent;
    while (1) {
        
        if (!content || content.length == 0) {
            break;
        }
        
        NSRange rangeBegin = [content rangeOfString:PBXPRJ_WORKSPACE_CD_BEGIN];
        if (rangeBegin.location == NSNotFound) {
            break;
        }
        
        NSRange rangeEnd = [content rangeOfString:PBXPRJ_WORKSPACE_CD_END2];
        if (rangeEnd.location == NSNotFound) {
            break;
        }
        
        NSInteger begin = rangeBegin.location + rangeBegin.length;
        NSRange range = NSMakeRange(begin, rangeEnd.location - begin - 1);
        NSString *group = [content substringWithRange:range];
        
        if( ![group hasPrefix:PBXPRJ_WORKSPACE_CD_PODS]){
            [groups addObject:group];
        }
        
        content = [content substringFromIndex:rangeEnd.location + rangeEnd.length];
    }
    
    if(groups && groups.count > 1){
        // 判断和scheme相等的
        for (NSString *group in groups) {
            if ([group hasPrefix:self.scheme]) {
                projectPath = group;
                break;
            }
        }
        
        // 没有匹配到，传递第一个
        if (!projectPath || projectPath.length == 0) {
            projectPath = [groups objectAtIndex:0];
        }
        
    }else if(groups && groups.count == 1){
        projectPath = [groups objectAtIndex:0];
    }
    
    return projectPath;
}

- (BOOL)analyzePropertyList:(NSDictionary *)plist error:(out NSError **)error{
    BOOL bResult = YES;
    
    if (!plist) {
        return NO;
    }
    
    if ([plist isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in plist) {
            if ([key isEqualToString:PBXPRJ_PROJECT_CLASSES]) {
                self.pbxprojClasses = [[NTESPBXClasses alloc] init];
                id value = plist[key];
                if ([value isKindOfClass:[NSDictionary class]]) {
                    [self.pbxprojClasses parseClasses:value];
                }
            }else if([key isEqualToString:PBXPRJ_PROJECT_ARCHIVEVER]){
                self.pbxprojArchiveVersion = [[NTESPBXArchiveVersion alloc] init];
                id value = plist[key];
                if ([value isKindOfClass:[NSString class]]) {
                    [self.pbxprojArchiveVersion parseArchiveVersion:value];
                }
            }else if([key isEqualToString:PBXPRJ_PROJECT_OBJVERSION]){
                self.pbxprojObjVersion = [[NTESPBXObjectVersion alloc] init];
                id value = plist[key];
                if ([value isKindOfClass:[NSString class]]) {
                    [self.pbxprojObjVersion parseObjVersion:value];
                }
            }else if([key isEqualToString:PBXPRJ_PROJECT_OBJECTS]){
                self.pbxprojObjs = [[NTESPBXObjects alloc] init];
                id value = plist[key];
                if ([value isKindOfClass:[NSDictionary class]]) {
                    [self.pbxprojObjs parserObjects:plist[key]];
                }
            }else if([key isEqualToString:PBXPRJ_PROJECT_ROOTOBJ]){
                self.pbxprojRootObj = [[NTESPBXRootObjects alloc] init];
                id value = plist[key];
                if ([value isKindOfClass:[NSString class]]) {
                    [self.pbxprojRootObj parseRootObject: value];
                }
            }
        }
    }
    
    return bResult;
}

- (NSMutableSet *)getPublicHeaderFiles{
    if (self.pbxprojObjs) {
        return [self.pbxprojObjs getPublicHeaderFiles];
    }else{
        return nil;
    }
}

- (NSString *)getBundleIdentifier{
    if (self.pbxprojObjs) {
        return [self.pbxprojObjs getBundleIdentifier:self.scheme];
    }else{
        return nil;
    }
}

- (NSString *)getProductName{
    
    if (!self.scheme || self.scheme.length == 0) {
        return nil;
    }
    
    if (self.pbxprojObjs) {
        return [self.pbxprojObjs getProductName:self.scheme];
        
    }else{
        return nil;
    }
}

- (BOOL)isApplication{
    if (self.pbxprojObjs) {
        return [self.pbxprojObjs isApplication];
    }else{
        return YES;
    }
}

- (NSArray *)getThirdLibraries:(NTESPBXOBJ_CONFIGURATION_TYPE)config{
    if (self.pbxprojObjs) {
        return [self.pbxprojObjs getThirdLibraries:self.projectDir configuration:config];
    }else{
        return nil;
    }
}

- (NTESPBXOBJ_PLATFORM_TYPE)getPlatformType{
    if (self.pbxprojObjs) {
        return [self.pbxprojObjs getPlatformType];
    }else{
        return NTESPBXOBJ_PLATFORM_TYPE_DEFAULT;
    }
}

- (NSString *)getInfoPlist{
    if (self.pbxprojObjs) {
        return [self.pbxprojObjs getInfoPlist:self.scheme];
    }else{
        return nil;
    }
}

@end
