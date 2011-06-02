CCCrypt wrapper class
=============================

FBEncryptor is enabled to encrypt/decrypt a message. Supported encryption algorithm is AES 256 bit only. Additionally BASE64 encode/decode is supported.


Usage
-----

(1) Encrypt/decrypt plain text message with Base64 encoding

Encrypt)

	NSString* encrypted = [FBEncryptorAES encryptBase64String:@"Hello"
											        keyString:@"somekey"
												separateLines:NO];

The output string is encoded with Base64.

	example)
	message: @"Hello"
	output : @"gT2IUF9Jzmn7wglXk3XC3w=="

if 'separateLines:' is NO, no CR/LF characters will be added.
Otherwise a CR/LF pair will be added every 64 encoded chars.


Decrypt)

	NSString* decrypted = [FBEncryptorAES decryptBase64String:encrypted
											        keyString:key];



(2) Encrypt/decrypt binary data

	NSData* encryptedData = [FBEncryptorAES encryptData:data
											    keyData:key
												     iv:iv];
	
	NSData* decryptedData = [FBEncryptorAES decryptData:encryptData
											    keyData:key
												     iv:iv];

The iv is called 'initailization vector' for CBC mode. it is abled to be set nil.


(3) Generate iv

	NSData* iv = [FBEncryptorAES generateIv];

It generates a 16 bytes random binary value. You can use this value for +encryptData:keyData:iv:.


(4) Utiities

	NSData* iv = [FBEncryptorAES generateIv];
	NSString* hexString = [FBEncryptorAES hexStringForData:iv];

	example: @"b20cd8d972e65762824cc3190040388c"

	NSData* bin = [FBEncryptorAES dataForHexString:hexString];



Features
--------
- Only support AES256/CBC/PKCS7padding
- Base64 encoding is suported


Customize
---------

It is able to change below constants:

	FBEncryptor.h
	#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES256

If you want to use AES 128 bit key, you can set the constant like below:

	#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES128

NOTE: If you change the constant, the testcase will be failed (it is made for AES 256 bit key).


Installation
-----------

You should copy below files to your projects.

	FBEncryptor.h
	FBEncryptor.m
	NSData+Base64.h
	NSData+Base64.m


Etc
-------
Special thanks for Matt Gallagher (author of NSData+Base64 code).

"Cocoa with Love: Base64 encoding options on the Mac and iPhone"
http://cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html


License
-------
(1) FBEncryptorAES.m/FBEncryptorAES.h

MIT

Copyright (c) 2011 Hiroshi Hashiguchi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.



(2) NSData+Base64.m/NSData+Base64.h

Created by Matt Gallagher on 2009/06/03.
Copyright 2009 Matt Gallagher. All rights reserved.

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software. Permission is granted to anyone to
use this software for any purpose, including commercial applications, and to
alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source
   distribution.


