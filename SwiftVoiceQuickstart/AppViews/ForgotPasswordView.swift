//
//  LoginView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 10/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View{
    @State private var email: String = ""
    @State private var errorMessage = ""
    
    @State var emailField = UITextField()
    
    var body: some View{
        NavigationView
        {
            ZStack()
            {
                ColorManager.Slate.edgesIgnoringSafeArea(.all)
                
                VStack()
                {
                    //Spacer().frame(height: UIDevice.current.hasNotch ? 80 : 20)
                    //Image("babble-logo-white")
                        //.offset(y: -320)
                    //Spacer()
                    
                    Image("home-footer").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .bottom)
                        .offset(y: 0)
                }
                
                VStack()
                {
                    Image("mybabblelogo4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(32)
                    
                    Text("Please enter email")
                        .foregroundColor(ColorManager.White)
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(width: 280, height: 80)
                    
                    Text(errorMessage)
                        .foregroundColor(ColorManager.Red)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(width: 340, height: 40)
                    
                    CustomTextField(placeholder: Text("Email").foregroundColor(ColorManager.Grey), text: $email, emailField: true)
                        .padding(.vertical, 20)
                        .foregroundColor(ColorManager.Black)
                        .background(ColorManager.White)
                        .cornerRadius(50)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 70, alignment: .center)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .introspectTextField { textField in
                            emailField = textField
                        }
                        .onTapGesture {
                            emailField.becomeFirstResponder()
                        }
                    
                    Button(action: {sendReset()} , label: {
                        Text( "Submit")
                            .foregroundColor(ColorManager.White)
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 60, alignment: .center)
                            .font(.system(size: 26, weight: .heavy))
                    })
                    .background(ColorManager.DarkOrange)
                    .cornerRadius(50)
                    .offset(y: 5)
                    
                    Spacer().frame(height: 20)
                    
                    Button(action: {AppSession.activeScreen?.activeScreen = ActiveScreen.landing} , label: {
                        Text( "Cancel")
                            .foregroundColor(ColorManager.Black)
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 60, alignment: .center)
                            .font(.system(size: 22))
                    })
                    .background(ColorManager.White)
                    .cornerRadius(50)
                    .offset(y: 5)
                    
                }.offset(y: -80)
            }
        }.navigationBarTitle("Babble").navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
    }
    
    func sendReset()
    {
        let url = URL(string: AppSession.apiURL + "/reset-password/request")!
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters = [
          [
            "key": "email",
            "value": email,
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
                switch(httpRes.statusCode)
                {
                case 200 ... 299:
                    print("Success")
                    AppSession.resetEmail = email
//                    AppSession.activeScreen?.activeScreen = ActiveScreen.verification
                    break
                    
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
                        errorMessage = "Unknown Error, please try again later"
                        print("password reset fail")
                    }
                    return
                }
            }
            ToVerfication()
        }
        
        if(AppSession.isValidEmail(email))
        {
            task.resume()
        }
        else
        {
            errorMessage = "Invalid email"
        }
    }
    
    func ToVerfication()
    {
        
        DispatchQueue.main.async {
            AppSession.activeScreen?.activeScreen = ActiveScreen.verify
        }
        
    }
}
