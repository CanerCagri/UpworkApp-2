//
//  ViewController.swift
//  UpworkApp-2
//
//  Created by Caner Çağrı on 4.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    let imageView: UIImageView = {
        var view = UIImageView()
        view.image = UIImage(systemName: "circle")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled =  true
        view.contentMode = .scaleAspectFit
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
        configureViewController()
        setupUI()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        pickerButton.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        scrollView.maximumZoomScale = 10.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(pickerButton)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            pickerButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            pickerButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50),
            pickerButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50),
            pickerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        self.imageView.image = image
        self.dismiss(animated: true)
        self.scrollView.backgroundColor = UIColor(patternImage: imageView.image!)

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = scrollView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.addSubview(blurEffectView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(pickerButton)
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height

                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height

                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))

                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
