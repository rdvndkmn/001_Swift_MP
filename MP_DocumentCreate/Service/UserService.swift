//
//  UserService.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 12.10.2023.
//

import Foundation

protocol userService{ //userservice protocol olduğu için viewmodelda kullanılabilir 
    func fetchUser(completion : @escaping (Result<[User],Error>) -> Void)
}
