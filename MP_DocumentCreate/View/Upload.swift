//
//  Upload.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 11.10.2023.

import Foundation
import UIKit
import Firebase

class UploadVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, AlertProtocol {

    
    let fireStoreDatabase = Firestore.firestore()
    var selectedDocument: DocumentGet?
    var chosenName = ""
    var selectedName: String = ""
    var selectedUsername: String = ""
    var users: [User] = []
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trigger()
        setupNavigationBar()
        fetchUsers()
        view.backgroundColor = .white
        self.navigationController?.pushViewController(FeedVC(), animated: true)
        DataTableView.delegate = self
        DataTableView.dataSource = self
        setupView()
    }
    func setupNavigationBar() {
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 40))
        navbar.backgroundColor = UIColor.red
        navbar.delegate = self
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButton))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = backButton
        navItem.rightBarButtonItem = saveButton
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
        if self.number == 1{
            saveButton.isHidden = true
        }
        else{
            saveButton.isHidden = false
        }
    }
    func fetchUsers() {
        let apiManager = APIManager()
        apiManager.fetchUser { result in
            switch result {
                case .success(let fetchedUsers):
                    self.users = fetchedUsers
                    DispatchQueue.main.async {
                        self.DataTableView.reloadData()
                    }
                case .failure(let error):
                    print("Hata: \(error)")
            }
        }
    }

    @objc func saveButton() {
        let fireStore = Firestore.firestore()
        let fireStorePost = ["email": Auth.auth().currentUser?.email! ?? "", "DocumentName": self.DocumentNameText.text ?? "",
                             "DocumentComment": self.DocumentCommentText.text!,"Apiname": selectedName,
                             "Apiusername": selectedUsername, "date":FieldValue.serverTimestamp()] as [String : Any]

        fireStore.collection("Document").addDocument(data: fireStorePost) { (error) in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription)
            } else {
                let feed = FeedVC()
                feed.modalPresentationStyle = .fullScreen
                self.present(feed, animated: true, completion: nil)
            }
        }

    }

    @objc func backButton() {
        let feedvc = FeedVC()
        feedvc.modalPresentationStyle = .fullScreen
        present(feedvc, animated: true, completion: nil)
    }

    private let DocumentNameText: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Document Name"
        textfield.textAlignment = .center
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    private let DocumentCommentText: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Document Comment"
        textfield.textAlignment = .center
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    private let DataTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

    private let UsernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.isHidden = true
        return label
    }()

    private let DocumentNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "documentname"
        label.isHidden = true
        return label
    }()

    private let DocumentCommentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "documentcomment"
        label.isHidden = true
        return label
    }()

    private let DataNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dataname"
        label.isHidden = true
        return label
    }()

    private let DataCommentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "datacomment"
        label.isHidden = true
        return label
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let user = users[indexPath.row]
        content.text = user.name
        content.secondaryText = user.username
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedName = users[indexPath.row].name
        self.selectedUsername = users[indexPath.row].username
    }



    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(UsernameLabel)
        view.addSubview(DocumentNameLabel)
        view.addSubview(DocumentCommentLabel)
        view.addSubview(DataNameLabel)
        view.addSubview(DataCommentLabel)
        view.addSubview(DocumentNameText)
        view.addSubview(DocumentCommentText)
        view.addSubview(DataTableView)
        let width = view.bounds.width
        //let height = view.bounds.height
        
        NSLayoutConstraint.activate([
            UsernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            UsernameLabel.heightAnchor.constraint(equalToConstant: 60),
            UsernameLabel.widthAnchor.constraint(equalToConstant: 200),
            UsernameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            DocumentNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DocumentNameLabel.heightAnchor.constraint(equalToConstant: 60),
            DocumentNameLabel.widthAnchor.constraint(equalToConstant: 200),
            DocumentNameLabel.topAnchor.constraint(equalTo: UsernameLabel.topAnchor, constant: 100),
            
            DocumentCommentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DocumentCommentLabel.heightAnchor.constraint(equalToConstant: 60),
            DocumentCommentLabel.widthAnchor.constraint(equalToConstant: 200),
            DocumentCommentLabel.topAnchor.constraint(equalTo: DocumentNameLabel.topAnchor, constant: 100),
            
            DataNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DataNameLabel.heightAnchor.constraint(equalToConstant: 60),
            DataNameLabel.widthAnchor.constraint(equalToConstant: 200),
            DataNameLabel.topAnchor.constraint(equalTo: DocumentCommentLabel.topAnchor, constant: 100),
            
            DataCommentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DataCommentLabel.heightAnchor.constraint(equalToConstant: 60),
            DataCommentLabel.widthAnchor.constraint(equalToConstant: 200),
            DataCommentLabel.topAnchor.constraint(equalTo: DataNameLabel.topAnchor, constant: 100),
            
            DocumentNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DocumentNameText.heightAnchor.constraint(equalToConstant: 60),
            DocumentNameText.widthAnchor.constraint(equalToConstant: 200),
            DocumentNameText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            DocumentCommentText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DocumentCommentText.heightAnchor.constraint(equalToConstant: 60),
            DocumentCommentText.widthAnchor.constraint(equalToConstant: 200),
            DocumentCommentText.topAnchor.constraint(equalTo: DocumentNameText.topAnchor, constant: 100),
            
            DataTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DataTableView.heightAnchor.constraint(equalToConstant: 550),
            DataTableView.widthAnchor.constraint(equalToConstant: width),
            DataTableView.topAnchor.constraint(equalTo: DocumentCommentText.topAnchor, constant: 100)
        ])
    }

    func trigger() {
        let name = DocumentSingleton.sharedDocument.ApiName
        if name != "" {
            self.DocumentNameText.isHidden = true
            self.DocumentCommentText.isHidden = true
            self.DataTableView.isHidden = true
            self.DocumentNameLabel.isHidden = false
            self.DocumentCommentLabel.isHidden = false
            self.DataNameLabel.isHidden = false
            self.DataCommentLabel.isHidden = false
            self.UsernameLabel.isHidden = false
            self.number = 1
            self.UsernameLabel.text = DocumentSingleton.sharedDocument.eMail
            self.DocumentNameLabel.text = DocumentSingleton.sharedDocument.DocumentName
            self.DocumentCommentLabel.text = DocumentSingleton.sharedDocument.DocumentComment
            self.DataNameLabel.text = DocumentSingleton.sharedDocument.ApiName
            self.DataCommentLabel.text = DocumentSingleton.sharedDocument.ApiUsername
        } else {
            self.DocumentNameText.isHidden = false
            self.DocumentCommentText.isHidden = false
            self.DataTableView.isHidden = false
            self.DocumentNameLabel.isHidden = true
            self.DocumentCommentLabel.isHidden = true
            self.DataNameLabel.isHidden = true
            self.DataCommentLabel.isHidden = true
            self.UsernameLabel.isHidden = true
        }
    }
}
