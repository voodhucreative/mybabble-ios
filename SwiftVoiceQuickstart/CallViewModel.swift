//
//  CallViewModel.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 09/11/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation

class CallViewModel: ObservableObject
{
    @Published var inCall: Bool = false
    @Published var wasCaller: Bool = false
    @Published var inPool: Bool = false
    @Published var timer: Int = 1020 //1020 for 17 mins
    @Published var acctiveListeners = 0
    @Published var timerActive: Bool = false
    @Published var showAlert: Bool = false
    
    
    init(inCall: Bool, listeners: Int)
    {
        self.inCall = inCall
        self.acctiveListeners = listeners
    }
}
