//
//  ObservableVC.swift
//  RxSwiftDemo
//
//  Created by 俊文 on 2021/4/19.
//

import UIKit
import RxSwift
import RxCocoa

class ObservableVC: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        never()
        empty()
        just()
        of()
        from()
        error()
        create()
    }
   
    //nerver 创建一个不会发射任何数据的observable
    func never() {
        let nerverSequence = Observable<String>.never()
        
        nerverSequence.subscribe { (_) in
            print("永远不会执行")
        }.disposed(by: disposeBag)
    }
    
    //empty 不会通知信号的内容，只会告诉你完成了(completed)
    func empty() {
        Observable<Int>.empty().subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    //just 把一个或多个对象换成发这个或这些对象的一个observable 他会先发送next 再发送completed 这是最常用的一个observable
    func just() {
        //Observable 观察者
        let numberSquence = Observable.just(5)
        //订阅
        let _ = numberSquence.subscribe(onNext: {
            print($0)
        })
        
//        _ = Observable.just(5).subscribe(onNext: {
//            print($0)
//        }).dispose()    //取消订阅
    }
    
    //of把一系列的元素 转换成事件序列 他会先发送next 再发送completed（对顺序有严格要求再用它）
    func of() {
        let observable = Observable.of(1,2,3)
        observable.subscribe{
            print($0)
        }
//        observable.subscribe { (event) in
//            print(event)
//        } onError: { (error) in
//            print(error)
//        } onCompleted: {
//            print("completed")
//        } onDisposed: {
//            print("cancle")
//        }.disposed(by: disposeBag)

    }
    
    //from 把序列转换成事件序列
    func from() {
        let helloSequence = Observable.from(["V","E","R","G","I","L"])
        let helloSubscription = helloSequence.subscribe { (event) in
            switch event {
                case .next(let value):
                    print(value)
                case .error(let error):
                    print(error)
                case .completed:
                    print("OK!")
            }
        }
        
        helloSubscription.dispose()
    }
    
    //error 不管有没有成功 统一跟你说error
    func error() {
        enum MyError: Error {
            case test
        }
        
        Observable<Void>.error(MyError.test)
            .subscribe(onError: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    
    //create
    func create() {
        _ = Observable<String>.create({ observerOfString in
            print("观察者被创建了")
            observerOfString.on(.next("next"))
            observerOfString.onNext("next")
            observerOfString.on(.completed)
            
            return Disposables.create()
        }).subscribe({ x in
            print(x)
        })
    }

}
