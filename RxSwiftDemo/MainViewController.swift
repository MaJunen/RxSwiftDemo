//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 俊文 on 2021/2/20.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    lazy var tableView : UITableView = {
        let  tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    lazy var dataSource : Array<String> = {
        return ["ObservableVC","SubjectVC","AddNameVC","CombinationVC","TableViewController"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
    }

    
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = self.dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Swift中直接使用NSClassFromString获取的Class是nil，需要在前拼接项目文件名
        let workName = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
        let className: String = self.dataSource[indexPath.row]
        let classVc = NSClassFromString("\(workName).\(className)") as! UIViewController.Type
        let vc = classVc.init()
        vc.title = self.dataSource[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
