//
//  ViewController.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 11.10.2023.
//

import UIKit
import Firebase

class SingIn: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private let UserNametext : UITextField = {
         let username = UITextField()
         username.placeholder = "UserName"
         username.textAlignment = .center
         username.translatesAutoresizingMaskIntoConstraints = false
         return username
     }()
     
     private let EmailText : UITextField = {
          let email = UITextField()
         email.placeholder = "Email"
         email.textAlignment = .center
         email.translatesAutoresizingMaskIntoConstraints = false
          return email
      }()
     
     private let PasswordText : UITextField = {
          let password = UITextField()
         password.placeholder = "Password"
         password.textAlignment = .center
         password.translatesAutoresizingMaskIntoConstraints = false
          return password
      }()
     
     private let SingInButton : UIButton = {
         let button = UIButton()
         button.setTitle("SingIn", for: .normal)
         button.setTitleColor(.blue, for: .normal)
         button.layer.cornerRadius = 25
         button.backgroundColor = .green
         button.addTarget(self, action: #selector(SingInButtonClicked), for: .touchUpInside)
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()
     
     private let SingUpButton : UIButton = {
         let button = UIButton()
         button.setTitle("SingUp", for: .normal)
         button.setTitleColor(.blue, for: .normal)
         button.layer.cornerRadius = 25
         button.backgroundColor = .green
         button.addTarget(self, action: #selector(SingUpButtonClicked), for: .touchUpInside)
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()
     
     private func setupView(){
         view.backgroundColor = .white
         view.addSubview(UserNametext)
         view.addSubview(EmailText)
         view.addSubview(PasswordText)
         view.addSubview(SingInButton)
         view.addSubview(SingUpButton)

         NSLayoutConstraint.activate([
             
             UserNametext.centerXAnchor.constraint(equalTo: view.centerXAnchor),//x ekseninde ortaya koy
             UserNametext.heightAnchor.constraint(equalToConstant: 60),// yüksekliği belirledik
             UserNametext.widthAnchor.constraint(equalToConstant: 200),// genişliği belirledik
             UserNametext.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),//ekranın en üstünde ne kadar boşluk olucak
         
             EmailText.centerXAnchor.constraint(equalTo: view.centerXAnchor),//x ekseninde ortaya koy
             EmailText.heightAnchor.constraint(equalToConstant: 60),// yüksekliği belirledik
             EmailText.widthAnchor.constraint(equalToConstant: 200),// genişliği belirledik
             EmailText.topAnchor.constraint(equalTo: UserNametext.topAnchor, constant: 100),//ekranın en üstünde ne kadar boşluk olucak
         
             PasswordText.centerXAnchor.constraint(equalTo: view.centerXAnchor),//x ekseninde ortaya koy
             PasswordText.heightAnchor.constraint(equalToConstant: 60),// yüksekliği belirledik
             PasswordText.widthAnchor.constraint(equalToConstant: 200),// genişliği belirledik
             PasswordText.topAnchor.constraint(equalTo: EmailText.topAnchor, constant: 100),//ekranın en üstünde ne kadar boşluk olucak
             
             SingInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),//x ekseninde ortaya koy
             SingInButton.heightAnchor.constraint(equalToConstant: 50),// yüksekliği belirledik
             SingInButton.widthAnchor.constraint(equalToConstant: 100),// genişliği belirledik
             SingInButton.topAnchor.constraint(equalTo: PasswordText.topAnchor, constant: 100),
             
             SingUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
             SingUpButton.heightAnchor.constraint(equalToConstant: 50),// yüksekliği belirledik
             SingUpButton.widthAnchor.constraint(equalToConstant: 100),// genişliği belirledik
             SingUpButton.topAnchor.constraint(equalTo: PasswordText.topAnchor, constant: 100)
    
         ])
         
     }
     
     @objc func SingInButtonClicked(sender: UIButton!){
     
         if EmailText.text != "" && PasswordText.text != ""{
             
             Auth.auth().signIn(withEmail: EmailText.text!, password: PasswordText.text!) { authdata, error in // mail ve şifre kontrolü yaptığımız firebase kodu
                 if error  != nil{
                     self.makeAlert(title: "Error", message: error?.localizedDescription ?? "ERROR")
                 }
                 else{
                     
                 
                     
                
                     let feed = FeedVC()
                     feed.modalPresentationStyle = .fullScreen
                     self.present(feed, animated: true, completion: nil)
                 
                 }
             }

             
         }
         else{
             makeAlert(title: "error", message: "email/password is null")
         }
       
     }
     
     
     
     @objc func SingUpButtonClicked(sender: UIButton!){
     
         if EmailText.text != "" && PasswordText.text != "" && UserNametext.text != ""{
             Auth.auth().createUser(withEmail: EmailText.text!, password: PasswordText.text!) { authdata, error in// kullanıcı oluşturmak için gerekli metod
                 if error  != nil{
                     self.makeAlert(title: "Error", message: error?.localizedDescription ?? "ERROR")//error mesajı firebasein kendi mesajını yazmak için
                 }
                 else{
                     
                     let fireStore = Firestore.firestore()//firesotore değişkeni oluşturduk
                                         
                     let userDictionary = ["email" : self.EmailText.text!,"username": self.UserNametext.text!] as [String : Any]//aldığımız verileri keylerle oluşturduk
                                         
                     fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in//database collection oluşturduk ve içine aldığımız verileri koyduk
                         if error != nil {
                             self.makeAlert(title: "error", message: "Networkerror")
                         }
                     }
                         let feed = FeedVC()
                         feed.modalPresentationStyle = .fullScreen
                         self.present(feed, animated: true, completion: nil)
                 }
             }
         }
         else{
             makeAlert(title: "error", message: "email/password is null")
         }
                 
     }
     
     @objc func makeAlert(title: String,message:String){
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
         let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
         alert.addAction(okButton)
         self.present(alert, animated: true,completion: nil)
     }
    
}

    
    

