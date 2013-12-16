//
//  DRBRecipeImageProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBRecipeImageProvider.h"
#import "DRBRecipe.h"
#import "AFImageRequestOperation.h"

@implementation DRBRecipeImageProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(DRBRecipe *)recipe completion:(void (^)(NSArray *))completion
{
    NSURL *URL = [NSURL URLWithString:recipe.imagePath];
    completion(@[ @[ URL, recipe ] ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSArray *)image
                       success:(void (^)(id))success
                       failure:(void (^)())failure
{
    NSURL *URL = image[0];
    DRBRecipe *recipe = image[1];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    return [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                imageProcessingBlock:nil
                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                 recipe.image = image;
                                                                 success(image);
                                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                 failure();
                                                             }];
}

@end
