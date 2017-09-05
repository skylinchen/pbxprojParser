//
//  NTESXCDefine.h
//  pbxprojParser
//
//  Created by NetEase on 17/3/22.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#ifndef NTESXCDefine_h
#define NTESXCDefine_h

#define  PBXPRJ_PROJECT_SUFFIX              @".xcodeproj"
#define  PBXPRJ_WORKSPACE_SUFFIX            @".workspace"
#define  PBXPRJ_PROJECT_PBXPROJFILE         @"project.pbxproj"
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
#define  PBXOBJ_FileElement_FileReference           @"PBXFileReference"
#define  PBXOBJ_FileElement_FR_fileEncoding         @"fileEncoding"
#define  PBXOBJ_FileElement_FR_explicitFileType     @"explicitFileType"
#define  PBXOBJ_FileElement_FR_lastKnownFileType    @"lastKnownFileType"
#define  PBXOBJ_FileElement_FR_name                 @"name"
#define  PBXOBJ_FileElement_FR_path                 @"path"
#define  PBXOBJ_FileElement_FR_sourceTree           @"sourceTree"

#define  PBXOBJ_FileElement_Group           @"PBXGroup"
#define  PBXOBJ_FileElement_VariantGroup    @"PBXVariantGroup"

//(4) PBXTarget
#define  PBXOBJ_Target_Aggregate            @"PBXAggregateTarget"
#define  PBXOBJ_Target_Legacy               @"PBXLegacyTarget"
#define  PBXOBJ_Target_Native               @"PBXNativeTarget"

//(5) PBXProject
#define  PBXOBJ_Project                     @"PBXProject"

//(6) PBXTargetDependency
#define  PBXOBJ_TargetDependency            @"PBXTargetDependency"

//(7) XCBuildConfiguration
#define  PBXOBJ_BuildConfiguration          @"XCBuildConfiguration"
#define  PBXOBJ_BC_NAME                     @"name"
#define  PBXOBJ_BC_BUILDSETTINGS            @"buildSettings"

#define  PBXOBJ_BC_BS_CODE_SIGN_IDENTITY    @"CODE_SIGN_IDENTITY"
#define  PBXOBJ_BC_BS_COMBINE_HIDPI_IMAGES  @"COMBINE_HIDPI_IMAGES"
#define  PBXOBJ_BC_BS_SEARCH_PATHS          @"LD_RUNPATH_SEARCH_PATHS"
#define  PBXOBJ_BC_BS_INFOPLIST_FILE        @"INFOPLIST_FILE"
#define  PBXOBJ_BC_BS_BUNDLE_IDENTIFIER     @"PRODUCT_BUNDLE_IDENTIFIER"
#define  PBXOBJ_BC_BS_APPICON_NAME          @"ASSETCATALOG_COMPILER_APPICON_NAME"
#define  PBXOBJ_BC_BS_DEVELOPMENT_TEAM      @"DEVELOPMENT_TEAM"
#define  PBXOBJ_BC_BS_PRODUCT_NAME          @"PRODUCT_NAME"

//(8) XCConfigurationList
#define  PBXOBJ_ConfigurationList           @"XCConfigurationList"

#define  NTESCSTOOL_TESTS_SUFFIX            @"Tests"

#endif /* NTESXCDefine_h */
