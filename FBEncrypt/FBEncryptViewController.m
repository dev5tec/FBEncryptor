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

#import "FBEncryptViewController.h"
#import "FBEncryptorAES.h"

@implementation FBEncryptViewController

@synthesize message;
@synthesize encrypted;
@synthesize decrypted;
@synthesize key;
@synthesize scrollView;
@synthesize separateline;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(320, 320+640);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)encrypt:(id)sender
{
    self.encrypted.text = [FBEncryptorAES encryptBase64String:self.message.text
                                                     keyString:self.key.text
                                                 separateLines:[self.separateline isOn]];
    NSLog(@"encrypted: %@", self.encrypted.text);
}

- (IBAction)decrypt:(id)sender
{
    NSString* msg = [FBEncryptorAES decryptBase64String:self.encrypted.text
                                               keyString:self.key.text];
    
    if (msg) {
        self.decrypted.text = msg;
        NSLog(@"decrypted: %@", msg);
    } else {
        self.decrypted.text = @"(failed to decrypt)";
    }
    
}


/*
- (IBAction)exg:(id)sender
{
    if (self.ivString == nil || [self.ivString.text length] == 0) {
        return;
    }
    const char* ivPtr = [self.ivString.text cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableString* str = [NSMutableString string];
    int len = 0;
    while (*ivPtr) {
        [str appendFormat:@"%02X", *ivPtr];
        len++;
        ivPtr++;
    }
    while (len < 16) {
        [str appendString:@"00"]; 
        len++;
    }
    self.iv.text = str;
    NSLog(@"iv: %@", str);
}
*/

@end
