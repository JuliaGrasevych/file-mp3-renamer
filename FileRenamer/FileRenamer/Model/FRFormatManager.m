//
//  FRFormatManager.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 07.03.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "FRFormatManager.h"
static NSString *const kFRFormatsFilename = @"formats.plist";

@implementation FRFormatManager

-(id)init
{
    self = [super init];
    if (self) {
        _formatTemplates = [NSMutableArray arrayWithCapacity:1];
        
    }
    return self;
}

-(void)saveFormatTemplate:(NSString *)formatString
{
    
}

-(void)loadFormatTemplates
{
    NSDictionary *formats = [NSDictionary dictionaryWithContentsOfFile:kFRFormatsFilename];
    if (formats.count == 0) {
        
    }
}

@end
