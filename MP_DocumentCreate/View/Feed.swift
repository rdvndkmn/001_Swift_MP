//
//  Feed.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 11.10.2023.
//

import Foundation
import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, AlertProtocol {
    let fireStoreDatabase = Firestore.firestore()
    var documentArray = [DocumentGet]()
    var chosenDocument: DocumentGet?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.pushViewController(SingIn(), animated: true)
        FeedTableView.delegate = self
        FeedTableView.dataSource = self
        setupNavigationBar()
        getDocumentFromFirebase()
        getUserInfo()
        view.addSubview(FeedTableView)
    }

    func setupNavigationBar() {
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 40))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOutButtonClicked))
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        navbar.items = [navItem]
        view.addSubview(navbar)
    }

    @objc func logOutButtonClicked() {
        do {
            try Auth.auth().signOut()
            let signIn = SingIn()
            signIn.modalPresentationStyle = .fullScreen
            present(signIn, animated: true, completion: nil)
        } catch {
            print("Error while signing out: \(error)")
        }
    }

    @objc func addButtonClicked() {
        DocumentSingleton.sharedDocument.ApiName = ""
        DocumentSingleton.sharedDocument.ApiUsername = ""
        DocumentSingleton.sharedDocument.DocumentName = ""
        DocumentSingleton.sharedDocument.DocumentComment = ""
        let upload = UploadVC()
        upload.modalPresentationStyle = .fullScreen
        present(upload, animated: true, completion: nil)
    }

    func getDocumentFromFirebase() {
        fireStoreDatabase.collection("Document").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                if let documents = snapshot?.documents {
                    self.documentArray.removeAll(keepingCapacity: false)
                    for document in documents {
                        if let apiname = document.get("Apiname") as? String,
                           let apiusername = document.get("Apiusername") as? String,
                           let documentcomment = document.get("DocumentComment") as? String,
                           let documentname = document.get("DocumentName") as? String,
                           let date = document.get("date") as? Timestamp {
                            let documentGet = DocumentGet(ApiName: apiname, ApiUsername: apiusername, DocumentName: documentname, DocumentComment: documentcomment, Date: date.dateValue())
                            self.documentArray.append(documentGet)
                        }
                    }
                    self.FeedTableView.reloadData()
                }
            }
        }
    }

    func getUserInfo() {
        if let currentUserEmail = Auth.auth().currentUser?.email {
            fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: currentUserEmail).getDocuments { (snapshot, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else if let document = snapshot?.documents.first,
                          let username = document.get("username") as? String {
                    UserSingleton.sharedUserInfo.email = currentUserEmail
                    UserSingleton.sharedUserInfo.username = username
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        FeedTableView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height)
    }

    private let FeedTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let document = documentArray[indexPath.row]
        content.text = document.Date.formatted()
        content.secondaryText = document.DocumentName
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenDocument = documentArray[indexPath.row]
        DocumentSingleton.sharedDocument.ApiName = chosenDocument?.ApiName ?? ""
        DocumentSingleton.sharedDocument.ApiUsername = chosenDocument?.ApiUsername ?? ""
        DocumentSingleton.sharedDocument.DocumentName = chosenDocument?.DocumentName ?? ""
        DocumentSingleton.sharedDocument.DocumentComment = chosenDocument?.DocumentComment ?? ""
        let upload = UploadVC()
        upload.modalPresentationStyle = .fullScreen
        present(upload, animated: true, completion: nil)
    }
}

