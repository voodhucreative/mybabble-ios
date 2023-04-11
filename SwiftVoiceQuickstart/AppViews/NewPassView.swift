//
//  LoginView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 10/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct NewPassView: View{
    @State private var pass: String = ""
    @State private var passConfirm: String = ""
    @State private var errorMessage = ""
    
    @State var passwordField = UITextField()
    @State var confirmField = UITextField()
    
    var body: some View{
        NavigationView
        {
            ZStack()
            {
                ColorManager.Slate.edgesIgnoringSafeArea(.all)
                
                VStack()
                {
                    Spacer().frame(height: UIDevice.current.hasNotch ? 80 : 20)
                    Image("babble-logo-white")
                        //.offset(y: -320)
                    Spacer()
                    
                    Image("home-footer").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .bottom)
                        .offset(y: -50)
                }
                
                VStack()
                {
                    
                    Text("Please enter a new password")
                        .foregroundColor(ColorManager.White)
                        //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 20))
                        .font(Font.custom("cera_pro_r", size: 20))
                        .multilineTextAlignment(.center)
                        .frame(width: 280, height: 80)
                    
                    Text(errorMessage)
                        .foregroundColor(ColorManager.Red)
                        //.font(.custom(UIFont.FontString(UIFont.CeraProType.Medium), size: 16))
                        .font(Font.custom("cera_pro_r", size: 20))
                        .multilineTextAlignment(.center)
                        .frame(width: 340, height: 40)
                    
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
                    
                    CustomSecureField(placeholder: Text("Confirm Password").foregroundColor(ColorManager.Grey), text: $passConfirm)
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
                            confirmField = textField
                        }
                        .onTapGesture {
                            confirmField.becomeFirstResponder()
                        }
                    
                    Button(action: {sendVerify()} , label: {
                        Text( "Submit")
                            .foregroundColor(ColorManager.White)
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 60, alignment: .center)
                            //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 20))
                            .font(Font.custom("cera_pro_r", size: 20))
                    })
                    .background(ColorManager.DarkOrange)
                    .cornerRadius(50)
                    .offset(y: 5)
                    
                    Spacer().frame(height: 20)
                    
                    Button(action: {AppSession.activeScreen?.activeScreen = ActiveScreen.landing} , label: {
                        Text( "Cancel")
                            .foregroundColor(ColorManager.Black)
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 60, alignment: .center)
                            //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 20))
                            .font(Font.custom("cera_pro_r", size: 20))
                    })
                    .background(ColorManager.White)
                    .cornerRadius(50)
                    .offset(y: 5)
                    
                }.offset(y: -80)
            }
        }.navigationBarTitle("Babble").navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
    }
    
    func sendVerify()
    {
        let url = URL(string: AppSession.apiURL + "/reset-password")!
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters = [
          [
            "key": "email",
            "value": AppSession.resetEmail,
            "type": "text"
          ],
            [
              "key": "verification_code",
                "value": AppSession.resetCode,
              "type": "text"
            ],
            [
              "key": "password",
                "value": pass,
              "type": "text"
            ],
            [
              "key": "password_confirmation",
                "value": passConfirm,
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
            let responses: String = String(data: data, encoding: .utf8)!
            print(responses)
            
            if let httpRes = response as? HTTPURLResponse
            {
                switch httpRes.statusCode {
                case 200 ... 299:
                    print("Success")
                    AppSession.resetCode = ""
                    AppSession.resetEmail = ""
                    AppSession.activeScreen?.activeScreen = ActiveScreen.landing
                default:
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
                        errorMessage = "Failed to reset password"
                        print("password reset fail")
                    }
                }
            }
        }
        
        task.resume()
    }
}
