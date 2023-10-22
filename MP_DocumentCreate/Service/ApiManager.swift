//
//  ApiManager.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 12.10.2023.
//

import Foundation
class APIManager : userService{ //protocol conform edildi ve func içinde yapılacak işlemler yazıldı
    
    func fetchUser(completion : @escaping (Result<[User],Error>) -> Void){
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                
                
                do {
                    let users = try? JSONDecoder().decode([User].self, from: data)
                    completion(.success(users!))
                    
                }
                catch{
                    completion(.failure(NSError()))
                }
                
            }
            
        }.resume()
    }
}
