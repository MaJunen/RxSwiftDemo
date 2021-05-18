//
//  AddNameVC.swift
//  RxSwiftDemo
//
//  Created by 俊文 on 2021/4/20.
//

import UIKit
import RxSwift
import RxCocoa

class AddNameVC: UIViewController {
    lazy var helloLabel : UILabel = {
        var helloLabel = UILabel(frame: CGRect.init(x: 100, y: 100, width: 200, height: 50))
        helloLabel.backgroundColor = UIColor.blue
        return helloLabel
    }()
    
    lazy var nameTextField : UITextField = {
        var nameTextField = UITextField(frame: CGRect.init(x: 100, y: 200, width: 200, height: 50))
        nameTextField.placeholder = "nameTextField"
        nameTextField.backgroundColor = UIColor.blue
        return nameTextField
    }()
    
    lazy var submitBtn : UIButton = {
        var submitBtn = UIButton(frame: CGRect.init(x: 150, y: 300, width: 100, height: 50))
        submitBtn.setTitle("submit", for: .normal)
        submitBtn.setTitleColor(UIColor.black, for: .normal)
        return submitBtn
    }()
    
    lazy var namesLb : UILabel = {
        var namesLb = UILabel(frame: CGRect.init(x: 100, y: 400, width: 200, height: 50))
        namesLb.backgroundColor = UIColor.blue
        return namesLb
    }()
    
    lazy var addNameBtn : UIButton = {
        var addNameBtn = UIButton(frame: CGRect.init(x: 100, y: 500, width: 100, height: 50))
        addNameBtn.setTitle("addName", for: .normal)
        addNameBtn.setTitleColor(UIColor.black, for: .normal)
        return addNameBtn
    }()
    
    let disposeBag = DisposeBag()
    var nameArray = Array<String>()
    
    let nameSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addSubviews()
        
        bindTextField()
//        bindSubmitButton()
        bindSubmitBtn()
        
        self.nameSubject.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
    func bindTextField() {
        //对输入框的操作
        nameTextField.rx.text
            .map {
                if $0 == "" {
                    return "请输入你的名字"
                } else {
                    return "Hello, \($0 ?? "")"
                }
            }
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: helloLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindSubmitButton() {
        submitBtn.rx.tap.subscribe(onNext: {
            if self.nameTextField.text != "" {
                //把所有輸入的東西放進数组當中
                self.nameArray.append(self.nameTextField.text!)
                self.namesLb.rx.text.onNext(self.nameArray.joined(separator: ","))
                self.nameTextField.rx.text.onNext("")
                self.helloLabel.rx.text.onNext("请输入你的名字")
            }
        }).disposed(by: disposeBag)
    }
    
    func bindSubmitBtn() {
        submitBtn.rx.tap.subscribe(onNext: {
            if self.nameTextField.text != "" {
                self.nameSubject.onNext(self.nameTextField.text!)
            }
        }).disposed(by: disposeBag)
    }
    
    func addSubviews() {
        self.view.addSubview(self.helloLabel)
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.submitBtn)
        self.view.addSubview(self.namesLb)
        self.view.addSubview(self.addNameBtn)
    }
}
