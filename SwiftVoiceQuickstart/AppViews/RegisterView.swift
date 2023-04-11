//
//  RegisterView.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 10/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI


struct RegisterView: View
{
    @State private var email: String = ""
    @State private var pass: String = ""
    @State private var passCon: String = ""
    @State private var errorMessage = ""

    @State var emailField = UITextField()
    @State var passwordField = UITextField()
    @State var confirmField = UITextField()

    @State private var showingTermsAndConditions = false
    @State private var showingAgreement = false
    @State private var agreed = false
    
    func attemptRegister()
    {
        if(isNetworkConnected)
        {
            let url = URL(string: AppSession.apiURL + "/register")!
            let boundary = "Boundary-\(UUID().uuidString)"
        
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
        
            let parameters =
            [
                [
                    "key": "password",
                    "value": pass,
                    "type": "text"
                ],
                [
                    "key": "password_confirmation",
                    "value": passCon,
                    "type": "text"
                ],
                [
                    "key": "email",
                    "value": email,
                    "type": "text"
                ],
                [
                    "key": "device_name",
                    "value": "iPhone:" + UIDevice.current.identifierForVendor!.uuidString,
                    "type": "text"
                ]
            ]
            as
            [
                [String : Any]
            ]
        
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
                        print("login fail")
                    }
                    return
                }
                AppSession.userID = String(confirmedDetails.data.id)
                AppSession.bToken = confirmedDetails.meta.token
                
                KeychainService.removeToken(service: "babble", account: "signedInUser")
                KeychainService.saveToken(service: "babble", account: "signedInUser", data: confirmedDetails.meta.token)
                
                print(AppSession.userID)

                AppSession.appDel?.setPushKit()
            
                KeychainService.removeToken(service: "babble", account: "userVerified")
                KeychainService.saveToken(service: "babble", account: "userVerified", data: String(/*confirmedDetails.data.is_verified*/true))

                AppSession.activeScreen?.activeScreen = ActiveScreen.call
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
            else
            {
                errorMessage = "Please check your connection"
            }
        }
    
        func reachable(host: String) -> Bool {
            var res: UnsafeMutablePointer<addrinfo>?
            let n = getaddrinfo(host, nil, nil, &res)
            freeaddrinfo(res)
            return n == 0
        }
    
        var isNetworkConnected: Bool { reachable(host: "apple.com") }
    
        var body: some View
        {
            NavigationView
            {
                ZStack()
                {
                    ColorManager.Slate.edgesIgnoringSafeArea(.all)
   
                    VStack()
                    {
                        //Image("mybabblelogo4")
                        //    .resizable()
                        //    .aspectRatio(contentMode: .fit)
                        //    .padding(32)
                        
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
                        
                        Text("Please enter your details")
                            .foregroundColor(ColorManager.White)
                            //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 20))
                            .font(Font.custom("cera_pro_r", size: 20))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(width: 340, height: 60)
                    
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
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                
                        CustomSecureField(placeholder: Text("Confirm Password").foregroundColor(ColorManager.Grey), text: $passCon)
                            .padding(.vertical, 20)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                    
                        //Spacer().frame(height: 30)
                    
                    Button(action: {
                        if (pass == passCon)
                        {
                            if(agreed == false)
                            {
                                showingTermsAndConditions = true
                            }
                            else{
                                attemptRegister()
                            }
                        }
                        else
                        {
                            errorMessage = "Passwords do not match"
                        }
                    }, label: {
                        Text( "Next")
                            .padding(.vertical, 20)
                            .foregroundColor(ColorManager.White)
                            .frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 65, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            //.font(.custom(UIFont.FontString(UIFont.CeraProType.Bold), size: 20))
                            .font(Font.custom("cera_pro_r", size: 20))
                        })
                        .background(ColorManager.DarkOrange)
                        .cornerRadius(50)
                        .offset(y: 5)
                    
                        Button(action: {AppSession.activeScreen?.activeScreen = ActiveScreen.landing}, label:
                        //Button(action: {AppSession.activeScreen?.activeScreen = ActiveScreen.update}, label:
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
                    
                    }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .alert(isPresented:$showingTermsAndConditions) {
                        Alert(
                            title: Text("Terms and Conditions / EULA"),
                            message: Text("Please read and agree to our end user license agreement before you use this app"),
                            primaryButton: .destructive(Text("Cancel"), action: {}),
                            secondaryButton: .default(Text("EULA"), action:
                                {
                                showingTermsAndConditions = false
                                if let url = URL(string: "https://www.mybabble.chat/terms-and-conditions")
                                {
                                    UIApplication.shared.open(url)
                                    showingAgreement = true
                                }})
                        )
                    }
                
                /*HStack()
                {
                    Button(action: {AppSession.activeScreen?.activeScreen = ActiveScreen.landing}, label:
                             {
                                Text("❮ Back")
                                    .padding(.all, 15)
                                    .foregroundColor(ColorManager.White)
                                    .frame(width: UIScreen.screenWQuart, height: 65, alignment: .leading)
                                    .font(.system(size: 30, weight: .heavy))
                             })
                    Spacer()
                }.offset(y: UIScreen.screenH35).frame(width: UIScreen.screenWidth, height: 65)*/
                
                
                }
            }.navigationBarTitle("Babble").navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
                .alert(isPresented:$showingAgreement) {
            Alert(
                title: Text("Terms and Conditions / EULA"),
                message: Text("Do you agree to these terms?"),
                primaryButton: .destructive(Text("Disagree")),
                secondaryButton: .default(Text("Agree")) {
                    agreed = true
                    attemptRegister()
                    showingAgreement = false
                }
            )
                    
                }
    }
}
