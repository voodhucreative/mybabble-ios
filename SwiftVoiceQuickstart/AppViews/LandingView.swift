//
//  LandingView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 10/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct LandingView: View
{
    @State private var showDisclaimer = false
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                ColorManager.Slate.edgesIgnoringSafeArea(.all)
                
                VStack()
                {
                    Image("home-header").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .top)
                        .offset(y: -20)
                    
                    Spacer()
                }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                
                VStack()
                {
                    Spacer()
                    
                    Image("home-footer").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .bottom)
                        .offset(y: -10)
                }
                
                
                VStack()
                    {
                        
                    Text("Welcome to")
                        .foregroundColor(ColorManager.White)
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        //.font(Font.custom("cera_pro_r", size: 20))
                        .font(Font.custom("cera_pro_r", size: 20))
                        
                        Image("mybabblelogo4")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(32)
                    
                    Spacer().frame(height: 20)
                    
                    Button(action: {AppSession.nextScreen = ActiveScreen.login; termsInterception()}, label:
                     {
                        Text("Login")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .foregroundColor(ColorManager.White)
                            //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 20))
                            .font(Font.custom("cera_pro_r", size: 20))
                     })
                    .frame(width: UIScreen.screenWHalf, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(ColorManager.DarkOrange)
                    .cornerRadius(50)
                        
                    Button(action: {AppSession.nextScreen = ActiveScreen.register; termsInterception()}, label:
                     {
                        Text( "New User?")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 20)
                            .foregroundColor(ColorManager.White)
                            //.font(.custom(UIFont.FontString(UIFont.CeraProType.Light), size: 20))
                            .font(Font.custom("cera_pro_r", size: 20))
                     })
                }
                .offset(x:0, y: -40)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .frame(height: UIScreen.screenHeight).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).sheet(isPresented: $showDisclaimer, onDismiss: {
            print(self.showDisclaimer)
        })
        {
            ModalView(message: "By using this app you agree to our Terms of Service")
        }
    }
    
    func termsInterception()
    {
        if(AppSettings.showTerms)
        {
            self.showDisclaimer = true
        }
        else
        {
            
            AppSession.activeScreen?.activeScreen = AppSession.nextScreen
        }
    }
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentation
    let message: String

    var body: some View {
        Color.clear.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        VStack {
            
            Spacer()
            Text(message)
            Spacer()
            Button("View Terms of Service")
            {
                if let url = URL(string: "https://www.mybabble.chat/terms-and-conditions") {
                    UIApplication.shared.open(url)
                }
            }.padding(.horizontal, 50)
            .padding(.vertical, 20)
            .font(.system(size: 22))
            Spacer()
            Button("I Agree")
            {
                self.presentation.wrappedValue.dismiss()
                AppSession.activeScreen?.activeScreen = AppSession.nextScreen
            }.padding(.horizontal, 50)
            .padding(.vertical, 20)
            .font(.system(size: 22))
            Button("Dismiss")
            {
                self.presentation.wrappedValue.dismiss()
            }.padding(.horizontal, 50)
            .padding(.vertical, 20)
            .font(.system(size: 22))
        }.frame(height: UIScreen.screenHHalf)
    }
    
}
