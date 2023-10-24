//
//  DocumentSingleton.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 24.10.2023.
//

import Foundation
class DocumentSingleton {//singleton bir sınıf var bu sınıftan bir obje oluşturulabilir
    
    static let sharedDocument = DocumentSingleton()//bu sınıftan oluşturulan tek obje
    
    var ApiName = ""
    var ApiUsername = ""
    var DocumentName = ""
    var DocumentComment = ""
    private init() {
        
    }
    
    
}
