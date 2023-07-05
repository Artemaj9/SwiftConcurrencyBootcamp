//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Artem on 04.07.2023.
//
//async await

import SwiftUI

//do-catch
//try
//throws (rethrows)

class DoCatchTryThrowsNootcampDataManager {
    
    let isActive: Bool = false
    
   /* Version 1
    func getTitle() -> String? {
        if isActive{
            return "NEW TEXT"
        } else {
            return nil
        }
    }
    */
    
    /*  Version 2
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return("NEW TEXT", nil)
        } else {
            return(nil, URLError(.badURL))
        }
    }
     */
    
    /*
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT")
        } else {
            return .failure(URLError(.badURL))
        }
        
    }
     */
    func getTitle3() throws -> String {
        if isActive {
            return "NEW TEXT"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final TEXT"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
    
    
class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsNootcampDataManager()  //dependency injection!!!
    
    func fetchTitle() {
        /* Version 1
         let newTitle = manager.getTitle()
         if let newTitle = newTitle {
         self.text = newTitle
         }
         */
        /* Version 2
         let returnedValue = manager.getTitle()
         if let newTitle = returnedValue.title {
         self.text = newTitle
         } else if let error = returnedValue.error {
         self.text = error.localizedDescription
         }
         */
        
        /* Version 3
         let result = manager.getTitle2()
         switch result {
         case .success(let newTitle):
         self.text = newTitle
         case .failure(let error):
         self.text = error.localizedDescription
         
         }
         */
       
       // Version 4
        
        //try if this throw error we leave do scope
        //try? if this throw error we doesn't leave do scope
        //try! explicit unwrap - very dangerous!!!
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
           // self.text = newTitle
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch {  // or let error
            self.text = error.localizedDescription
        }
        
        
       /* // Version 5 (if you don't care about the error)
        let newTitle = try? manager.getTitle3()
        if let newTitle = newTitle {
            self.text = newTitle
        }
         */
    }
}
    
    struct DoCatchTryThrowsBootcamp: View {
        
        @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
        var body: some View {
            Text(viewModel.text)
                .frame(width: 300, height: 300)
                .background(Color.blue)
                .onTapGesture {
                    viewModel.fetchTitle()
                }
        }
        
    }
    

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
