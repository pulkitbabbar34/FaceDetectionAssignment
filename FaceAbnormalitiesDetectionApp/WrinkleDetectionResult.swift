//
//  WrinkleDetectionResult.swift
//  FaceAbnormalitiesDetectionApp
//
//  Created by Pulkit Babbar on 29/06/24.
//

import Foundation
import UIKit

struct WrinkleDetectionResult {
    let image: UIImage
    let wrinkles: [CGRect] // Areas where wrinkles are detected
}
