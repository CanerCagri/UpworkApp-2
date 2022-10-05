//
//  ViewController.swift
//  UpworkApp-2
//
//  Created by Caner Çağrı on 4.10.2022.
//

import UIKit


class MainViewController: UIViewController {
    
    let pickerButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pick Image", for: .normal)
        button.setTitleColor( .red, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemGray2
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupUI()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        pickerButton.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
    }
    
    @objc func buttonTaped() {
        print("click")
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
        view.addSubview(pickerButton)
        
        NSLayoutConstraint.activate([
            pickerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            pickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pickerButton.widthAnchor.constraint(equalToConstant: 100),
            pickerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        
        let detailVc = DetailViewController()
        detailVc.image = image
        dismiss(animated: true)
        navigationController?.pushViewController(detailVc, animated: true)
    }
}
