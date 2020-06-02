
@import Quick;
@import Nimble;
@import OCMock;
@import CleverTapSDK;
@import mParticle_Apple_SDK;
#import "MPKitCleverTap.h"


QuickSpecBegin(MPKitCleverTapSpec)

describe(@"a mParticle CleverTap integration", ^{
    
    context(@"conforming to MPKitProtocol", ^{
        
        __block MPKitCleverTap *clevertapKit;
        beforeEach(^{
            clevertapKit = [MPKitCleverTap new];
        });
        
        afterEach(^{
            clevertapKit = nil;
        });
        
        it(@"is not started with empty Configuration", ^{
            [clevertapKit didFinishLaunchingWithConfiguration:@{}];
            expect(clevertapKit.started).toNot(beTrue());
        });
        
        it(@"verifies properties are set correctly", ^{
            
            NSDictionary *config = @{ @"AccountID": @"12345", @"AccountToken": @"54321" };
            
            [clevertapKit didFinishLaunchingWithConfiguration:config];
            
            expect(clevertapKit.started).to(beTrue());
            expect(clevertapKit.launchOptions).to(beNil());
            expect(clevertapKit.configuration).to(equal(config));
            expect(clevertapKit.providerKitInstance).to(beAKindOf([CleverTap class]));
        });
        
        it(@"handles push notifications clicks", ^{
            
            id mockCleverTap = OCMStrictClassMock([CleverTap class]);
            
            id mockNotificationCenter = OCMClassMock([UNUserNotificationCenter class]);
            id mockNotificationResponse = OCMClassMock([UNNotificationResponse class]);

            [[mockCleverTap expect] handlePushNotification:[OCMArg any] openDeepLinksInForeground:[OCMArg any]];
            
            [clevertapKit userNotificationCenter:mockNotificationCenter didReceiveNotificationResponse:mockNotificationResponse];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"handles push notification actions", ^{
            
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap handleNotificationWithData:[OCMArg any]]);
            
            [clevertapKit handleActionWithIdentifier:[OCMArg any] forRemoteNotification:[OCMArg any]];
            
            OCMVerifyAll(mockCleverTap);
        });
    });
});

QuickSpecEnd
