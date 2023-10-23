//
//  UserSingleton.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 22.10.2023.
//

import Foundation
class UserSingleton {//singleton bir sınıf var bu sınıftan bir obje oluşturulabilir
    
    static let sharedUserInfo = UserSingleton()//bu sınıftan oluşturulan tek obje
    
    var username = ""
    var email = ""
    private init() {
        
    }
    
    
}
