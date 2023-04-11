//
//  FeedbackView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 10/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct FeedbackView: View
{
    @State private var positivityRating: Double = 3
    @State private var energyRating: Double = 3
    @State private var lonelinessRating: Double = 3
    @State private var callQuality: Double = 3
    
    @ObservedObject private var cvm: CallViewModel = AppSession.inCall ?? CallViewModel(inCall: false, listeners: AppSession.getListenerCount())
    
    func submitScore()
    {
        AppSession.rateCall(rating: Int(callQuality))
        AppSession.activeScreen?.activeScreen = ActiveScreen.call
    }
    
    func sendFeedback()
    {
        AppSession.sendFeedback(positivity: Int(positivityRating), energy: Int(energyRating), loneliness: Int(lonelinessRating), callRating: Int(callQuality))
        AppSession.activeScreen?.activeScreen = ActiveScreen.call
    }
    
    func closeNoFeedback()
    {
        AppSession.activeScreen?.activeScreen = ActiveScreen.call
        AppSession.inCall?.wasCaller = false
    }
    
    func reportAbuse()
    {
        AppSession.reportCall(status:2)
        AppSession.activeScreen?.activeScreen = ActiveScreen.reported
        //closeNoFeedback()
    }
    
    func flagHelp()
    {
        AppSession.reportCall(status: 1)
        AppSession.activeScreen?.activeScreen = ActiveScreen.reported
        //closeNoFeedback()
    }
    
    func onLoad()
    {
        
        if (cvm.wasCaller != AppSession.inCall?.wasCaller && AppSession.inCall?.wasCaller != nil)
        {
            cvm.wasCaller = AppSession.inCall!.wasCaller
        }
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
                    
                    Text("How are you feeling?")
                    .foregroundColor(ColorManager.Black)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    
                    // POSITIVITY
                    Spacer().frame(height: 20)
                    VStack()
                    {
                        HStack()
                        {
                            Text("Positivity")
                            .foregroundColor(ColorManager.Black)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        }.frame(width: UIScreen.screenW70)
                        .offset(y: 10)
                        
                        Slider(value: $positivityRating, in: 1...5, step: 1).frame(width: UIScreen.screenW60, height: 20)
                        
                        HStack()
                        {
                            Text("1")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("2")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("3")
                                .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("4")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("5")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                        }.frame(width: UIScreen.screenW60)
                    }
                    
                    // ENERGY
                    Spacer().frame(height: 20)
                    VStack()
                    {
                        HStack()
                        {
                            Text("Energy")
                            .foregroundColor(ColorManager.Black)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        }.frame(width: UIScreen.screenW70)
                        .offset(y: 10)
                        
                        Slider(value: $energyRating, in: 1...5, step: 1).frame(width: UIScreen.screenW60, height: 20)
                        
                        HStack()
                        {
                            Text("1")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("2")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("3")
                                .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("4")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("5")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                        }.frame(width: UIScreen.screenW60)
                    }
                    
                    // LONELINESS
                    Spacer().frame(height: 20)
                    VStack()
                    {
                        HStack()
                        {
                            Text("Loneliness")
                            .foregroundColor(ColorManager.Black)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        }.frame(width: UIScreen.screenW70)
                        .offset(y: 10)
                        
                        Slider(value: $lonelinessRating, in: 1...5, step: 1).frame(width: UIScreen.screenW60, height: 20)
                        
                        HStack()
                        {
                            Text("1")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("2")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("3")
                                .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("4")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("5")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                        }.frame(width: UIScreen.screenW60)
                    }
                    
                    // CALL QUALITY
                    Spacer().frame(height: 20)
                    VStack()
                    {
                        HStack()
                        {
                            Text("Call Quality")
                            .foregroundColor(ColorManager.Black)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        }.frame(width: UIScreen.screenW70)
                        .offset(y: 10)
                        
                        Slider(value: $callQuality, in: 1...5, step: 1).frame(width: UIScreen.screenW60, height: 20)
                        
                        HStack()
                        {
                            Text("1")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("2")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("3")
                                .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("4")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            Spacer()
                            
                            Text("5")
                            .foregroundColor(ColorManager.Grey)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                        }.frame(width: UIScreen.screenW60)
                    
                        Button(action: {submitScore()} , label: {
                            Text("Submit")
                                .foregroundColor(ColorManager.White)
                                .font(.system(size: 20))
                        }).frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(ColorManager.DarkOrange)
                        .cornerRadius(20)
                        .padding(.bottom, 10)
                        
                        Spacer().frame(height: 10)
                        
                        Button(action: {reportAbuse()} , label: {
                            Text("Report the call")
                                .foregroundColor(ColorManager.White)
                                .font(.system(size: 20))
                        }).frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(ColorManager.Black)
                        .cornerRadius(20)
                        
                        Spacer().frame(height: 20)
                        
                    }.padding(.horizontal, 10)
                }.background(ColorManager.White).cornerRadius(25)
            }
        }.navigationBarTitle("Babble")
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true).frame(height: UIScreen.screenHeight).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).onAppear(perform: {onLoad()})
    }
}
