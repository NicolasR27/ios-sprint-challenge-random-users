//
//  UserController.swift
//  Random Users
//
// // Created by Nicolas Rios on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    private let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    private (set) var users: [User] = []
    var largeImageCache = Cache<Int, Data>()
    
    func fetchUsers(completion: @escaping (Error?) -> ()) {
        guard let url = baseUrl else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("FetchUsers Response: \(response.statusCode)")
        }
            
            if let error = error {
                print("fetchUsers Error: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { return }
            print(data)
            
            do {
                let decoded = try JSONDecoder().decode(Results.self, from: data)
                self.users = decoded.results
                completion(nil)
            }catch {
                print("Error decoding json: \(error)")
                completion(error)
            }
        }.resume()
    }
}
