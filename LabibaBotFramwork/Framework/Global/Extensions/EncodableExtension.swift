//
//  EncodableExtension.swift
//  Royal Jordanian
//
//  Created by Abdulrahman Qasem on 01/11/2022.
//

import Foundation
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}

extension Dictionary where Key == String, Value == Any {
    func toBase64() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let base64String = jsonData.base64EncodedString()
            return base64String
        } catch {
            print(error)
            return nil
        }
    }
}
