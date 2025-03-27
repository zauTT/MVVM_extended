import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()
    
    private let nameLabel = UILabel(frame: .zero)
    private let editButton = UIButton(frame: .zero)
    private let descriptionLbl = UILabel(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let emojis = UILabel(frame: .zero)
    private let cameraButton = UIButton(frame: .zero)
    private let xButton = UIButton(frame: .zero)
    private let favoritesButton = UIButton(frame: .zero)
    private let linkButton = UIButton(frame: .zero)
    
    private var name = "სახელი, გვარი"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 45/255, alpha: 1)
        setupUI()
        setupBackgroundImage()
        setupProfileImageView()
        setupBindings()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addNameLabel()
        configureNameLabel()
        addEditButton()
        configureEditButton()
        addDescriptionLbl()
        configureDescriptionLbl()
        addEmojis()
        configureEmojis()
        addCameraButton()
        configureCameraButton()
        addXButton()
        configureXButton()
        addFavoritesButton()
        configureFavoritesButton()
        addLinkButton()
        configureLinkButton()
    }
    
    private func setupBindings() {
        viewModel.onProfileUpdate = { [weak self] in
            self?.updateUI()
        }
        updateUI()
    }
    
    private func updateUI() {
        nameLabel.text = viewModel.getProfileName()
        imageView.image = UIImage(named: viewModel.userProfile.profileImage)
    }
    
    private func setupProfileImageView() {
        imageView.image = UIImage(named: "camera")
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicture))
            imageView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.18),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        imageView.layer.cornerRadius = 90
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 6
    }
    
    private func setupBackgroundImage() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 4))
        backgroundImageView.image = UIImage(named: "camera")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeCoverPhoto))
            backgroundImageView.addGestureRecognizer(tapGesture)
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
    
    private func addNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 80),
            nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -80)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .lightGray
        nameLabel.textAlignment = .center
        nameLabel.text = name
    }
    
    private func addEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editButton)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            editButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 5),
            editButton.widthAnchor.constraint(equalTo: nameLabel.heightAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureEditButton() {
        editButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 45/255, alpha: 1)
        editButton.layer.cornerRadius = 10
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @objc private func editButtonTapped() {
        let editProfileVC = EditProfileViewController(viewModel: viewModel)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    func updateName(_ newName: String) {
        name = newName
        nameLabel.text = newName
    }
    
    private func addDescriptionLbl() {
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLbl)
        
        NSLayoutConstraint.activate([
            descriptionLbl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descriptionLbl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            descriptionLbl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20)
            ])
        }
    
    private func configureDescriptionLbl() {
        descriptionLbl.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionLbl.textAlignment = .center
        descriptionLbl.textColor = .lightGray
        descriptionLbl.text = "@iOS Dev"
    }
    
    private func addEmojis() {
        emojis.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojis)
        
        NSLayoutConstraint.activate([
            emojis.topAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: 5),
            emojis.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            emojis.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20)
        ])
    }
    
    private func configureEmojis() {
        emojis.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        emojis.textAlignment = .center
        emojis.text = "🎶🏀📚"
    }
    
    private func addCameraButton() {
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: emojis.bottomAnchor, constant: 15),
            cameraButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 80),
            cameraButton.widthAnchor.constraint(equalToConstant: 55),
            cameraButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    private func configureCameraButton() {
        cameraButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 45/255, alpha: 1)
        cameraButton.layer.cornerRadius = 10
        
        let cameraImage = UIImage(systemName: "camera")?.withRenderingMode(.alwaysTemplate)
        cameraButton.setImage(cameraImage, for: .normal)
        cameraButton.tintColor = .white
    }
    
    private func addXButton() {
        xButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(xButton)
        
        NSLayoutConstraint.activate([
            xButton.topAnchor.constraint(equalTo: emojis.bottomAnchor, constant: 15),
            xButton.leftAnchor.constraint(equalTo: cameraButton.rightAnchor, constant: 7),
            xButton.heightAnchor.constraint(equalTo: cameraButton.heightAnchor),
            xButton.widthAnchor.constraint(equalTo: cameraButton.widthAnchor)
            ])
    }
    
    private func configureXButton() {
        xButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 45/255, alpha: 1)
        xButton.layer.cornerRadius = 10
        
        let xImage = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        xButton.setImage(xImage, for: .normal)
        xButton.tintColor = .white
    }
    
    private func addFavoritesButton() {
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoritesButton)
        
        NSLayoutConstraint.activate([
            favoritesButton.topAnchor.constraint(equalTo: emojis.bottomAnchor, constant: 15),
            favoritesButton.leftAnchor.constraint(equalTo: xButton.rightAnchor, constant: 7),
            favoritesButton.heightAnchor.constraint(equalTo: cameraButton.heightAnchor),
            favoritesButton.widthAnchor.constraint(equalTo: cameraButton.widthAnchor)
            ])
    }
    
    private func configureFavoritesButton() {
        favoritesButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 45/255, alpha: 1)
        favoritesButton.layer.cornerRadius = 10
        
        let heartImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        favoritesButton.setImage(heartImage, for: .normal)
        favoritesButton.tintColor = .white
    }
    
    private func addLinkButton() {
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(linkButton)
        
        NSLayoutConstraint.activate([
            linkButton.topAnchor.constraint(equalTo: emojis.bottomAnchor, constant: 15),
            linkButton.leftAnchor.constraint(equalTo: favoritesButton.rightAnchor, constant: 7),
            linkButton.heightAnchor.constraint(equalTo: cameraButton.heightAnchor),
            linkButton.widthAnchor.constraint(equalTo: cameraButton.widthAnchor),
            linkButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -80)
            ])
    }
    
    private func configureLinkButton() {
        linkButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 45/255, alpha: 1)
        linkButton.layer.cornerRadius = 10
        
        let linktImage = UIImage(systemName: "link")?.withRenderingMode(.alwaysTemplate)
        linkButton.setImage(linktImage, for: .normal)
        linkButton.tintColor = .white
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func changeProfilePicture() {
        presentImagePicker(forProfile: true)
    }
    
    @objc private func changeCoverPhoto() {
        presentImagePicker(forProfile: false)
    }
    
    private func presentImagePicker(forProfile: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.view.tag = forProfile ? 1 : 2
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            if picker.view.tag == 1 {
                self.imageView.image = selectedImage
            } else {
                if let backgroundView = self.view.subviews.first(where: { $0 is UIImageView && $0 != imageView }) as? UIImageView {
                    backgroundView.image = selectedImage
                }
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
