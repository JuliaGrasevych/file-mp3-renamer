//
//  FRFormatManager.h
//  FileRenamer
//
//  Created by Yuliya Grasevych on 07.03.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRFormatManager : NSObject

@property (nonatomic, readonly) NSArray *formatTemplates;

-(BOOL)saveFormatTemplate:(NSString *)formatString;


@end
