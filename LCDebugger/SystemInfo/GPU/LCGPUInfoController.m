//
//  GPUInfoController.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import <GLKit/GLKit.h>
#import "LCLog.h"
#import "LCGPUInfo.h"
#import "LCGPUInfoController.h"

@interface LCGPUInfoController()
@property (nonatomic, strong) LCGPUInfo *gpuInfo;
@end

@implementation LCGPUInfoController
@synthesize gpuInfo;

/*
 * TIP: that's how we should fetch info about GPU.
 
 NSString *extensionStr = [NSString stringWithCString:glGetString(GL_EXTENSIONS) encoding:NSASCIIStringEncoding];
 NSArray *arr = [extensionStr componentsSeparatedByString:@" "];
 */

- (LCGPUInfo*)getGPUInfo
{
    if (!gpuInfo)
    {
        // TODO: this needs to go elsewhere.
        // Maybe when we will start to utilize OpenGL for our drawings.
        EAGLContext *ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:ctx];
        
        self.gpuInfo = [[LCGPUInfo alloc] init];
        self.gpuInfo.gpuName = [NSString stringWithCString:(const char*)glGetString(GL_RENDERER) encoding:NSASCIIStringEncoding];
        self.gpuInfo.openGLVendor = [NSString stringWithCString:(const char*)glGetString(GL_VENDOR) encoding:NSASCIIStringEncoding];
        self.gpuInfo.openGLVersion = [NSString stringWithCString:(const char*)glGetString(GL_VERSION) encoding:NSASCIIStringEncoding];
        
        NSString *extensions = [NSString stringWithCString:(const char*)glGetString(GL_EXTENSIONS) encoding:NSASCIIStringEncoding];
        NSMutableArray *extArray = [NSMutableArray arrayWithArray:[extensions componentsSeparatedByString:@" "]];
        // Last object is always empty because of trailing space.
        [extArray removeLastObject];
        [extArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.gpuInfo.openGLExtensions = extArray;
    
        GLenum glError = glGetError();
        if (glError != GL_NO_ERROR)
        {
            ERROR(@"glGetError() == %d", glError);
        }
    }
    
    return gpuInfo;
}

@end
