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
                               let email = document.get("email") as? String,
                               let date = document.get("date") as? Timestamp {
                                let documentGet = DocumentGet(email: email, ApiName: apiname, ApiUsername: apiusername, DocumentName: documentname, DocumentComment: documentcomment, Date: date.dateValue())
                                self.documentArray.append(documentGet)
                            }
                        }
                        self.FeedTableView.reloadData()
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
        DocumentSingleton.sharedDocument.eMail = chosenDocument?.email ?? ""
        DocumentSingleton.sharedDocument.ApiName = chosenDocument?.ApiName ?? ""
        DocumentSingleton.sharedDocument.ApiUsername = chosenDocument?.ApiUsername ?? ""
        DocumentSingleton.sharedDocument.DocumentName = chosenDocument?.DocumentName ?? ""
        DocumentSingleton.sharedDocument.DocumentComment = chosenDocument?.DocumentComment ?? ""
        let upload = UploadVC()
        upload.modalPresentationStyle = .fullScreen
        present(upload, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {//tableviewde cell silme için
        if editingStyle == .delete{//eğer editingstyle delete ise silicek
            let itemToRemove = self.documentArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)//tableviewi tableview.reloaddata() demek tüm verileri çeker bu sebepten sadece silinen cell kaldırıldı
            // Firebase'den de ilgili öğeyi silin
            let fireStore = Firestore.firestore()
            fireStore.collection("Document").whereField("DocumentName", isEqualTo: itemToRemove.DocumentName).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching document to delete: \(error)")
                } else {
                    // Eğer belirli bir belge bulunursa, onu silin
                    if let document = snapshot?.documents.first {
                        document.reference.delete() { error in
                            if let error = error {
                                print("Error deleting document: \(error)")
                            } else {
                                print("Document successfully deleted!")
                            }
                        }
                    }
                }
            }
        }
    }
   
}


