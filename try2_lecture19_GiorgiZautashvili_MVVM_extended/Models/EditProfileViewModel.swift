//
//  EditProfileViewModel.swift
//  try2_lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 27.03.25.
//


import Foundation

class EditProfileViewModel {
    
    private var profileViewModel: ProfileViewModel
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
    }
    
    func saveNewName(_ name: String) {
        profileViewModel.updateName(newName: name)
    }
}
