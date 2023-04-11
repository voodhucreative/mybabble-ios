//
//  CustomToggle.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 19/02/2021.
//  Copyright © 2021 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack()
            {
                Rectangle()
                    //.padding(.vertical, 8)
                    .foregroundColor(.white)
                    .frame(width: 41, height: 17, alignment: .center)
                    .cornerRadius(50)
                
                Rectangle()
                    //.padding(.vertical, 8)
                    .foregroundColor(.clear)
                    .frame(width: 51, height: 31, alignment: .center)
                    .overlay(
                        Circle()
                            .foregroundColor(configuration.isOn ? .orange : .orange )
                            .padding(.all, 0)
                            .offset(x: configuration.isOn ? 11 : -11)
                            .animation(Animation.linear(duration: 0.1))
                            
                    )
                    .onTapGesture { configuration.isOn.toggle() }
            }
            
        }
    }
    
}
