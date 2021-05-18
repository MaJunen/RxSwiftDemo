//
//  TableViewController.swift
//  RxSwiftDemo
//
//  Created by 俊文 on 2021/4/23.
//

import UIKit
import RxSwift
import RxCocoa

class TableViewController: UIViewController {
    let tableView : UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    let data = Observable.of([
        Contributor(name: "Krunoslav Zaher", gitHubID: "kzaher"),
        Contributor(name: "Yury Korolev", gitHubID: "yury"),
        Contributor(name: "Serg Dort", gitHubID: "sergdort"),
        Contributor(name: "Mo Ramezanpoor", gitHubID: "mohsenr"),
        Contributor(name: "Carlos García", gitHubID: "carlosypunto"),
        Contributor(name: "Scott Gardner", gitHubID: "scotteg"),
        Contributor(name: "Nobuo Saito", gitHubID: "tarunon"),
        Contributor(name: "Junior B.", gitHubID: "bontoJR"),
        Contributor(name: "Jesse Farless", gitHubID: "solidcell"),
        Contributor(name: "Jamie Pinkham", gitHubID: "jamiepinkham")
    ])
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        data.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "cell")) {_, contributor,cell in
                cell.textLabel?.text = contributor.name
                cell.detailTextLabel?.text = contributor.gitHubID
                cell.imageView?.image = contributor.image
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(Contributor.self)
            .subscribe(onNext: {
                print("You selected: \($0)")
            })
            .disposed(by: disposeBag)
    }
}

