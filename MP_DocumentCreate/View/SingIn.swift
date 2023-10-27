//
//  ViewController.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 11.10.2023.
//
import UIKit
import Firebase

class SingIn: UIViewController, AlertProtocol {

    private let userNametext: UITextField = {
        let username = UITextField()
        username.placeholder = "UserName"
        username.textAlignment = .center
        username.translatesAutoresizingMaskIntoConstraints = false
        return username
    }()

    private let emailText: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.textAlignment = .center
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()

    private let passwordText: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.textAlignment = .center
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()

    private let singInButton: UIButton = {
        let button = UIButton()
        button.setTitle("SignIn", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(singInButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let singUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("SignUp", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(singUpButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(userNametext)
        view.addSubview(emailText)
        view.addSubview(passwordText)
        view.addSubview(singInButton)
        view.addSubview(singUpButton)

        NSLayoutConstraint.activate([
            userNametext.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNametext.heightAnchor.constraint(equalToConstant: 60),
            userNametext.widthAnchor.constraint(equalToConstant: 200),
            userNametext.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),

            emailText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailText.heightAnchor.constraint(equalToConstant: 60),
            emailText.widthAnchor.constraint(equalToConstant: 200),
            emailText.topAnchor.constraint(equalTo: userNametext.topAnchor, constant: 100),

            passwordText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordText.heightAnchor.constraint(equalToConstant: 60),
            passwordText.widthAnchor.constraint(equalToConstant: 200),
            passwordText.topAnchor.constraint(equalTo: emailText.topAnchor, constant: 100),

            singInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            singInButton.heightAnchor.constraint(equalToConstant: 50),
            singInButton.widthAnchor.constraint(equalToConstant: 100),
            singInButton.topAnchor.constraint(equalTo: passwordText.topAnchor, constant: 100),

            singUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            singUpButton.heightAnchor.constraint(equalToConstant: 50),
            singUpButton.widthAnchor.constraint(equalToConstant: 100),
            singUpButton.topAnchor.constraint(equalTo: passwordText.topAnchor, constant: 100)
        ])
    }

    @objc func singInButtonClicked(sender: UIButton!) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "ERROR")
                } else {
                    let feed = FeedVC()
                    feed.modalPresentationStyle = .fullScreen
                    self.present(feed, animated: true, completion: nil)
                }
            }
        } else {
            showAlert(title: "Error", message: "Email/Password is empty")
        }
    }

    @objc func singUpButtonClicked(sender: UIButton!) {
        if emailText.text != "" && passwordText.text != "" && userNametext.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "ERROR")
                } else {
                    let firestore = Firestore.firestore()
                    let userDictionary = ["email": self.emailText.text!, "username": self.userNametext.text!] as [String: Any]
                    firestore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            self.showAlert(title: "Error", message: "Network Error")
                        }
                    }
                    let feed = FeedVC()
                    feed.modalPresentationStyle = .fullScreen
                    self.present(feed, animated: true, completion: nil)
                }
            }
        } else {
            showAlert(title: "Error", message: "Email/Password/Username is empty")
        }
    }
}

    
    

