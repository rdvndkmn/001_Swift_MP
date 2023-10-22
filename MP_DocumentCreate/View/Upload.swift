//
//  Upload.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 11.10.2023.
//

import Foundation
import UIKit

class UploadVC : UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationBarDelegate{


   /*
    func updateView(name: String, username: String, email: String) {
        
       
        
        
        
        DataTableView.reloadData()
    }
    */
    var users: [User] = []
    


    
    
    
    
   // private let viewmodel : UploadViewModel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiManager = APIManager()
               apiManager.fetchUser { result in
                   switch result {
                   case .success(let fetchedUsers):
                       self.users = fetchedUsers
                       // TableView'ı güncelle
                       DispatchQueue.main.async {
                           self.DataTableView.reloadData()
                       }
                   case .failure(let error):
                       print("Hata: \(error)")
                   }
               }
        
        view.backgroundColor = .white
        
        self.navigationController?.pushViewController(FeedVC(), animated:true)
        
        let navbar = UINavigationBar(frame: CGRect(x:0 , y: 50, width: view.bounds.width, height: 40))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButton))
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
        
        DataTableView.delegate = self
        DataTableView.dataSource = self
       // viewmodel.fetchUsers()
        setupView()
        
                
    }
         
/*
    
    init(viewmodel: UploadViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
        self.viewmodel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    @objc func backButton(){
        let feedvc = FeedVC()
        feedvc.modalPresentationStyle = .fullScreen
        present(feedvc, animated: true, completion: nil)
    }
    
    private let DocumentNameText : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Document Name"
        textfield.textAlignment = .center
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let DocumentCommentText : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Document Comment"
        textfield.textAlignment = .center
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let DataTableView : UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.translatesAutoresizingMaskIntoConstraints = false
      
        return tableview
    }()
    
    private let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(SaveButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let UsernameLabel : UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.isHidden = true
        return label
        
    }()
    
    private let DocumentNameLabel : UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "documentname"
        label.isHidden = true
        return label
        
    }()
    
    
    
    private let DocumentCommentLabel : UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "documentcomment"
        label.isHidden = true
        return label
        
    }()
    
    private let DataNameLabel : UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dataname"
        label.isHidden = true
        return label
        
    }()
    
    private let DataCommentLabel : UILabel = {
        
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
        let cell = UITableViewCell()//hücreyi oluşturduk
        var content = cell.defaultContentConfiguration()//content(içerik) oluşturduk
        let user = users[indexPath.row]
        content.text = user.name
        cell.contentConfiguration = content//cellin content ayarını contente eşledik
        return cell
        
    }
    
    
    @objc func SaveButtonClicked(sender: UIButton!){
        
        print("Save success")
        
        
    }
    
    
    private func setupView(){
        
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
        let height = view.bounds.height
        
        NSLayoutConstraint.activate([
            
            UsernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),//x ekseninde ortaya koy
            UsernameLabel.heightAnchor.constraint(equalToConstant: 60),// yüksekliği belirledik
            UsernameLabel.widthAnchor.constraint(equalToConstant: 200),// genişliği belirledik
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
            DataTableView.heightAnchor.constraint(equalToConstant: height),
            DataTableView.widthAnchor.constraint(equalToConstant: width),
            DataTableView.topAnchor.constraint(equalTo: DocumentCommentText.topAnchor, constant: 100)
            
            
            
        ])
        
    }
    
}
