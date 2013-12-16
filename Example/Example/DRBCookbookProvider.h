//
//  DRBCookbookProvider.h
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBOperationTree.h"
#import <Foundation/Foundation.h>

@interface DRBCookbookProvider : NSObject<DRBOperationProvider>

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
