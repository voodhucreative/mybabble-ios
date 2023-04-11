//
//  LoginView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 10/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct LoginView: View{
    @State private var user: String = ""
    @State private var pass: String = ""
    @State private var errorMessage = ""
    
    @State var emailField = UITextField()
    @State var passwordField = UITextField()
    
    var body: some View{
        NavigationView{
            ZStack()
            {
                ColorManager.Slate.edgesIgnoringSafeArea(.all)
                
                VStack()
                {
                    //Spacer().frame(height: UIDevice.current.hasNotch ? 80 : 20)
                    Spacer()
                    
                    Image("home-footer").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .bottom)
                        .offset(y: -10)
                }
                
                VStack()
                {
                    Image("mybabblelogo4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(32)
                    
                    Text("Please enter your login details")
                        .foregroundColor(ColorManager.White)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(width: 280, height: 80)
                    
                    Text(errorMessage)
                        .foregroundColor(ColorManager.Red)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(width: 340, height: 40)
                    
                    
                    CustomTextField(placeholder: Text("Email").foregroundColor(ColorManager.Grey), text: $user, emailField: true)
                        .padding(.vertical, 20)
                        .foregroundColor(ColorManager.Black)
                        .background(ColorManager.White)
                        .cornerRadius(50)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 70, alignment: .center)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        //.font(.custom(UIFont.FontString(UIFont.CeraProType.Medium), size: 20))
                        .font(Font.custom("cera_pro_r", size: 20))
                        .introspectTextField { textField in
                            emailField = textField
                        }
                        .onTapGesture {
                            emailField.becomeFirstResponder()
                        }
                    
                    
                    CustomSecureField(placeholder: Text("Password").foregroundColor(ColorManager.Grey), text: $pass)
                        .padding(.vertical, 20)
                        .foregroundColor(ColorManager.Black)
                        .background(ColorManager.White)
                        .cornerRadius(50)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 70, alignment: .center)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        //.font(.custom(UIFont.FontString(UIFont.CeraProType.Medium), size: 20))
                        .font(Font.custom("cera_pro_r", size: 20))
                        .introspectTextField { textField in
                            passwordField = textField
                        }
                        .onTapGesture {
                            passwordField.becomeFirstResponder()
                        }
                    
                    Button(action: {attemptLogin()} , label: {
                        Text( "Login")
                            .foregroundColor(ColorManager.White)
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 60, alignment: .center)
                            //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 20))
                            .font(Font.custom("cera_pro_r", size: 20))
                    })
                    .background(ColorManager.DarkOrange)
                    .cornerRadius(50)
                    .offset(y: 5)
                    
                    Button(action: {AppSession.activeScreen?.activeScreen = ActiveScreen.forgot}, label:
                     {
                        Text( "FORGOT PASSWORD?")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 20)
                            .foregroundColor(ColorManager.White)
                            .font(Font.custom("cera_pro_r", size: 12))
                     })
                    
                    Button(action: {AppSession.activeScreen?.activeScreen = ActiveScreen.landing}, label:
                             {
                                HStack()
                                {
                                    Text("❮")
                                        .foregroundColor(ColorManager.White)
                                        .font(.system(size: 30, weight: .heavy))
                                    
                                    Text("Back")
                                        .foregroundColor(ColorManager.White)
                                        .font(.system(size: 26))
                                    
                                }.frame(width: UIScreen.screenWHalf, height: 40, alignment: .center).padding(.all, 15)
                             })
                    
                }
                
                /*HStack()
                {
                    Button(action: {AppSession.activeScreen?.activeScreen = ActiveScreen.landing}, label:
                             {
                                Text("❮")
                                    .padding(.all, 15)
                                    .foregroundColor(ColorManager.White)
                                    .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 65, alignment: .leading)
                                    .font(.system(size: 30, weight: .heavy))
                             })
                    Spacer()
                }*/
            }
        }.navigationBarTitle("Babble").navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
    }
    
    func attemptLogin()
    {
        let url = URL(string: AppSession.apiURL + "/login")!
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters = [
          [
            "key": "email",
            "value": user,
            "type": "text"
          ],
          [
            "key": "password",
            "value": pass,
            "type": "text"
          ],
          [
            "key": "device_name",
            "value": "iPhone:" + UIDevice.current.identifierForVendor!.uuidString,
            "type": "text"
          ]] as [[String : Any]]
        
        request.httpBody = encoder.encodeData(parameters: parameters, boundary: boundary).data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error  in
              guard let data = data else {
                print(String(describing: error))
                return
              }
            let response: String = String(data: data, encoding: .utf8)!
            print(response)
            
            var confirmedDetails: LoginReponse
            
            if let details: LoginReponse = try? JSONDecoder().decode(LoginReponse.self, from: data)
            {
                confirmedDetails = details
            }
            else
            {
                if let details: ErrorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                {
                    if(details.errors.email != nil && details.errors.email?[0] != "")
                    {
                        errorMessage = details.errors.email?[0] ?? ""
                    }
                    else if(details.errors.username != nil && details.errors.username?[0] != "")
                    {
                        errorMessage = details.errors.username?[0] ?? ""
                    }
                    else
                    {
                        errorMessage = details.errors.password?[0] ?? ""
                    }
                }
                else
                {
                    print("login fail : " + pass)
                }
                return
            }
            
            AppSession.userID = String(confirmedDetails.data.id)
            AppSession.bToken = confirmedDetails.meta.token
            
            KeychainService.removeToken(service: "babble", account: "signedInUser")
            KeychainService.saveToken(service: "babble", account: "signedInUser", data: confirmedDetails.meta.token)
            
            print(AppSession.userID)
            //AppSession.dialler!.credentialsInvalidated()
            AppSession.appDel?.setPushKit()
            
//            let defaults = UserDefaults.standard
//            defaults.set(confirmedDetails.data.is_verified, forKey: "userVerified")
            
            KeychainService.removeToken(service: "babble", account: "userVerified")
            KeychainService.saveToken(service: "babble", account: "userVerified", data: /*String(confirmedDetails.data.is_verified)*/"true")
            
//            if(!confirmedDetails.data.is_verified)
//            {
//                AppSession.resendVerification()
//                AppSession.activeScreen?.activeScreen = ActiveScreen.verify
//            }
//            else
//            {
//                AppSession.activeScreen?.activeScreen = ActiveScreen.call
//            }
            
            if (AppSettings.requiresFullProfile)
            {
                /*
                if (confirmedDetails.data.profile_complete) // edit when api fixed
                {
                    AppSession.activeScreen?.activeScreen = ActiveScreen.call
                }
                else
                {
                    AppSession.activeScreen?.activeScreen = ActiveScreen.update
                }
                */
                AppSession.activeScreen?.activeScreen = ActiveScreen.update
            }
            else
            {
                AppSession.activeScreen?.activeScreen = ActiveScreen.call
            }
                
            
        }
        
        if(AppSession.isValidEmail(user))
        {
            task.resume()
        }
        else
        {
            errorMessage = "Invalid email"
        }
    }
}
