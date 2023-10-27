//
//  FeedViewModel.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 12.10.2023.
//
import Foundation

protocol UserViewModelProtocol : AnyObject{
    func updateView(name : String, username : String, email : String)
}

class UserViewModel{
    
    private let userservice : userService //viev modeller istendiğinde Userservice istenicek
    
    weak var output : UserViewModelProtocol?// weak var bu değişkene erişildiğinde inizilation edilicek demek
    
    init(userservice: userService) {
        self.userservice = userservice
    }
    
    func fetchUsers() {
        userservice.fetchUser { [weak self] result in
            switch result {
            case .success(let users):
                for user in users {
                    self?.output?.updateView(name: user.name, username: user.username, email: user.email)
                }
            case .failure(_):
                self?.output?.updateView(name: "no user", username: "", email: "")
            }
        }
    }
    
}




