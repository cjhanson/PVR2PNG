/*
 *  PVR2PNG.m
 *
 *  Created by CJ Hanson on 3/19/10.
 *  Copyright 2010 Hanson Interactive.
 
 This software is provided 'as-is', without any express or implied
 warranty.  In no event will the authors be held liable for any damages
 arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not
 claim that you wrote the original software. If you use this software
 in a product, an acknowledgment in the product documentation would be
 appreciated but is not required.
 2. Altered source versions must be plainly marked as such, and must not be
 misrepresented as being the original software.
 3. This notice may not be removed or altered from any source distribution.
 
 * 
 */


//
// ALTERED
// Fri Apr 15 16:08:33 CEST 2011
// Espen Overaae (minthos@gmail.com)
// Applics AS
//



#import <Foundation/Foundation.h>

#import "GetPathsOperation.h"
#import "ImageOperations.h"
#import "PVRTextureUtilities.h"
NSString *getStringPathFromCString(const char *path);

BOOL g_isPremultiplied = NO;
BOOL g_exportPNG = YES;
BOOL g_noOutput = NO;
int g_pixelFormat = OGL_RGBA_8888;

int main (int argc, const char * argv[]) {    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSOperationQueue *opQueue	= [[NSOperationQueue alloc] init];
	Class opClass				= [ImageOperation class];
    
    if (argc == 1) {
      printf("\nRequired arguments: input.pvr(.ccz)\n");
      printf("\nSupported output arguments (default is png):\n");
      printf("[--ispremult] [--nooutput] [--pvrtc2] [--pvrtc4] [--pvr8888] [--pvr4444] [--pvr5551] [--pvr565] ");
      printf("[file ...]\n");
      printf("\nOrigin:\nOriginally by CJ Hanson (Hanson Interactive)\n");
      printf("Modified by Espen Overaae (Applics AS)\n");
      printf("Linked against POWERVR SDK (Imagination Technologies)\n");
    }
    
	for(int i=1; i<argc; i++){
		NSAutoreleasePool *loopPool = [NSAutoreleasePool new];
		NSString *argString				= [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
    if([argString isEqualToString:@"--nooutput"]){
      g_noOutput = YES;
    }else if([argString isEqualToString:@"--ispremult"]){
      g_isPremultiplied = YES;
    }else if([argString isEqualToString:@"--pvrtc2"]){
      g_exportPNG = NO;
      g_pixelFormat = OGL_PVRTC2;
    }else if([argString isEqualToString:@"--pvrtc4"]){
      g_exportPNG = NO;
      g_pixelFormat = OGL_PVRTC4;
    }else if([argString isEqualToString:@"--pvr8888"]){
      g_exportPNG = NO;
      g_pixelFormat = OGL_RGBA_8888;
    }else if([argString isEqualToString:@"--pvr4444"]){
      g_exportPNG = NO;
      g_pixelFormat = OGL_RGBA_4444;
    }else if([argString isEqualToString:@"--pvr5551"]){
      g_exportPNG = NO;
      g_pixelFormat = OGL_RGBA_5551;
    }else if([argString isEqualToString:@"--pvr565"]){
      g_exportPNG = NO;
      g_pixelFormat = OGL_RGB_565;
    }else {
      NSOperation *anOp = [[[GetPathsOperation alloc] initWithRootPath:argString operationClass:opClass queue:opQueue] autorelease];
      [opQueue addOperation:anOp];
    }
		[loopPool drain];
	}
	
	[opQueue waitUntilAllOperationsAreFinished];
  
	[opQueue release];
	
    [pool drain];
    return 0;
}


