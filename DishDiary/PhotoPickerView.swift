//
//  PhotoPickerView.swift
//  DishDiary
//
//  Created by Daria Yatsyniuk on 12.08.2025.
//
import PhotosUI
import SwiftUI

struct PhotoPickerView: UIViewControllerRepresentable {
    let didPickImage: (UIImage?) -> Void

    init(didPickImage: @escaping (UIImage?) -> Void) {
        self.didPickImage = didPickImage
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(didPickImage: didPickImage)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let didPickImage: (UIImage?) -> Void

        init(didPickImage: @escaping (UIImage?) -> Void) {
            self.didPickImage = didPickImage
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.didPickImage(image as? UIImage)
                }
            }
        }
    }
}

#Preview {
    PhotoPickerView { image in
        print("image")
    }
}
