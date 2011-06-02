//
// Copyright (c) 2011 Five-technology Co.,Ltd.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "FBEncryptorAES.h"
#import "NSData+Base64.h"

@implementation FBEncryptorAES

#pragma mark -
#pragma mark Initialization and deallcation


#pragma mark -
#pragma mark Praivate


#pragma mark -
#pragma mark API

+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
{
    NSData* result = nil;

    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
	bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
	
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
	size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
	void *buffer = malloc(bufferSize);

    // do encrypt
	size_t encryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
										  &encryptedSize);
	if (cryptStatus == kCCSuccess) {
		result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
	} else {
        free(buffer);
        NSLog(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
	
	return result;
}

+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
{
    NSData* result = nil;

    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
	bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];

    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
	size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
	void *buffer = malloc(bufferSize);
	
    // do decrypt
	size_t decryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
										  cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
	
	if (cryptStatus == kCCSuccess) {
		result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
	} else {
        free(buffer);
        NSLog(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
    }

	return result;
}


+ (NSString*)encryptBase64String:(NSString*)string keyString:(NSString*)keyString separateLines:(BOOL)separateLines
{
    NSData* data = [self encryptData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                 key:[keyString dataUsingEncoding:NSUTF8StringEncoding]
                                  iv:nil];
    return [data base64EncodedStringWithSeparateLines:separateLines];
}

+ (NSString*)decryptBase64String:(NSString*)encryptedBase64String keyString:(NSString*)keyString
{
    NSData* encryptedData = [NSData dataFromBase64String:encryptedBase64String];
    NSData* data = [self decryptData:encryptedData
                                 key:[keyString dataUsingEncoding:NSUTF8StringEncoding]
                                  iv:nil];
    if (data) {
        return [[[NSString alloc] initWithData:data
                                      encoding:NSUTF8StringEncoding] autorelease];
    } else {
        return nil;
    }
}


#define FBENCRYPT_IV_HEX_LEGNTH (FBENCRYPT_BLOCK_SIZE*2)

+ (NSData*)generateIv
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand(time(NULL));
    });

    char cIv[FBENCRYPT_BLOCK_SIZE];
    for (int i=0; i < FBENCRYPT_BLOCK_SIZE; i++) {
        cIv[i] = rand() % 256;
    }
    return [NSData dataWithBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
}


+ (NSString*)hexStringForData:(NSData*)data
{
    if (data == nil) {
        return nil;
    }

    NSMutableString* hexString = [NSMutableString string];

    const unsigned char *p = [data bytes];
    
    for (int i=0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", *p++];
    }
    return hexString;
}

+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        } else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}

@end
