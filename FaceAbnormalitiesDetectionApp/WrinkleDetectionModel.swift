//
//  WrinkleDetectionModel.swift
//  FaceAbnormalitiesDetectionApp
//
//  Created by Pulkit Babbar on 29/06/24.
//

import CoreML
import Foundation
import UIKit

@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
@objc(WrinkleDetectionModel) public class WrinkleDetectionModel : NSObject {
    var model: MLModel

    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    // Other initializers and methods...
}
