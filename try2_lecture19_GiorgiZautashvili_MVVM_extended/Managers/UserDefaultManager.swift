//
//  UserDefaultManager.swift
//  lecture21_GiorgiZautashvili_UserDefaults
//
//  Created by Giorgi Zautashvili on 01.04.25.
//

import UIKit

class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    func saveName(_ name: String, forKey key: String) {
        UserDefaults.standard.set(name, forKey: key)
    }
    
    func getName(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func getImage(forKey key: String) -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: key) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func removeImage(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
