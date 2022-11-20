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
