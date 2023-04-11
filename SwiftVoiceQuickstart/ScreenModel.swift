//
//  ScreenModel.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 16/11/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation

class ScreenModel: ObservableObject
{
    @Published var activeScreen: ActiveScreen = ActiveScreen.landing
    
    init()
    {
        
    }
}
