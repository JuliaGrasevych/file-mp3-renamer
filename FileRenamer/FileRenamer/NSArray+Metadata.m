//
//  NSArray+Metadata.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 27.02.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "NSArray+Metadata.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSArray (Metadata)

-(NSString *)metadataValueForKey:(NSString *)key
{
    __block NSString *metadataValue = nil;
    AVMutableMetadataItem *metadataItem = [[AVMutableMetadataItem metadataItemsFromArray:self withKey:key keySpace:nil] firstObject];
    metadataValue = (NSString *)metadataItem.value;
    return metadataValue;
}
@end
