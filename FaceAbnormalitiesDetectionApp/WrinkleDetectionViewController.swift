//
//  WrinkleDetectionViewController.swift
//  FaceAbnormalitiesDetectionApp
//
//  Created by Pulkit Babbar on 29/06/24.
//

import UIKit
import Combine

class WrinkleDetectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imageView: UIImageView!
    private var detectButton: UIButton!
    private var viewModel = WrinkleDetectionViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        detectButton = UIButton(type: .system)
        detectButton.setTitle("Select Image", for: .normal)
        detectButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        detectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detectButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            detectButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            detectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.detectionResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.displayDetectionResult(result)
            }
            .store(in: &cancellables)
    }
    
    @objc private func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            viewModel.detectWrinkles(in: selectedImage)
        }
    }
    
    private func displayDetectionResult(_ result: WrinkleDetectionResult) {
        imageView.image = result.image
        
        // Clear previous wrinkle overlays
        imageView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add wrinkle overlays
        for wrinkle in result.wrinkles {
            let wrinkleView = UIView(frame: wrinkle)
            wrinkleView.layer.borderColor = UIColor.red.cgColor
            wrinkleView.layer.borderWidth = 2
            imageView.addSubview(wrinkleView)
        }
    }
}
