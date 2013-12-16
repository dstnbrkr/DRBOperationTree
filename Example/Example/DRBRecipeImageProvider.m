//
//  DRBRecipeImageProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 Dustin Barker (http://github.com/dstnbrkr), Artsy (http://artsy.net). All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "DRBRecipeImageProvider.h"
#import "DRBRecipe.h"
#import "AFImageRequestOperation.h"

@implementation DRBRecipeImageProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(DRBRecipe *)recipe completion:(void (^)(NSArray *))completion
{
    NSURL *URL = [NSURL URLWithString:recipe.imagePath];
    completion(@[ @[ URL, recipe.imageFilePath ] ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSArray *)params
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSURL *URL = params[0];
    NSString *filePath = params[1];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    return [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                imageProcessingBlock:nil
                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                 [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                                                                 continuation(image, nil);
                                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                 failure();
                                                             }];
}

@end
