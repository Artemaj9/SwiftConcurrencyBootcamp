//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Artem on 05.07.2023.
//

import SwiftUI

class DownloadImageAsyncImageLoader {
    
    let url = URL(string: "https://sample-videos.com/img/Sample-jpg-image-50kb.jpg")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?)->() ) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
                completionHandler(image, error)
        }
        .resume()
        
    }
}

    class DownLoadImageAsyncViewModel: ObservableObject {
        
        @Published var image: UIImage? = nil
        let loader = DownloadImageAsyncImageLoader()
        
        func fetchImage() {
            loader.downloadWithEscaping {[weak self] image, error in
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
struct DownloadImageAsync: View {
    
    @StateObject private var viewModel = DownLoadImageAsyncViewModel()
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .background(Color.blue)
            }
        }
        .onAppear {
            viewModel.fetchImage()

                }
            }
        }


struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}
