//
//  FBEncryptTests.m
//  FBEncryptTests
//
//  Created by Hiroshi Hashiguchi on 11/05/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBEncryptTests.h"
#import "FBEncryptorAES.h"
#import "NSData+Base64.h"

@implementation FBEncryptTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEncrypt
{
    STAssertEqualObjects([FBEncryptorAES encryptBase64String:@"Write text here and touch encrypt button and confirm the encrypted message."
                                                    keyString:@"sampleprivatekey"
                                                separateLines:NO],
                         @"kWxGYHe3mYeeWTdpnM7V4/TZ1Dmg+PLUkkOdCc8AQxAz+6oDf7kCBMWMwOUFMe7m7LxzSi9T43Pb1XaG7409vb0QaDO8eZMHmJgXx/oGbEA=",
                         nil);

    STAssertEqualObjects([FBEncryptorAES encryptBase64String:@"Write text here and touch encrypt button and confirm the encrypted message."
                                                    keyString:@"sampleprivatekey"
                                                separateLines:YES],
                         //123456789+123456789+123456789+123456789+123456789+123456789+1234|<=64
                         @"kWxGYHe3mYeeWTdpnM7V4/TZ1Dmg+PLUkkOdCc8AQxAz+6oDf7kCBMWMwOUFMe7m\r\n" \
                         @"7LxzSi9T43Pb1XaG7409vb0QaDO8eZMHmJgXx/oGbEA=",
                         nil);
}

- (void)testDecrypt
{
    STAssertEqualObjects([FBEncryptorAES decryptBase64String:@"kWxGYHe3mYeeWTdpnM7V4/TZ1Dmg+PLUkkOdCc8AQxAz+6oDf7kCBMWMwOUFMe7m7LxzSi9T43Pb1XaG7409vb0QaDO8eZMHmJgXx/oGbEA="
                                                    keyString:@"sampleprivatekey"],
                         @"Write text here and touch encrypt button and confirm the encrypted message.",
                         nil);
}

- (void)testGenerateIv
{
    NSData* iv = [FBEncryptorAES generateIv];
    STAssertEquals([iv length], (NSUInteger)FBENCRYPT_BLOCK_SIZE, nil);
}

- (void)testHexStringAndDataConvertor
{
    NSString* hexString = @"b20cd8d972e65762824cc3190040388c";
    const unsigned char raw[] = {
        0xb2, 0x0c, 0xd8, 0xd9,
        0x72, 0xe6, 0x57, 0x62,
        0x82, 0x4c, 0xc3, 0x19,
        0x00, 0x40, 0x38, 0x8c};
    NSData* data = [NSData dataWithBytes:raw length:FBENCRYPT_BLOCK_SIZE];
    NSString* convertedString = [FBEncryptorAES hexStringForData:data];
    NSData* convertedData = [FBEncryptorAES dataForHexString:hexString];

    STAssertEqualObjects(convertedString, hexString, nil);
    STAssertEqualObjects(convertedData, data, nil);
    STAssertEqualObjects([FBEncryptorAES hexStringForData:convertedData], hexString, nil);
}

- (void)testRawAPI
{
    NSData* data = [@"Write text here and touch encrypt button and confirm the encrypted message."
                    dataUsingEncoding:NSUTF8StringEncoding];
    NSData* key = [@"sampleprivatekey" dataUsingEncoding:NSUTF8StringEncoding];
    NSData* iv = [@"initialvector123" dataUsingEncoding:NSUTF8StringEncoding];

    NSData* encryptedData = [NSData dataFromBase64String:@"rlBB3bQZmLKlNxcS8kgYaJsaWw7nwfAI6ue8Q/WPaWc0zdTx7tm2y2AhRJlGwQcP+088Ar341WxLvGfZCQgM3BxwZSpH+xAevTQCwL8GQfw="];
    
    STAssertEqualObjects([FBEncryptorAES encryptData:data key:key iv:iv], encryptedData, nil);
    STAssertEqualObjects([FBEncryptorAES decryptData:encryptedData key:key iv:iv], data, nil);
}

@end
