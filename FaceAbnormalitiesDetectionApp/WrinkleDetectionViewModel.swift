//
//  WrinkleDetectionViewModel.swift
//  FaceAbnormalitiesDetectionApp
//
//  Created by Pulkit Babbar on 29/06/24.
//

import Foundation
import Vision
import CoreML
import Combine
import UIKit

class WrinkleDetectionViewModel {
    var detectionResultPublisher = PassthroughSubject<WrinkleDetectionResult, Never>()
    private var wrinkleDetectionModel: VNCoreMLModel?

    init() {
        // Load the Core ML model
        do {
            // Locate the model file in the app bundle
            if let modelURL = Bundle.main.url(forResource: "s4tf_model", withExtension: "mlmodelc") {
                let model = try WrinkleDetectionModel(contentsOf: modelURL)
                wrinkleDetectionModel = try VNCoreMLModel(for: model.model)
            } else {
                print("Model file not found in the app bundle.")
            }
        } catch {
            print("Failed to load Core ML model: \(error)")
        }
    }
    
    func detectWrinkles(in image: UIImage) {
        guard let cgImage = image.cgImage, let model = wrinkleDetectionModel else { return }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self else { return }
            guard let results = request.results as? [VNRecognizedObjectObservation], error == nil else {
                print("Wrinkle detection failed: \(String(describing: error))")
                return
            }

            var wrinkleRects = [CGRect]()
            for result in results {
                if let _ = result.labels.first(where: { $0.identifier == "wrinkle" }) {
                    let boundingBox = result.boundingBox
                    wrinkleRects.append(boundingBox)
                }
            }

            DispatchQueue.main.async {
                let detectionResult = WrinkleDetectionResult(image: image, wrinkles: wrinkleRects)
                self.detectionResultPublisher.send(detectionResult)
            }
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform request: \(error)")
        }
    }
}
