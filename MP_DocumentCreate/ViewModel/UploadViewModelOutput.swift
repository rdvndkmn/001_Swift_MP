//
//  UploadViewModelOutput.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 12.10.2023.
//

import Foundation
protocol UploadViewModelOutput : AnyObject{//weak var olarak tanımlamak için any
    func updateView(name : String, username : String, email : String)
}
