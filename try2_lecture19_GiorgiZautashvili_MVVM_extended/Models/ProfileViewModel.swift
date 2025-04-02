//
//  ProfileViewModel.swift
//  try2_lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 27.03.25.
//

import Foundation
import UIKit

class ProfileViewModel {
    
    var userProfile: UserProfile {
        didSet {
            onProfileUpdate?()
        }
    }
    
    var onProfileUpdate: (() -> Void)?
    
    init() {
        userProfile = UserProfile(name: UserDefaults.standard.string(forKey: "profileName") ?? "Default Name", bio: "Default_bio", profileImage: "Default_image", coverImage: "Default_cover")
    }
    
    func updateName(newName: String) {
        userProfile.name = newName
        saveProfileName()
    }
    
    func getProfileName() -> String {
        return UserDefaultManager.shared.getName(forKey: UserDefaultKeys.name) ?? "სახელი, გვარი"
    }
    
    func saveProfileImage(_ image: UIImage) {
        UserDefaultManager.shared.saveImage(image, forKey: UserDefaultKeys.profilePicture)
    }
    
    func saveCoverImage(_ image: UIImage) {
        UserDefaultManager.shared.saveImage(image, forKey: UserDefaultKeys.coverPhoto)
    }
    
    func getProfileImage() -> UIImage? {
        return UserDefaultManager.shared.getImage(forKey: UserDefaultKeys.profilePicture)
    }
    
    func getCoverImage() -> UIImage? {
        return UserDefaultManager.shared.getImage(forKey: UserDefaultKeys.coverPhoto)
    }
    
    func removeProfileImage() {
        UserDefaultManager.shared.removeImage(forKey: UserDefaultKeys.profilePicture)
    }
    
    func removeCoverImage() {
        UserDefaultManager.shared.removeImage(forKey: UserDefaultKeys.coverPhoto)
    }
    
    func saveProfileName() {
        UserDefaultManager.shared.saveName(userProfile.name, forKey: UserDefaultKeys.name)
    }
}
