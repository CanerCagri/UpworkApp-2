//
//  ViewController.swift
//  UpworkApp-2
//
//  Created by Caner Çağrı on 4.10.2022.
//

import UIKit


class DetailViewController: UIViewController {
    
    let scrollView = UIScrollView()
    var image = UIImage(named: "circle")
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
    
    let imageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled =  true
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12
        return view
    }()
    
    let reverseButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "goforward"), for: .normal)
        button.setTitle("Revert To Originial", for: .normal)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let saveButton: UIButton = {
        var button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupUI()
        rightBarButton()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        reverseButton.addTarget(self, action: #selector(reverseButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        scrollView.maximumZoomScale = 10.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        reverseButton.isHidden = true
        loadImageAndBlur()
    }
    
    func loadImageAndBlur() {
        imageView.image = image
        scrollView.backgroundColor = UIColor(patternImage: imageView.image!)
        
        blurEffectView.frame = scrollView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.addSubview(blurEffectView)
        scrollView.addSubview(imageView)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y:
                                    imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func rightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Background", style: .done, target: self, action: #selector(rightBarButtonTapped))
    }
    
    @objc func rightBarButtonTapped() {
        reverseButton.isHidden = false
        navigationItem.rightBarButtonItem = nil
        imageView.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
    
    @objc func reverseButtonTapped() {
        rightBarButton()
        scrollView.addSubview(blurEffectView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(saveButton)
    }
    
    @objc func saveButtonTapped() {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let alertVc = UIAlertController(title: "Succesfully Added To Your Library", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        alertVc.addAction(okAction)
        present(alertVc, animated: true)
        
    }
    
    func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(saveButton)
        scrollView.addSubview(imageView)
        scrollView.addSubview(reverseButton)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            reverseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reverseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
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
