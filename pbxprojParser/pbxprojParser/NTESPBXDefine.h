//
//  NTESXCDefine.h
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#ifndef NTESXCDefine_h
#define NTESXCDefine_h

typedef NS_ENUM(NSInteger, NTESPBXOBJ_PLATFORM_TYPE){
    NTESPBXOBJ_PLATFORM_TYPE_DEFAULT = 0,
    NTESPBXOBJ_PLATFORM_TYPE_IOS        ,
    NTESPBXOBJ_PLATFORM_TYPE_MACOS      ,
};

#define  PBXPRJ_PROJECT_SUFFIX              @".xcodeproj"
#define  PBXPRJ_WORKSPACE_SUFFIX            @".xcworkspace"
#define  PBXPRJ_WORKSPACE_CONTENT_DATA      @"contents.xcworkspacedata"
#define  PBXPRJ_PROJECT_PBXPROJFILE         @"project.pbxproj"
#define  PBXPRJ_WORKSPACE_CD_BEGIN          @"group:"
#define  PBXPRJ_WORKSPACE_CD_END            @"</FileRef>"
#define  PBXPRJ_WORKSPACE_CD_END1           @"\">"
#define  PBXPRJ_WORKSPACE_CD_END2            @"/>"
#define  PBXPRJ_WORKSPACE_CD_PODS           @"Pods/"

// 整体定义
#define  PBXPRJ_PROJECT_CLASSES             @"classes"
#define  PBXPRJ_PROJECT_OBJVERSION          @"objectVersion"
#define  PBXPRJ_PROJECT_ARCHIVEVER          @"archiveVersison"
#define  PBXPRJ_PROJECT_OBJECTS             @"objects"
#define  PBXPRJ_PROJECT_ROOTOBJ             @"rootObject"

// objects定义
#define  PBXOBJ_ISA_KEY                     @"isa"
#define  PBXOBJ_ISA_VALUE                   @"unknown"

//(1) PBXBuildFile
#define  PBXOBJ_BuildFile                   @"PBXBuildFile"
#define  PBXOBJ_BuildFile_FILEREF           @"fileRef"

#define  PBXOBJ_BuildFile_SETTINGS          @"settings"
#define  PBXOBJ_BuildFile_SETTINGS_ATTR     @"ATTRIBUTES"
#define  PBXOBJ_BuildFile_SETTINGS_ATTR_1   @"Public"
#define  PBXOBJ_BuildFile_SETTINGS_ATTR_2   @"Weak"

//(2) PBXBuildPhase
#define  PBXOBJ_BuildPhase_AppleScript      @"PBXAppleScriptBuildPhase"
#define  PBXOBJ_BuildPhase_CopyFiles        @"PBXCopyFilesBuildPhase"
#define  PBXOBJ_BuildPhase_Frameworks       @"PBXFrameworksBuildPhase"
#define  PBXOBJ_BuildPhase_Headers          @"PBXHeadersBuildPhase"
#define  PBXOBJ_BuildPhase_Resources        @"PBXResourcesBuildPhase"
#define  PBXOBJ_BuildPhase_ShellScript      @"PBXShellScriptBuildPhase"
#define  PBXOBJ_BuildPhase_Sources          @"PBXSourcesBuildPhase"
#define  PBXOBJ_ContainerItemProxy          @"PBXContainerItemProxy"

//(3) PBXFileElement
#define  PBXOBJ_FileElement_FileReference               @"PBXFileReference"
#define  PBXOBJ_FileElement_FR_fileEncoding             @"fileEncoding"
#define  PBXOBJ_FileElement_FR_explicitFileType         @"explicitFileType"
#define  PBXOBJ_FileElement_FR_lastKnownFileType        @"lastKnownFileType"
#define  PBXOBJ_FileElement_FR_lastKnownFileType_FRAMEWORK      @"wrapper.framework"
#define  PBXOBJ_FileElement_FR_lastKnownFileType_Library        @"archive.ar"
#define  PBXOBJ_FileElement_FR_name                     @"name"
#define  PBXOBJ_FileElement_FR_path                     @"path"
#define  PBXOBJ_FileElement_FR_sourceTree               @"sourceTree"

#define  PBXOBJ_FileElement_FR_PATH_SYSTEM              @"System/Library"
#define  PBXOBJ_FileElement_FR_PATH_SYSTEM_lib          @"usr/include"
#define  PBXOBJ_FileElement_FR_PATH_INHERITED           @"$(inherited)"
#define  PBXOBJ_FileElement_FR_PATH_SDKROOT             @"$(SDKROOT)/"
#define  PBXOBJ_FileElement_FR_PATH_PROJECT_DIR         @"$(PROJECT_DIR)"

