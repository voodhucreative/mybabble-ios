//
//  CallView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 10/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation
import MessageUI

struct CallView: View
{
    @State private var acceptingCalls = true
    @State private var infoTextIntent: String = "listening"
    @State private var showAlert: Bool = false
    @State private var showingReportAlert = false
    @State private var showingLogoutAlert = false
    @State private var showingCallingAlert = false
    @State private var showingInPoolAlert = false
    @State private var showingMicrophoneRequest = false
    @State private var showingPropmtView = false
    
    @State private var isMuted: Bool = false
    @State private var isLoudspeaker: Bool = false;
    
    @State var showingMailView = false
    @State var alertNoMail = false
    @State var result: Result<MFMailComposeResult, Error>? = nil

    
    //@State private var activeCallers = 1294
    let timer = Timer.publish(every: 1, on: .main, in: RunLoopMode.commonModes).autoconnect()
    
    let timer2 = Timer.publish(every: 5, on: .main, in: RunLoopMode.commonModes).autoconnect()
    
    @ObservedObject var cvm = AppSession.inCall ?? CallViewModel(inCall: false, listeners: AppSession.getListenerCount())
    let dialler: Dialler = AppSession.dialler!
    
    var body: some View
    {
        NavigationView
        {
            if(cvm.inCall)
            {
                ZStack()
                {
                    ColorManager.Green.edgesIgnoringSafeArea(.all)
                    if(UIDevice.current.userInterfaceIdiom == .pad){
                    VStack()
                    {
                        
                        Color.white.frame(width: UIScreen.screenWidth, height: UIDevice.current.hasNotch ? 50 : 0).offset(y: -35)
                        Image("babble-logo-speech").resizable()/*.aspectRatio(contentMode: .fit)*/
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.3, alignment: .top)
                            .offset(y: -115 )
                        Caller()
                        Spacer()
                    }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    }
                    else{
                    VStack()
                    {
                        Color.white.frame(width: UIScreen.screenWidth, height: UIDevice.current.hasNotch ? 50 : 0).offset(y: -35)
                        Image("babble-logo-speech").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight,alignment: .top)
                            .offset(y: -55 )
                        Caller()
                        Spacer()
                    }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    }
                    
                    VStack()
                        {
                        
                        Text("Time remaining:" + secondsToTime(seconds: cvm.timer))
                        .foregroundColor(ColorManager.White)
                        //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 20))
                        .font(Font.custom("cera_pro_r", size: 20))
                            
                        Spacer().frame(height: 20)
                        
                        Image("babble-circle-shadow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.screenWHalf)
                            .offset(x: 20)
                        
                        HStack()
                        {
                            Button(action: {
                                    isMuted = !isMuted
                                    
                                    dialler.muteSwitchToggled(isMuted: isMuted)} , label: {
                                Image("mute")
                            }).frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .cornerRadius(50)
                            .offset(y: 5)
                                .opacity(isMuted ? 1 : 0.5)
                            
                            Spacer().frame(width: 50)
                            
                            Button(action: {hangup()} , label: {
                                Image("hang-up")
                            }).frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .cornerRadius(50)
                            .offset(y: 5)
                            
                            Spacer().frame(width: 50)
                            
                            Button(action: {
                                    AppSession.isSpeaker = !AppSession.isSpeaker
                                    dialler.toggleAudioRoute(toSpeaker: AppSession.isSpeaker)} , label: {
                                Image("loud-speaker")
                            }).frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .cornerRadius(50)
                            .offset(y: 5)
                                .opacity(AppSession.isSpeaker ? 1 : 0.5)
                        }
                        
                        Spacer().frame(height: 20)
                            
                            Button(action: {showingReportAlert = true} , label: {
                                Text("Report as abusive")
                                    .foregroundColor(ColorManager.White)
                                //.font(.custom(UIFont.FontString(UIFont.CeraProType.Medium), size: 20))
                                    .font(Font.custom("cera_pro_r", size: 20))
                            }).frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(ColorManager.Black)
                        .cornerRadius(50)
                        .offset(y: 5)
                    }.offset(y: -25)
                    
                }.alert(isPresented:$showingReportAlert) {
                    
                    Alert(
                        title: Text("Report call"),
                        message: Text("Are you sure you want to end the call and report this user?"),
                        primaryButton: .default(Text("Yes"), action: {panic()}),
                        secondaryButton: .default(Text("No"), action: { enterCallPool(); })
                    )
                }.onReceive(timer) { time in
                    if(cvm.timerActive)
                    {
                        if cvm.timer > 0 {
                            cvm.timer -= 1
                            
                            if(cvm.timer <= 60)
                            {
                                if(AppSession.playedBeeps)
                                {
                                    print("beeps already played")
                                }
                                else
                                {
                                    print("calling beep sounds")
                                    dialler.playBeeps()
                                    AppSession.playedBeeps = true
                                }
                            }
                        }
                        else
                        {
                            hangup()
                        }
                    }
                }
            }
            else if(!cvm.inCall && AppSession.activeScreen?.activeScreen == ActiveScreen.feedback)
            {
                
                FeedbackView()
            }
            else if(!cvm.inCall && AppSession.activeScreen?.activeScreen == ActiveScreen.reported)
            {
                ReportResponseView()
            }
            else
            {
                // HOME VIEW
                ZStack()
                {
                    // BACKGROUND LAYER
                    ColorManager.Purple.edgesIgnoringSafeArea(.all)
                    
                    // HEADER
                    if(UIDevice.current.userInterfaceIdiom == .pad)
                    {
                        VStack()
                        {
                            
                            Color.white.frame(width: UIScreen.screenWidth, height: UIDevice.current.hasNotch ? 50 : 0).offset(y: -35)
                            Image("babble-logo-speech").resizable()/*.aspectRatio(contentMode: .fit)*/
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.3, alignment: .top)
                                .offset(y: -55 )
                            Caller()
                            Spacer()
                        }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    }
                    else
                    {
                        VStack()
                        {
                            Color.white.frame(width: UIScreen.screenWidth, height: UIDevice.current.hasNotch ? 50 : 0).offset(y: -35)
                            Image("babble-logo-speech").resizable().aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight,alignment: .top)
                                .offset(y: -55 )
                            Caller()
                            Spacer()
                        }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    }
                    // HEADER
                    
                    // FOOTER
                    VStack()
                    {
                        Spacer()
                        
                        Image("caller-footer").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .bottom)
                            .offset(y: 0)
                    }
                    // END FOOTER
                    
