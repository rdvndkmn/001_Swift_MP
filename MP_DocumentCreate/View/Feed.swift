//
//  Feed.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 11.10.2023.
//

import Foundation
import UIKit
import Firebase

class FeedVC : UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationBarDelegate {
   
    let fireStoreDatabase = Firestore.firestore()
    var documentArray = [DocumentGet]()
    var chosenDocument : DocumentGet?
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.pushViewController(SingIn(), animated:true)
                
        FeedTableView.delegate = self
        FeedTableView.dataSource = self
        
        navBar()

        
        getDocumentFromFirebase()
        getUserInfo()
        view.addSubview(FeedTableView)

        
    }
    
    func getDocumentFromFirebase() {
          fireStoreDatabase.collection("Document").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in//Verileri çekmek
              if error != nil {
                  self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
              } else {
                  if snapshot?.isEmpty == false && snapshot != nil {
                      self.documentArray.removeAll(keepingCapacity: false)
                      for document in snapshot!.documents {
                          
                          //let documentId = document.documentID
                          
                          if let apiname = document.get("Apiname") as? String{
                              if let apiusername = document.get("Apiusername") as? String{
                                  if let documentcomment = document.get("DocumentComment") as? String{
                                      if let documentname = document.get("DocumentName") as? String{
                                          if let date = document.get("date") as? Timestamp{
                                              let documentg = DocumentGet(ApiName: apiname, ApiUsername: apiusername, DocumentName: documentname, DocumentComment: documentcomment, Date: date.dateValue())
                                              self.documentArray.append(documentg)
                                          }
                                      }
                                  }
                              }
                          }
                      }
                      self.FeedTableView.reloadData()
                  }
                  
              }
          }
      }
      func getUserInfo() {
          
          fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in//wherefield eşit olanı getir demek için //veriyi çekiyoruz
              if error != nil {
                  self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
              } else {
                  if snapshot?.isEmpty == false && snapshot != nil {
                      for document in snapshot!.documents {
                          if let username = document.get("username") as? String {
                              UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                              UserSingleton.sharedUserInfo.username = username
                          }
                      }
                  }
              }
          }
          
      }
    
    func navBar(){
        
        let navbar = UINavigationBar(frame: CGRect(x:0 , y: 50, width: view.bounds.width, height: 40))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self

        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(LogOutnClicked))
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked))

        navbar.items = [navItem]

        view.addSubview(navbar)
    }

    @objc func LogOutnClicked(sender: UIButton!){
        
        do{
            try Auth.auth().signOut()//hata fırlattığı için do try catch de yapılıyor
            let singin = SingIn()
            singin.modalPresentationStyle = .fullScreen
            present(singin, animated: true, completion: nil)
        }
        catch{
            print("error")
        }

    }
 
    @objc func addClicked(){
       // let service = APIManager()
        //let viewmodel = UploadViewModel(userservice: service)
        let upload = UploadVC()
        upload.modalPresentationStyle = .fullScreen
        present(upload, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {//oluşturulan objeler size ve kordinat belirlemek için
        super.viewDidLayoutSubviews()
        //FeedTableView.frame = view.bounds//ekran ne kadarsa tableview o kadar ölçeklenecek
        FeedTableView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height)
    }
    
   
    
    private let FeedTableView : UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()//hücreyi oluşturduk
        var content = cell.defaultContentConfiguration()//content(içerik) oluşturduk
        let doc = documentArray[indexPath.row]
        content.text = doc.Date.formatted()
        content.secondaryText = doc.DocumentName
        cell.contentConfiguration = content//cellin content ayarını contente eşledik
        return cell
        
    }
    
    @objc func makeAlert(title: String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true,completion: nil)
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenDocument = self.documentArray[indexPath.row]
        DocumentSingleton.sharedDocument.ApiName = chosenDocument?.ApiName ?? ""
        DocumentSingleton.sharedDocument.ApiUsername = chosenDocument?.ApiUsername ?? ""
        DocumentSingleton.sharedDocument.DocumentName = chosenDocument?.DocumentName ?? ""
        DocumentSingleton.sharedDocument.DocumentComment = chosenDocument?.DocumentComment ?? ""
        DocumentSingleton.sharedDocument.trigger = 1

        let upload = UploadVC()
        upload.modalPresentationStyle = .fullScreen
        present(upload, animated: true, completion: nil)
        
    }
    
}
