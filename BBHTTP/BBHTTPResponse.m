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
//  Created by Bruno de Carvalho - @biasedbit / http://biasedbit.com
//  Copyright (c) 2013 BiasedBit. All rights reserved.
//

#import "BBHTTPResponse.h"



#pragma mark - Utility functions

NSString* NSStringFromBBHTTPProtocolVersion(BBHTTPProtocolVersion version)
{
    switch (version) {
        case BBHTTPProtocolVersion_1_0:
            return @"HTTP/1.0";

        default:
            return @"HTTP/1.1";
    }
}

BBHTTPProtocolVersion BBHTTPProtocolVersionFromNSString(NSString* string)
{
    if ([string isEqualToString:@"HTTP/1.0"]) {
        return BBHTTPProtocolVersion_1_0;
    } else {
        return BBHTTPProtocolVersion_1_1;
    }
}



#pragma mark -

@implementation BBHTTPResponse
{
    NSMutableDictionary* _headers;
    BOOL _successful;
}


#pragma mark Creation

- (instancetype)initWithVersion:(BBHTTPProtocolVersion)version
                           code:(NSUInteger)code
                     andMessage:(NSString*)message
{
    self = [super init];
    if (self != nil) {
        _version = version;
        _code = code;
        _message = message;
        _headers = [NSMutableDictionary dictionary];
    }

    return self;
}


#pragma mark Public static methods

+ (BBHTTPResponse*)responseWithStatusLine:(NSString*)statusLine
{
    // TODO check size
    NSString* versionString = [statusLine substringToIndex:8];
    NSRange statusCodeRange = NSMakeRange(9, 3);
    NSString* statusCodeString = [statusLine substringWithRange:statusCodeRange];

    BBHTTPProtocolVersion version = BBHTTPProtocolVersionFromNSString(versionString);
    NSUInteger statusCode = (NSUInteger)[statusCodeString integerValue];

    NSUInteger index = NSMaxRange(statusCodeRange) + 1;
    if (index > statusLine.length - 1)
    {
        index = statusLine.length - 1;
    }
    
    NSString* message = [statusLine substringFromIndex:index];

    BBHTTPResponse* response = [[self alloc] initWithVersion:version code:statusCode andMessage:message];

    return response;
}


#pragma mark Interface

- (void)finishWithContent:(id)content size:(NSUInteger)size successful:(BOOL)successful
{
    _content = content;
    _contentSize = size;
    _successful = successful;
}

- (NSString*)headerWithName:(NSString*)header
{
    return _headers[header];
}

- (NSString*)objectForKeyedSubscript:(NSString*)header
{
    return _headers[header];
}

- (void)setValue:(NSString*)value forHeader:(NSString*)header
{
    _headers[header] = value;
}

- (void)setObject:(NSString*)value forKeyedSubscript:(NSString*)header
{
    [self setValue:value forHeader:header];
}

- (BOOL)isSuccessful
{
    return _successful;
}

#pragma mark Debug

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@{%lu, %@, %lu bytes of data}",
            NSStringFromClass([self class]), (unsigned long)_code, _message, (unsigned long)[self contentSize]];
}


@end