                    // MAIN LAYOUT
                    VStack()
                    {
                        // CALL BUTTON
                        Button(action: {testFunc()})
                        {
                            Image("babble-circle-shadow")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWHalf)
                                .offset(x: 20)
                        }.alert(isPresented: $showingMicrophoneRequest) {
                            Alert(
                                title: Text("Oh Dear!"),
                                message: Text("We need permission in order to handle calls for you, please go to the MyBabble app in your settings and enable the microphone permission")
                            )
                        }.alert(isPresented: self.$showingPropmtView){
                            Alert(title: Text("MyBabble 17-Minute Chat using 'HAPPI' Conversation Prompts"), message: Text("H - How has your day/week been?\n\nA - Is there a recent ACHIEVEMENT you're pleased to talk about?\n\nP - Is there something PAINFUL (stressfull) you wish to get off your chest?\n\nP - Can you talk about a PLAN you're working on or hoping to work on in the near future?\n\nI - Can you name one thing you feel INDEBTED (grateful) for?"), primaryButton: Alert.Button.default(Text("Ok"), action: {
                                    testFunc()
                                }), secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                                print("no clicked")
                            })
                            )
                       }
                        // END CALL BUTTON
                        
                        // LABELS
                        Text("PRESS TO CHAT")
                            .foregroundColor(ColorManager.White)
                            .font(Font.custom("cera_pro_b", size: 24))
                        
                        
                        Text("MEMBERS ONLINE: \(cvm.acctiveListeners)")
                            .foregroundColor(ColorManager.Orange)
                            .font(Font.custom("cera_pro_b", size: 20))
                            .offset(y: 32)
                            .alert(isPresented:$showingCallingAlert) {
                                Alert(
                                    title: Text("No Listeners"),
                                    message: Text("There are currently no active listeners, please try calling again later")
                                )
                            }
                        
                        Text("ACCEPT CALLS")
                            .foregroundColor(ColorManager.White)
                            .font(Font.custom("cera_pro_b", size: 16))
                            .offset(y: 64)
                        // END LABELS
                        
                        
                        VStack()
                        {
                            // ACCEPT CALLS TOGGLE
                            HStack()
                            {
                                Toggle(isOn: $acceptingCalls)
                                {
                                    Text("No")
                                        .foregroundColor(ColorManager.White)
                                        .font(Font.custom("cera_pro_b", size: 16))
                                        .multilineTextAlignment(.leading)
                                }.fixedSize().offset(x: -5, y: 80).toggleStyle(CustomToggleStyle())
                                
                                Text("Yes")
                                    .foregroundColor(ColorManager.White)
                                    .font(Font.custom("cera_pro_b", size: 16))
                                    .offset(y: 80)
                            }
                            // END ACCEPT CALLS TOGGLE
                            
                            // BOTTOM BUTTONS
                            HStack()
                            {
                                Button(
                                    action:{
                                        ShowMail()
                                    },
                                    label: {
                                        Text("REPORT ISSUE")
                                            .foregroundColor(ColorManager.White)
                                            .font(Font.custom("cera_pro_b", size:16))
                                }).offset(x: -80, y: 120)

                                
                                
                                Button(
                                    action:{
                                        /*if(!cvm.inPool) {
                                            self.showingLogoutAlert = true
                                            
                                        }
                                        else {
                                            self.showingInPoolAlert = true
                                            
                                        }*/
                                        showingLogoutAlert = true
                                    },
                                    
                                    label: {
                                        Text("LOGOUT")
                                        .foregroundColor(ColorManager.White)
                                        .font(Font.custom("cera_pro_b", size: 16))
                                    }).offset(x: 80, y: 120).alert(isPresented:$showingLogoutAlert) {
                                        Alert(
                                            title: Text("Logout"),
                                            message: Text("You will no longer be contactable as a listener until you log back in. Do you want to logout?"),
                                            primaryButton: .default(Text("Yes"), action: {logout()}),
                                            secondaryButton: .default(Text("No"), action: {})
                                        )
                                    }
                            }
                        }
                    } // END MAIN LAYOUT VSTACK
                }
                
                
                
                
                
                
                // HOME VIEW
                /*
                ZStack()
                {
                    ColorManager.Purple.edgesIgnoringSafeArea(.all)
                    
                    if(UIDevice.current.userInterfaceIdiom == .pad)
                    {
                        VStack()
                        {
                            
                            Color.white.frame(width: UIScreen.screenWidth, height: UIDevice.current.hasNotch ? 50 : 0).offset(y: -35)
                            Image("babble-logo-speech").resizable()/*.aspectRatio(contentMode: .fit)*/
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.3, alignment: .top)
                                .offset(y: -55 )
                            Caller()
                            Spacer()
                        }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    }
                    else
                    {
                        VStack()
                        {
                            Color.white.frame(width: UIScreen.screenWidth, height: UIDevice.current.hasNotch ? 50 : 0).offset(y: -35)
                            Image("babble-logo-speech").resizable().aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight,alignment: .top)
                                .offset(y: -55 )
                            Caller()
                            Spacer()
                        }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    }
                    
                    VStack()
                    {
                        Spacer()

                        Image("caller-footer").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .bottom)
                            .offset(y: 0)
                    }
                    
                    VStack()
                    {

                            
                            Button(action: {testFunc()})
                            {
                                Image("babble-circle-shadow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.screenWHalf)
                                    .offset(x: 20)
                            }.alert(isPresented: $showingMicrophoneRequest){
                                Alert(
                                    title: Text("Oh Dear!"),
                                    message: Text("We need permission in order to handle calls for you, please go to the MyBabble app in your settings and enable the microphone permission")
                                )
                            }
                            
                            VStack()
                            {
                                Text("PRESS TO CHAT")
                                    .foregroundColor(ColorManager.White)
                                    .font(Font.custom("cera_pro_b", size: 24))
                                
                                
                                Text("MEMBERS ONLINE: \(cvm.acctiveListeners)")
                                    .foregroundColor(ColorManager.Orange)
                                    .font(Font.custom("cera_pro_b", size: 20))
                                    .offset(y: 32)
                                    .alert(isPresented:$showingCallingAlert) {
                                        Alert(
                                            title: Text("No Listeners"),
                                            message: Text("There are currently no active listeners, please try calling again later")
                                        )
                                    }
                                
                                Text("ACCEPT CALLS")
                                    .foregroundColor(ColorManager.White)
                                    .font(Font.custom("cera_pro_b", size: 16))
                                    .offset(y: 64)
                                
                            }
  
                            HStack()
                            {

                                Toggle(isOn: $caller)
                                {
                                    Text("No")
                                        .foregroundColor(ColorManager.White)
                                        .font(Font.custom("cera_pro_b", size: 16))
                                        .multilineTextAlignment(.leading)
                                }.fixedSize().offset(x: -5, y: 80).toggleStyle(CustomToggleStyle())
                                    
                                Text("Yes")
                                        .foregroundColor(ColorManager.White)
                                        .font(Font.custom("cera_pro_b", size: 16))
                                        .offset(y: 80)

                            }
                    }.offset(y: -25)
                        .alert(isPresented:$showingLogoutAlert) {
                            Alert(
                                title: Text("Logout"),
                                message: Text("You will no longer be contactable as a listener until you log back in. Do you want to logout?"),
                                primaryButton: .default(Text("Yes"), action: {logout()}),
                                secondaryButton: .default(Text("No"), action: {})
                            )
                        }
    
                    
                    HStack()
                    {
                        Button(action: { ShowMail()}, label:
                        {
                            Text("REPORT ISSUE")
                                .foregroundColor(ColorManager.White)
                                //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 18))
                                .font(Font.custom("cera_pro_b", size: 16))
                            })
                        .offset(x: -100, y: UIScreen.screenHHalf - 100)
                        }.disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $showingMailView)
                        {
                            MailView(result: self.$result, recipients: ["support@mybabble.chat"], messageBody: "", subject: "Issue with Babble Application")
                        }
                    
                        Button(action: { if(!cvm.inPool){ self.showingLogoutAlert = true} else { self.showingInPoolAlert = true}}, label:
                        {
                            Text("LOGOUT")
                                .foregroundColor(ColorManager.White)
                                //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 18))
                                .font(Font.custom("cera_pro_b", size: 16))
                            })
                        .offset(x: 110, y: UIScreen.screenHHalf - 100)
                        }.disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $showingMailView)
                        {
                            MailView(result: self.$result, recipients: ["support@mybabble.chat"], messageBody: "", subject: "Issue with Babble Application")
                        }
                */
                
                
                

            }
        }.navigationBarTitle("Babble")
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {onViewLaunch()})
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
        .onReceive(timer) { time in
            //check every 60 seconds the status pool
            
            AppSession.acceptingCalls = acceptingCalls
            cvm.inPool = AppSession.isInPool()
            
            if (!cvm.inPool)
            {
                enterCallPool()
            }
            cvm.acctiveListeners = AppSession.getListenerCount()
        }
    }
    
    func ShowMail(){
        debugPrint("Show mail")
        self.showingMailView = true
    }
    
    
    
    func onViewLaunch()
    {
        print("Loaded View")
        
        
        // start test
        enterCallPool();
        //exitCallPool();
        //logout();
        // end test
        
        dialler.viewDidLoad()
        AppSession.inCall = cvm
        
        cvm.inPool = AppSession.isInPool()
        
  
        if(AppSession.userDefaults.object(forKey: "usage") == nil)
        {
            AppSession.userDefaults.set("", forKey: "usage")
        }
        
        let costs: [String] = AppSession.getUserUsage()
        let lastCosts: String = AppSession.userDefaults.string(forKey: "usage") ?? ""
        
        if(lastCosts != costs[0])
        {
            AppSession.userDefaults.set(costs[0], forKey: "usage")
            AppSession.betaMessage = costs[1]
            if(AppSettings.showBetaSurvey)
            {
                showAlert = true;
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: Selector(("proximityChanged:")), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
    }
    
    func proximityChanged(notif: UNUserNotificationCenter)
    {
        if(UIDevice.current.proximityState == true)
        {
            //iCall.isUserInteractionEnabled = false;
            print("attempt input disable")
        }
        else
        {
            //self.isUserInteractionEnabled = true;
            print("attempt input re-enable")
        }
    }
    
    func logout()
    {
        AppSession.bToken = ""
        KeychainService.removeToken(service: "babble", account: "signedInUser")
        KeychainService.removeToken(service: "babble", account: "userVerified")
        AppSession.activeScreen?.activeScreen = ActiveScreen.landing
        exitCallPool()
        cvm.inPool = AppSession.isInPool()
    }
    
    
    
    
    
    func testFunc()
    {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted
            {
                if(cvm.acctiveListeners > 0)
                {
                    if (!showingPropmtView)
                    {
                        showingPropmtView = true
                    }
                    else
                    {
                        print("make call")
                        exitCallPool()
                        dialler.callButtonPressed(self)
                        showingPropmtView = false
                    }
                }
                else
                {
                    showingCallingAlert = true
                }
                
                AppSession.acceptingCalls = acceptingCalls
                
                /*
                if(caller)
                {
                    if(cvm.acctiveListeners > 0)
                    {
                        print("make call")
                        exitCallPool()
                        dialler.callButtonPressed(self)
                    }
                    else
                    {
                        showingCallingAlert = true
                    }
                }
                else
                {
                    if(cvm.inPool)
                    {
                        exitCallPool()
                        print("left pool")
                    }
                    else
                    {
                        enterCallPool()
                        print("queue to listen")
                    }
                }
                */
                
                
                
                
            }
            else
            {
                self.showingMicrophoneRequest = true
            }
            cvm.inPool = AppSession.isInPool()
            cvm.acctiveListeners = AppSession.getListenerCount()
        }
    }
    
    func secondsToTime(seconds: Int) -> String
    {
        let mins: Int = seconds / 60
        let secs: Int = seconds - (mins * 60)
        if(secs < 10)
        {
            return "\(mins):0\(secs)"
        }
        else
        {
            return "\(mins):\(secs)"
        }
    }
    
    func enterCallPool()
    {
        let url = URL(string: AppSession.apiURL + "/pool/enter")!
        let boundary = "Boundary-\(UUID().uuidString)"
        let sem = DispatchSemaphore(value: 0)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + AppSession.bToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error  in
            defer { sem.signal() }
              guard let data = data else {
                print(String(describing: error))
                return
              }
            let response: String = String(data: data, encoding: .utf8)!
            print(response)
            print("successfully joined pool")
                                           
        }
        
        task.resume()
        sem.wait()
    }
    
    func exitCallPool()
    {
        let url = URL(string: AppSession.apiURL + "/pool/leave")!
        let boundary = "Boundary-\(UUID().uuidString)"
        let sem = DispatchSemaphore(value: 0)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + AppSession.bToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error  in
            defer { sem.signal() }
              guard let data = data else {
                print(String(describing: error))
                return
              }
            let response: String = String(data: data, encoding: .utf8)!
            print(response)
            print("successfully left pool")
                                           
        }
        task.resume()
        sem.wait()
    }
    
    func updateCounter()
    {
        
    }
    
    func hangup()
    {
        dialler.hangUpButtonPressed(self)
        enterCallPool()
        cvm.inPool = AppSession.isInPool()
        //back to main pre call screen
    }
    
    func panic()
    {
        AppSession.reportCall(status: 2)
        hangup()
        AppSession.dontShowFeedback = true
        AppSession.reportDialog = true
    }
}
