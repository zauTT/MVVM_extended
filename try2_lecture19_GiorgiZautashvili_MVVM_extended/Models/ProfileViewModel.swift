//
//  ProfileViewModel.swift
//  try2_lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 27.03.25.
//


import Foundation

class ProfileViewModel {
    var userProfile: UserProfile {
        didSet {
            onProfileUpdate?()
        }
    }
    
    var onProfileUpdate: (() -> Void)?
    
    init() {
        userProfile = UserProfile(name: "სახელი, გვარი", bio: "@iOS Dev", profileImage: "camera", coverImage: "camera")
    }
    
    func updateName(newName: String) {
        userProfile.name = "New Name"
    }
    
    func getProfileName() -> String {
        return userProfile.name
    }
    
}
