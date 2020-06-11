
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
        
        it(@"handles push notification actions with response info", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap handleNotificationWithData:[OCMArg any]]);
            
            [clevertapKit handleActionWithIdentifier:[OCMArg any] forRemoteNotification:[OCMArg any] withResponseInfo:[OCMArg any]];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies user notifications are received", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap handleNotificationWithData:[OCMArg any]]);
            
            [clevertapKit receivedUserNotification:[OCMArg any]];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies push token is set", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap setPushToken:[OCMArg any]]);
            
            [clevertapKit setDeviceToken:[OCMArg any]];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies open URL with options is handled", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap handleOpenURL:[OCMArg any] sourceApplication:[OCMArg any]]);
            
            [clevertapKit openURL:[OCMArg any] options:[OCMArg any]];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies open URL from source application is handled", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap handleOpenURL:[OCMArg any] sourceApplication:[OCMArg any]]);
            
            [clevertapKit openURL:[OCMArg any] sourceApplication:[OCMArg any] annotation:[OCMArg any]];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies location is set", ^{
            
            CLLocation *mockLocation = OCMClassMock([CLLocation class]);
            MPKitExecStatus *status = [clevertapKit setLocation:mockLocation];

            expect(@(status.returnCode)).to(equal(MPKitReturnCodeSuccess));
        });
        
        it(@"verifies user attributes are set via profile push", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap profilePush:@{ @"key": @"value" }]);
            
            [clevertapKit setUserAttribute:@"key" value:@"value"];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies user attributes are removed", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap profileRemoveValueForKey:[OCMArg any]]);
            
            [clevertapKit removeUserAttribute:[OCMArg any]];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies multiple user attributes are set", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap profileAddMultiValues:[OCMArg any] forKey:[OCMArg any]]);
            
            [clevertapKit setUserAttribute:[OCMArg any] values:[OCMArg any]];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies on user login is NOT invoked for incorrect payload onLoginComplete invocation", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMReject([mockCleverTap onUserLogin:[OCMArg any]]);
            OCMReject([mockCleverTap profilePush:[OCMArg any]]);
            
            id mockUser = OCMClassMock([FilteredMParticleUser class]);
            id mockRequest = OCMClassMock([FilteredMPIdentityApiRequest class]);
            [clevertapKit onLoginComplete:mockUser request:mockRequest];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies on user login is NOT invoked for incorrect payload onIdentifyComplete invocation" , ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMReject([mockCleverTap onUserLogin:[OCMArg any]]);
            OCMReject([mockCleverTap profilePush:[OCMArg any]]);
            
            id mockUser = OCMClassMock([FilteredMParticleUser class]);
            id mockRequest = OCMClassMock([FilteredMPIdentityApiRequest class]);
            [clevertapKit onIdentifyComplete:mockUser request:mockRequest];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies on user login is NOT invoked for incorrect payload onIdentifyComplete invocation" , ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMReject([mockCleverTap onUserLogin:[OCMArg any]]);
            OCMReject([mockCleverTap profilePush:[OCMArg any]]);
            
            id mockUser = OCMClassMock([FilteredMParticleUser class]);
            id mockRequest = OCMClassMock([FilteredMPIdentityApiRequest class]);
            [clevertapKit onModifyComplete:mockUser request:mockRequest];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"rejects events with incorrect values", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMReject([mockCleverTap recordEvent:[OCMArg any] withProps:[OCMArg any]]);
            OCMReject([mockCleverTap recordChargedEventWithDetails:[OCMArg any] andItems:[OCMArg any]]);
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated"
            
            id mockEvent = OCMClassMock([MPCommerceEvent class]);
            [clevertapKit logCommerceEvent:mockEvent];
            
            #pragma clang diagnostic pop
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies charged event is fired on Purchase Action Events", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap recordChargedEventWithDetails:[OCMArg any] andItems:[OCMArg any]]);
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated"
            
            MPCommerceEvent *niceEvent = [[MPCommerceEvent alloc] initWithAction:MPCommerceEventActionPurchase];
            [clevertapKit logCommerceEvent:niceEvent];
            
            #pragma clang diagnostic pop
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies events are logged", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap recordEvent:[OCMArg any] withProps:[OCMArg any]]);
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated"
            
            id mockEvent = OCMClassMock([MPEvent class]);
            [clevertapKit logEvent:mockEvent];
            
            #pragma clang diagnostic pop
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"rejects recordScreenView for incorrect payload", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMReject([mockCleverTap recordScreenView:[OCMArg any]]);
            
            id mockEvent = OCMClassMock([MPEvent class]);
            [clevertapKit logScreen:mockEvent];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies recordScreenView is invoked on logScreen invocation", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap recordScreenView:[OCMArg any]]);
            
            MPEvent *niceEvent = [[MPEvent alloc] initWithName:@"ScreenName" type:MPEventTypeUserContent];
            [clevertapKit logScreen:niceEvent];
            
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"verifies user opt out is set", ^{
            [CleverTap setCredentialsWithAccountID:@"12345" andToken:@"54321"];
            
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([(CleverTap *)mockCleverTap setOptOut:YES]);
            
            [clevertapKit setOptOut:YES];
            
            OCMVerifyAll(mockCleverTap);
        });
    });
});

QuickSpecEnd

