//
//  Contributor.swift
//  RxSwiftDemo
//
//  Created by 俊文 on 2021/4/23.
//

import UIKit

struct Contributor {
    let name: String
    let gitHubID: String
    var image: UIImage?
    
    init(name: String, gitHubID: String) {
        self.name = name
        self.gitHubID = gitHubID
        image = UIImage(named: gitHubID)
    }
}

extension Contributor : CustomStringConvertible {
    var description: String{
        return "\(name): github.com/\(gitHubID)"
    }
}