#define  PBXOBJ_FileElement_Group               @"PBXGroup"
#define  PBXOBJ_FileElement_VariantGroup        @"PBXVariantGroup"

//(4) PBXTarget
#define  PBXOBJ_Target_Aggregate                @"PBXAggregateTarget"
#define  PBXOBJ_Target_Legacy                   @"PBXLegacyTarget"
#define  PBXOBJ_Target_Native                   @"PBXNativeTarget"
#define  PBXOBJ_Target_Native_BCL               @"buildConfigurationList"
#define  PBXOBJ_Target_Native_PR                @"productReference"
#define  PBXOBJ_Target_Native_PT                @"productType"
#define  PBXOBJ_Target_Native_PN                @"productName"
#define  PBXOBJ_Target_Native_BP                @"buildPhases"
#define  PBXOBJ_Target_Native_D                 @"dependencies"
#define  PBXOBJ_Target_Native_N                 @"name"
#define  PBXOBJ_Target_Native_BR                @"buildRules"
#define  PBXOBJ_Target_Native_BUNDLEID_SUB      @"${PRODUCT_NAME"
#define  PBXOBJ_Target_Native_BUNDLEID_SUB_     @"$(PRODUCT_NAME"
#define  PBXOBJ_Target_Native_PT_APPVALUE       @"com.apple.product-type.application"
#define  PBXOBJ_Target_Native_PT_ToolVALUE      @"com.apple.product-type.tool"
#define  PBXOBJ_Target_Native_PT_PreffixVALUE   @"com.apple.product-type.application."
#define  PBXOBJ_Target_Native_PT_STATICLIBVALUE @"com.apple.product-type.library.static"
#define  PBXOBJ_Target_Native_PT_DYMLIBVALUE    @"com.apple.product-type.framework"

//(5) PBXProject
#define  PBXOBJ_Project                         @"PBXProject"

//(6) PBXTargetDependency
#define  PBXOBJ_TargetDependency                @"PBXTargetDependency"

//(7) XCBuildConfiguration
#define  PBXOBJ_BuildConfiguration              @"XCBuildConfiguration"
#define  PBXOBJ_BC_NAME                         @"name"
#define  PBXOBJ_BC_NAME_DEBUG                   @"Debug"
#define  PBXOBJ_BC_NAME_RELEASE                 @"Release"
#define  PBXOBJ_BC_BUILDSETTINGS                @"buildSettings"

#define  PBXOBJ_BC_BS_CODE_SIGN_IDENTITY        @"CODE_SIGN_IDENTITY"
#define  PBXOBJ_BC_BS_COMBINE_HIDPI_IMAGES      @"COMBINE_HIDPI_IMAGES"
#define  PBXOBJ_BC_BS_SEARCH_PATHS_LD           @"LD_RUNPATH_SEARCH_PATHS"
#define  PBXOBJ_BC_BS_SEARCH_PATHS_FRAMEWORK    @"FRAMEWORK_SEARCH_PATHS"
#define  PBXOBJ_BC_BS_SEARCH_PATHS_LIB          @"LIBRARY_SEARCH_PATHS"
#define  PBXOBJ_BC_BS_INFOPLIST_FILE            @"INFOPLIST_FILE"
#define  PBXOBJ_BC_BS_BUNDLE_IDENTIFIER         @"PRODUCT_BUNDLE_IDENTIFIER"
#define  PBXOBJ_BC_BS_APPICON_NAME              @"ASSETCATALOG_COMPILER_APPICON_NAME"
#define  PBXOBJ_BC_BS_DEVELOPMENT_TEAM          @"DEVELOPMENT_TEAM"
#define  PBXOBJ_BC_BS_PRODUCT_NAME              @"PRODUCT_NAME"
#define  PBXOBJ_BC_BS_SDKROOT                   @"SDKROOT"
#define  PBXOBJ_BC_BS_SDKROOT_VALUE_IOS         @"iphoneos"
#define  PBXOBJ_BC_BS_SDKROOT_VALUE_MAC         @"macosx"
#define  PBXOBJ_BC_BS_IPHONEOS_DEPLOYMENT_TARGET    @"IPHONEOS_DEPLOYMENT_TARGET"

//(8) XCConfigurationList
#define  PBXOBJ_ConfigurationList               @"XCConfigurationList"

// 特殊文件
#define  NTESCSTOOL_TESTS_SUFFIX                @"Tests"
#define  NTESCSTOOL_TESTS_CONTAIN               @"Tests/"
#define  NTESCSTOOL_INFOPLIST_FILENAME          @"Info.plist"

#endif /* NTESXCDefine_h */
