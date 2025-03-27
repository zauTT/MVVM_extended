import UIKit

class EditProfileViewController: UIViewController {
    
    private let viewModel: EditProfileViewModel
    private let nameTextField = UITextField()
    private let saveButton = UIButton(type: .system)
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = EditProfileViewModel(profileViewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.title = "Edit Profile"
        
        setupUI()
    }
    
    private func setupUI() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Enter your name"
        nameTextField.textAlignment = .center
        nameTextField.borderStyle = .roundedRect
        nameTextField.font = .systemFont(ofSize: 17, weight: .medium)
        self.view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20),
            nameTextField.widthAnchor.constraint(equalToConstant: 250),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = .white
        saveButton.backgroundColor = .darkGray
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func saveButtonTapped() {
        let newName = nameTextField.text ?? ""
        
        if newName.count < 2 {
            showAlert(message: "Please enter at least 2 characters")
        }
        
        if let navigationController = navigationController,
           let profileVC = navigationController.viewControllers.first(where: {$0 is ProfileViewController}) as? ProfileViewController {
            profileVC.updateName(newName)
        }
        navigationController?.popViewController(animated: true)
    }
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
