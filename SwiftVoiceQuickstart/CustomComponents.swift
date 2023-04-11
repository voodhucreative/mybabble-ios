//
//  CustomComponents.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 09/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI
import Introspect

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
//    var editingChanged: (Bool)->() = { _ in }
//    var commit: ()->() = { }
    
    //Just incase this is used in other situations I've added 2 trimming methods to this via this bool
    var emailField: Bool

    var body: some View {
        
        //This prevents users entering spaces at all
        let binding = Binding(get: { text }, set: { text = $0; commit() })
        
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder.frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) }
            
            if(!emailField) { TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit) }
            else{ TextField("", text: binding, onEditingChanged: editingChanged, onCommit: commit) }
        }
    }
    //This only fires if a user taps on anouther text field
    func editingChanged(_: Bool) -> (){
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func commit(){
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct CustomSecureField: View {
    var placeholder: Text
    @Binding var text: String
//    var editingChanged: (Bool)->() = { _ in }
//    var commit: ()->() = { }

    var body: some View {
        
        //This prevents users entering spaces at all - Cant use onEditingChanged on secure text fields
        let binding = Binding(get: { text }, set: { text = $0; commit() })
        
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder.frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) }
            SecureField("", text: binding, onCommit: commit)
        }
    }
    
    func commit(){
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIScreen
{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenW80 = screenWidth * 0.8
    static let screenW70 = screenWidth * 0.7
    static let screenW60 = screenWidth * 0.6
    static let screenWHalf = screenWidth / 2
    static let screenWQuart = screenWHalf / 2
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenHHalf = screenHeight / 2
    static let screenHQuart = screenHHalf / 2
    static let screenH40 = screenHeight * 0.4
    static let screenH35 = screenHeight * 0.35
    static let screenSize = UIScreen.main.bounds.size
}

enum ActiveScreen
{
    case landing, login, register, call, feedback, reported, forgot, verification, newpass, verify, update
}


