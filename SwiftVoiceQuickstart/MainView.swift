//
//  MainView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 30/09/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import AVFoundation
import PushKit
import CallKit
import TwilioVoice
import SwiftUI

struct MainView: View
{
    @ObservedObject var screenView: ScreenModel = AppSession.activeScreen ?? ScreenModel()
    
    func ContainedView() -> AnyView
    {
        switch(screenView.activeScreen)
        {
        case .landing:
            return AnyView(LandingView())
                
        case .login:
            return AnyView(LoginView())
            
        case .register:
            return AnyView(RegisterView())
            
        case .call:
            return AnyView(CallView())
            
        case .feedback:
            return AnyView(CallView())
            
        case .reported:
            return AnyView(CallView())
            
        case .forgot:
            return AnyView(ForgotPasswordView())
            
        case .verification:
            return AnyView(VerifyView())
            
        case .newpass:
            return AnyView(NewPassView())
            
        case .verify:
            return AnyView(VerifyEmailView())
            
        case .update:
            return AnyView(UpdateDetailsView())
        }
    }
    
    var body: some View
    {
        if #available(iOS 14.0, *) {
            ContainedView().ignoresSafeArea(.keyboard, edges: .bottom)
        } else {
            // Fallback on earlier versions
            ContainedView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
        }
    }
}
