//
//  AppSession.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 20/10/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct ListnerCount : Decodable
{
    let pool_count: Int
}

struct AppSession {
    
    static var userID = "default"
    static var dialler: Dialler?
    static var pkEventDelegate: PushKitEventDelegate?
    static var inCall: CallViewModel?
    static var appDel: AppDelegate?
    static var activeScreen: ScreenModel?
    static var nextScreen: ActiveScreen = ActiveScreen.landing
    static let apiURL: String = "https://api.mybabble.chat/api"
    static var bToken: String?
    static var lastCallSID: String = ""
    static var dontShowFeedback: Bool = false
    static var reportDialog: Bool = false
    static let userDefaults = UserDefaults.standard
    static var betaMessage: String = "Something went wrong"
    static var playedBeeps: Bool = false
    static var isSpeaker: Bool = false
    
    //Verification Remembers
    static var resetEmail: String = "";
    static var resetCode: String = "";
    
    static var acceptingCalls: Bool = true
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //API Calls
    
    static func reportCall(status: Int)
    {
        if (lastCallSID == "")
        {
            print("no SID")
            return
        }
        
        print(lastCallSID)
        
        let url = URL(string: AppSession.apiURL + "/issue")!
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + AppSession.bToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let parameters = [
            [
                "key": "call_sid",
                "value": lastCallSID,
                "type": "text"
            ],
            [
                "key": "type",
                "value": String(status),
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
            print("successfully reported")
                                           
        }
        
        
        task.resume()
    }
    
    static func sendFeedback(positivity: Int, energy: Int, loneliness: Int, callRating: Int)
    {
        
    }
    
    
    
    
    static func rateCall(rating: Int)
    {
        if (lastCallSID == "")
        {
            print("no SID")
            return
        }
        
        print(lastCallSID)
        
        let url = URL(string: AppSession.apiURL + "/rating")!
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + AppSession.bToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let parameters = [
            [
                "key": "call_sid",
                "value": lastCallSID,
                "type": "text"
            ],
            [
                "key": "rating",
                "value": String(rating),
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
            print("successfully rated")
            AppSession.lastCallSID = ""
                                           
        }
        
        task.resume()
        
        
    }
    
    static func giveFeedback(price: String, worth: Int)
    {
        let url = URL(string: AppSession.apiURL + "/feedback")!
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + AppSession.bToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let parameters = [
            [
                "key": "price",
                "value": price,
                "type": "text"
            ],
            [
                "key": "worth",
                "value": String(worth),
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
                                           
        }
        
        task.resume()
    }
    
    static func getListenerCount() -> Int
    {
        
        let url = URL(string: AppSession.apiURL + "/pool/count")!
        let boundary = "Boundary-\(UUID().uuidString)"
        let sem = DispatchSemaphore(value: 0)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + AppSession.bToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        var number: Int = 0;
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error  in
            defer { sem.signal() }
              guard let data = data else {
                print(String(describing: error))
                return
              }
            
            
            if let no: ListnerCount = try? JSONDecoder().decode(ListnerCount.self, from: data)
            {
                number = no.pool_count
            }
                                           
        }

        
        
        task.resume()
        sem.wait()
        return number
    }
    
    static func resendVerification()
    {
        
        let url = URL(string: AppSession.apiURL + "/verify-email/resend")!
        let boundary = "Boundary-\(UUID().uuidString)"
        let sem = DispatchSemaphore(value: 3)
        
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
                print("sent another email")
                return
              }
                                           
        }
        task.resume()
        sem.wait()
    }
    
    static func getUserUsage() -> [String]
    {
        
        let url = URL(string: AppSession.apiURL + "/feedback/usage")!
        let boundary = "Boundary-\(UUID().uuidString)"
        let sem = DispatchSemaphore(value: 0)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + AppSession.bToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        var costs: [String] = ["", ""]
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error  in
            defer { sem.signal() }
              guard let data = data else {
                print(String(describing: error))
                return
              }
            
            
            if let use: UserUse = try? JSONDecoder().decode(UserUse.self, from: data)
            {
                costs[0] = use.data.cost
                costs[1] = use.message
            }
                                           
        }

        
        
        task.resume()
        sem.wait()
        return costs
    }
    
    static func isInPool() -> Bool
    {
        
        let url = URL(string: AppSession.apiURL + "/pool/status")!
        let boundary = "Boundary-\(UUID().uuidString)"
        let sem = DispatchSemaphore(value: 0)
        var inPool: Bool = false
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + AppSession.bToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error  in
            defer { sem.signal() }
              guard let data = data else {
                print(String(describing: error))
                return
              }
            
            
            if let status: PoolStatus = try? JSONDecoder().decode(PoolStatus.self, from: data)
            {
                inPool = status.open
            }
                                           
        }
        
        task.resume()
        sem.wait()
        return inPool
    }
}
