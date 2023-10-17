//
//  Feed.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 11.10.2023.
//

import Foundation
import UIKit

class FeedVC : UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationBarDelegate {
   
    
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.pushViewController(SingIn(), animated:true)
                
        FeedTableView.delegate = self
        FeedTableView.dataSource = self
        
        let navbar = UINavigationBar(frame: CGRect(x:0 , y: 50, width: view.bounds.width, height: 40))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self

        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(LogOutnClicked))
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked))

        navbar.items = [navItem]

        view.addSubview(navbar)
        view.addSubview(FeedTableView)

        
    }

    @objc func LogOutnClicked(sender: UIButton!){
    
        let singin = SingIn()
        singin.modalPresentationStyle = .fullScreen
        present(singin, animated: true, completion: nil)
        
    }
    
    @objc func addClicked(){
        let service = APIManager()
        let viewmodel = UploadViewModel(userservice: service)
        let upload = UploadVC(viewmodel: viewmodel)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "deneme"
        return cell
        
    }
    
    
    
}
