//
//  UpdateDetailsView.swift
//  MyBabble
//
//  Created by Mat Howlett on 09/03/2023.
//  Copyright © 2023 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI


struct UpdateDetailsView: View
{
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var errorMessage = ""
    @State private var gender: String = ""
    @State private var pronouns: String = ""
    @State private var city: String = ""
    @State private var county: String = ""
    @State private var languages: String = ""
    

    @State var firstNameField = UITextField()
    @State var lastNameField = UITextField()
    @State var genderField = UITextField()
    @State var pronounsField = UITextField()
    @State var cityField = UITextField()
    @State var countyField = UITextField()
    @State var languagesField = UITextField()
    
    // IMPORTANT!!!! NEEDS /update route creating!!
    
    func attemptUpdateDetails()
    {
        /*if(isNetworkConnected)
        {
            let url = URL(string: AppSession.apiURL + "/updateProfile")!
            let boundary = "Boundary-\(UUID().uuidString)"
        
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
        
            let parameters =
            [
                [
                "key": "firstname",
                "value": firstName,
                "type": "text"
                ],
                [
                "key": "lastname",
                "value": lastName,
                "type": "text"
                ],
                [
                "key": "gender",
                "value": gender,
                "type": "text"
                ],
                [
                "key": "pronouns",
                "value": pronouns,
                "type": "text"
                ],
                [
                "key": "city",
                "value": city,
                "type": "text"
                ],
                [
                "key": "county",
                "value": county,
                "type": "text"
                ],
                [
                "key": "languages",
                "value": languages,
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
                //AppSession.dialler!.credentialsInvalidated()
                AppSession.appDel?.setPushKit()
            
//              let defaults = UserDefaults.standard
//              defaults.set(confirmedDetails.data.is_verified, forKey: "userVerified")
            
                KeychainService.removeToken(service: "babble", account: "userVerified")
                KeychainService.saveToken(service: "babble", account: "userVerified", data: String(/*confirmedDetails.data.is_verified*/true))

//              if(!confirmedDetails.data.is_verified)
//              {
//                  AppSession.resendVerification()
//                  AppSession.activeScreen?.activeScreen = ActiveScreen.verify
//              }
//              else
//              {
                    AppSession.activeScreen?.activeScreen = ActiveScreen.call
//              }
                                           
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
            }*/
        
        
            AppSession.activeScreen?.activeScreen = ActiveScreen.call
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
                        Image("mybabblelogo4")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(32)
                        
                        Spacer()
                        
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
                        
                        CustomTextField(placeholder: Text("First Name").foregroundColor(ColorManager.Grey), text: $firstName, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                firstNameField = textField
                            }
                            .onTapGesture {
                                firstNameField.becomeFirstResponder()
                            }.padding(.vertical, 8)
                        
                        
                        CustomTextField(placeholder: Text("Last Name").foregroundColor(ColorManager.Grey), text: $lastName, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                lastNameField = textField
                            }
                            .onTapGesture {
                                lastNameField.becomeFirstResponder()
                            }.padding(.vertical, 8)
                        
                        CustomTextField(placeholder: Text("Gender").foregroundColor(ColorManager.Grey), text: $gender, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                genderField = textField
                            }
                            .onTapGesture {
                                genderField.becomeFirstResponder()
                            }.padding(.vertical, 8)
                        
                        CustomTextField(placeholder: Text("Pronouns").foregroundColor(ColorManager.Grey), text: $pronouns, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                pronounsField = textField
                            }
                            .onTapGesture {
                                pronounsField.becomeFirstResponder()
                            }.padding(.vertical, 8)
                        
                        CustomTextField(placeholder: Text("Languages").foregroundColor(ColorManager.Grey), text: $languages, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                languagesField = textField
                            }
                            .onTapGesture {
                                languagesField.becomeFirstResponder()
                            }.padding(.vertical, 8)
                        
                        CustomTextField(placeholder: Text("City").foregroundColor(ColorManager.Grey), text: $city, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                cityField = textField
                            }
                            .onTapGesture {
                                cityField.becomeFirstResponder()
                            }.padding(.vertical, 8)
                        
                        CustomTextField(placeholder: Text("County").foregroundColor(ColorManager.Grey), text: $county, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                countyField = textField
                            }
                            .onTapGesture {
                                countyField.becomeFirstResponder()
                            }.padding(.vertical, 12)
                        
                        Button(
                            action: {
                                attemptUpdateDetails()
                            },
                            label: {
                                Text( "Update").padding(.vertical, 20).foregroundColor(ColorManager.White).frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 65, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).font(Font.custom("cera_pro_r", size: 20))
                            }).background(ColorManager.DarkOrange).cornerRadius(50).offset(y: 5)
                    
                        Button(
                            action: {
                                    AppSession.activeScreen?.activeScreen = ActiveScreen.landing
                                    
                                },
                            label: {
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
                    
                    /*
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
                        
                        
                        
                        CustomTextField(placeholder: Text("First Name").foregroundColor(ColorManager.Grey), text: $firstName, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                firstNameField = textField
                            }
                            .onTapGesture {
                                firstNameField.becomeFirstResponder()
                            }
                        
                        CustomTextField(placeholder: Text("Last Name").foregroundColor(ColorManager.Grey), text: $lastName, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                lastNameField = textField
                            }
                            .onTapGesture {
                                lastNameField.becomeFirstResponder()
                            }
                    }
                    VStack()
                    {
                        CustomTextField(placeholder: Text("Gender").foregroundColor(ColorManager.Grey), text: $gender, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                genderField = textField
                            }
                            .onTapGesture {
                                genderField.becomeFirstResponder()
                            }
                        
                        CustomTextField(placeholder: Text("Pronouns").foregroundColor(ColorManager.Grey), text: $pronouns, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                pronounsField = textField
                            }
                            .onTapGesture {
                                pronounsField.becomeFirstResponder()
                            }
                        
                        CustomTextField(placeholder: Text("Languages").foregroundColor(ColorManager.Grey), text: $languages, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                languagesField = textField
                            }
                            .onTapGesture {
                                languagesField.becomeFirstResponder()
                            }
                        
                        CustomTextField(placeholder: Text("City").foregroundColor(ColorManager.Grey), text: $city, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                cityField = textField
                            }
                            .onTapGesture {
                                cityField.becomeFirstResponder()
                            }
                        
                        CustomTextField(placeholder: Text("County").foregroundColor(ColorManager.Grey), text: $county, emailField: false)
                            .padding(.vertical, 12)
                            .foregroundColor(ColorManager.Black)
                            .background(ColorManager.White)
                            .cornerRadius(50)
                            .multilineTextAlignment(.center)
                            .frame(width: 120, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .font(Font.custom("cera_pro_r", size: 20))
                            .introspectTextField { textField in
                                countyField = textField
                            }
                            .onTapGesture {
                                countyField.becomeFirstResponder()
                            }
   
                        Button(
                            action: {
                                attemptUpdateDetails()
                            },
                            label: {
                                Text( "Update").padding(.vertical, 20).foregroundColor(ColorManager.White).frame(width: UIScreen.screenWHalf + UIScreen.screenWQuart, height: 65, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).font(Font.custom("cera_pro_r", size: 20))
                            }).background(ColorManager.DarkOrange).cornerRadius(50).offset(y: 5)
                    
                        Button(
                            action: {
                                    AppSession.activeScreen?.activeScreen = ActiveScreen.landing
                                    
                                },
                            label: {
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
                    
                    }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)*/
                    
                    
                    
                }
            }.navigationBarTitle("Babble").navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
    }
}
