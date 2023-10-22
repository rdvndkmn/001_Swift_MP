//
//  FeedViewModel.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 12.10.2023.
//
/*
import Foundation

class UploadViewModel{
    
    private let userservice : userService //viev modeller istendiğinde Userservice istenicek
    
    init(userservice: userService) {
        self.userservice = userservice
    }
    
    weak var output : UploadViewModelOutput?// weak var bu değişkene erişildiğinde inizilation edilicek demek
    
    
    
    func fetchUsers(){
        
        userservice.fetchUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.output?.updateView(name: user.name, username: user.username, email: user.email)//bu şekilde kullanma sebebi viewcontrollerda delegate olarak kullanabilmek
            case .failure(_):
                self?.output?.updateView(name: "no user", username: "", email: "")

            }
        }
      
    }
    
}
*/
