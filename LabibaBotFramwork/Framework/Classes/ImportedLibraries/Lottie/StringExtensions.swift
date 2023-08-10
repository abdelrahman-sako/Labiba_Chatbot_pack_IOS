//
//  StringExtensions.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/25/19.
//

import Foundation
import CoreGraphics

extension String {
  
  func hexColorComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    
    var cString:String = trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
      return (red: 0, green: 0, blue: 0)
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return (red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0)
  }
}

extension String {

    func fromBase64() -> String? {
        
        guard let data = Data(base64Encoded: self) else {
            return self
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}

extension String: ParameterEncoding {

     func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }

}
