//
//  Extension.swift
//  DishDiary
//
//  Created by Daria Yatsyniuk on 20.08.2025.
//

import Foundation
import SwiftUI

extension UIImage {
    static func fromDocuments(named imageName: String) -> UIImage? {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent(imageName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}
