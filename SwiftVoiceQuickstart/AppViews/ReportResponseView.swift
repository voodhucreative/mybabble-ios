//
//  FeedbackView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 10/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct ReportResponseView: View
{
    func closeNoFeedback()
    {
        AppSession.activeScreen?.activeScreen = ActiveScreen.call
        AppSession.inCall?.wasCaller = false
    }
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                ColorManager.Slate.edgesIgnoringSafeArea(.all)
                    
                VStack()
                {
                    Color.white.frame(width: UIScreen.screenWidth, height: UIDevice.current.hasNotch ? 50 : 0).offset(y: -35)
                    Image("babble-logo-speech").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .top)
                        .offset(y: -55 )
                    Caller()
                    Spacer()
                }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                
                ColorManager.SlateTranslucent.edgesIgnoringSafeArea(.all)
                
                VStack()
                    {
                    
                    Spacer().frame(height: 20)
                    //if(cvm.wasCaller)
                    //{
                        Text("Thank you for reporting this call. We will review and take the appropriate action")
                        .foregroundColor(ColorManager.Black)
                        .font(.system(size: 24))
                            .fontWeight(.regular).multilineTextAlignment(.center)
                            .padding(.all, 20)
                    
//                    VStack()
//                    {
                        
                        Button(action: {closeNoFeedback()} , label: {
                            Text("Close")
                                .foregroundColor(ColorManager.Grey)
                                .font(.system(size: 24))
                        }).frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(50)
                        .padding(.bottom, 20)
//                    }//.frame(width: UIScreen.screenW80)
                }.background(ColorManager.White).cornerRadius(25).frame(width: UIScreen.screenW80)
            }
        }.navigationBarTitle("Babble")
        .navigationBarHidden(true).frame(height: UIScreen.screenHeight).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).navigationViewStyle(StackNavigationViewStyle())
    }
}
