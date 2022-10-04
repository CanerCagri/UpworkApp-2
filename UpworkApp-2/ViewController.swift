//
//  ViewController.swift
//  UpworkApp-2
//
//  Created by Caner Çağrı on 4.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        var view = UIImageView()
        view.image = UIImage(systemName: "circle")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    let pickerButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pick Image", for: .normal)
        button.setTitleColor( .red, for: .normal)
        button.backgroundColor = .systemGray2
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pickerButton.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        setupUI()
    }
    
    @objc func buttonTaped() {
        showImagePickerOptions()
    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagPickerController = UIImagePickerController()
        imagPickerController.sourceType = sourceType
        return imagPickerController
    }
    
    func showImagePickerOptions() {
        let alertVc = UIAlertController(title: "Pick A Photo", message: "Choose a Photo", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            
            let cameraPicker = self.imagePicker(sourceType: .camera)
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVc.addAction(cameraAction)
        alertVc.addAction(libraryAction)
        alertVc.addAction(cancelAction)
        self.present(alertVc, animated: true)
    }
    
    func setupUI() {
        view.addSubview(imageView)
        view.addSubview(pickerButton)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            pickerButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            pickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            pickerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            pickerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        self.imageView.image = image
        self.dismiss(animated: true)
    }
}

