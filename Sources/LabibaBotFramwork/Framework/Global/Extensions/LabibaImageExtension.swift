//
//  LabibaImageExtension.swift
//  LabibaBotFramwork
//
//  Created by Ahmad Sbeih on 18/03/2025.
//

import Foundation

extension UIImage{
    static func getImageFromUrl(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

