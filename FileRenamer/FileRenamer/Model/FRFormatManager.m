//
//  FRFormatManager.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 07.03.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "FRFormatManager.h"
#import "NSString+Hashes.h"

static NSString *const kFRFormatsFilename = @"formats.plist";

@interface FRFormatManager ()

@property (nonatomic) NSArray *predefinedFormats;

@end

@implementation FRFormatManager

-(id)init
{
    self = [super init];
    if (self) {
        _formatTemplates = nil;
        [self loadFormatTemplates];
    }
    return self;
}

-(BOOL)saveFormatTemplate:(NSString *)formatString
{
    BOOL result = NO;
    NSArray *formatArray = @[formatString];
    result = [self saveTemplates:formatArray];
    [self loadFormatTemplates];
    return result;
}

-(void)loadFormatTemplates
{
    __block NSMutableDictionary *formats = [NSMutableDictionary dictionaryWithContentsOfFile:kFRFormatsFilename];
    if (formats.count == 0) {
        BOOL result = [self saveTemplates:self.predefinedFormats];
        if(result) {
            
            [self loadFormatTemplates];
            return;
        }
    }
    else {
        
        _formatTemplates = [NSArray arrayWithArray:formats.allValues];
        return;
    }
}

-(BOOL)saveTemplates:(NSArray *)templates
{
    BOOL result = NO;
    
    __block NSMutableDictionary *formats = [NSMutableDictionary dictionaryWithCapacity:1];
    [formats addEntriesFromDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:kFRFormatsFilename]];
    
    [templates enumerateObjectsUsingBlock:^(NSString *template, NSUInteger idx, BOOL *stop) {
        
        NSString *formatHash = [template sha1];
        if (![formats.allKeys containsObject:formatHash]) {
            
            [formats setObject:template forKey:formatHash];
        }
    }];
    result = [formats writeToFile:kFRFormatsFilename atomically:YES];
    
    return result;
}

-(NSArray *)predefinedFormats
{
    if (!_predefinedFormats) {
        _predefinedFormats = @[@"<artist> - <title>",
                               @"<track>. <title>"];
        
    }
    return _predefinedFormats;
}
@end
