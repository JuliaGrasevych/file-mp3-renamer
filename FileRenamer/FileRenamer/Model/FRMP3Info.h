//
//  FRMP3Info.h
//  FileRenamer
//
//  Created by Yuliya Grasevych on 27.02.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRMP3Info : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *album;
@property (nonatomic) NSString *track;
@property (nonatomic) NSString *year;

-(id)initWithURLPath:(NSURL *)fileURL;

@end
