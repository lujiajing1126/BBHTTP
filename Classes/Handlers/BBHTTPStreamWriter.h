//
// Copyright 2013 BiasedBit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

//
//  Created by Bruno de Carvalho (@biasedbit, http://biasedbit.com)
//  Copyright (c) 2013 BiasedBit. All rights reserved.
//

#import "BBHTTPSelectiveDiscarder.h"



#pragma mark -

/**
 Response parser that inherits selective behavior from `<BBHTTPSelectiveResponseParser>` and pumps all the data it
 receives through `<appendResponseBytes:withLength:>` to a `NSOutputStream`.
 
 If the output stream is not open when the request is accepted, it will be automatically opened.
 
 If an error occurs while transferring data to the output stream, the stream will be closed.
 When processing ends, the stream will be closed.
 
 If the stream does not have enough space available, the request will fail.
 */
@interface BBHTTPStreamWriter : BBHTTPSelectiveDiscarder


#pragma mark Creating a new stream writer

- (id)initWithOutputStream:(NSOutputStream*)stream;

@end