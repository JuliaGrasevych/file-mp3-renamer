//
//  FRTextView.m
//  FileRenamer
//
//  Created by Yuliya Grasevych on 05.03.14.
//  Copyright (c) 2014 Yuliya Grasevych. All rights reserved.
//

#import "FRTextView.h"
#import "FRFileObject.h"

@implementation FRTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(NSRange)rangeForUserCompletion
{
    NSRange completionRange = [super rangeForUserCompletion];
    NSString *textString = self.string;
    NSInteger rangeShift = 0;
    if (completionRange.location > 0)
    {
        NSRange probRange = NSMakeRange(completionRange.location-1, 1);
        NSString *tagBracket = [textString substringWithRange:probRange];
        if ([tagBracket isEqualToString:kFRTagPrefix]) {
            
            rangeShift = 1;
        }
    }
    
    completionRange.location -= rangeShift;
    completionRange.length += rangeShift;
    
    return completionRange;
}

@end
