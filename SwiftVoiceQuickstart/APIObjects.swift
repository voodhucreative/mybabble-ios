//
//  APIObjects.swift
//  SwiftVoiceQuickstart
//
//  Created by Ford Walton on 09/12/2020.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation

struct encoder
{
    static func encodeData(parameters: [[String: Any]], boundary: String) -> String
    {
        var body: String = ""
        
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        return body
    }
}

struct UserCreds: Decodable
{
    let id: Int
    let username:  String?
    let email: String
//    let is_verified: Bool
}

struct UserToken: Decodable
{
    let token: String
}

struct LoginReponse: Decodable
{
    let data: UserCreds
    let meta: UserToken
}

struct ErrorResponse: Decodable
{
    let message: String
    let errors: SubErrors
}

struct SubErrors: Decodable
{
    let email: [String]?
    let password: [String]?
    let username: [String]?
}

struct PoolStatus: Decodable
{
    let open: Bool
}

struct UserUse: Decodable
{
    let data: Cost
    let message: String
}

struct Cost: Decodable
{
    let cost: String
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
