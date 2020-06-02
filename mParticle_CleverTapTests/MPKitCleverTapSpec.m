
@import Quick;
@import Nimble;
@import OCMock;
@import CleverTapSDK;
@import mParticle_Apple_SDK;
#import "MPKitCleverTap.h"


QuickSpecBegin(MPKitCleverTapSpec)

describe(@"a mParticle CleverTap integration", ^{
    
    context(@"conforming to MPKitProtocol", ^{
       
        it(@"is started on launching with Configuration", ^{
            MPKitCleverTap *clevertapKit = [MPKitCleverTap new];
            [clevertapKit didFinishLaunchingWithConfiguration:@{ @"AccountID":@"12345", @"AccountToken":@"54321" }];
            expect(clevertapKit.started).to(beTrue());
        });
        
        it(@"is not started with empty Configuration", ^{
            MPKitCleverTap *clevertapKit = [MPKitCleverTap new];
            [clevertapKit didFinishLaunchingWithConfiguration:@{}];
            expect(clevertapKit.started).toNot(beTrue());
        });
        
    });
});

QuickSpecEnd
