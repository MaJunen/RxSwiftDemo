//
//  SignalVC.swift
//  RxSwiftDemo
//
//  Created by 俊文 on 2021/4/19.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        subject()
        RpSubject()
        behaviorSubject()
        
        variable()
    }
    
    func subject() {
        //Subject 子类
        //在RAC 当中也有subject的存在，他可以发送信号，也可以订阅信号，本身也是信号
        //PublishSubject要先订阅，才能收到发送的信号
        let publishSubject = PublishSubject<String>()
        
        publishSubject.onNext("Hello")  //发送一个信号
        publishSubject.onNext("world")
        
        _ = publishSubject.subscribe{
            print($0)
        }
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("Again")
    }
    
    func RpSubject() {
        //ReplaySubject 不管订阅者什么时候 我都要 但是 其他的订阅 我可以限制他的次数
        //发射所有的来自原始Observable的数据给观察者，无论他们是什么时候订阅的
        let accountSubject = ReplaySubject<Double>.create(bufferSize: 3)
        
        _ = accountSubject.subscribe{
            print("火车票的价格\($0)")
        }
        
        accountSubject.onNext(12.49)
        accountSubject.onNext(22.49)
        accountSubject.onNext(32.49)
        accountSubject.onNext(52.49)
        accountSubject.onNext(62.49)
        accountSubject.onNext(72.49)
        
        print("\n")
        
        _ = accountSubject.subscribe{
            print("第二次訂閱火車票的價格 \($0)")
        }
    }
    
    func behaviorSubject() {
        //BehaviorSubject他会接收从前面后面来的订阅。但是只有第一个
        //BehaviorSubject 当观察者订阅BehaviorSubject的时候他会发射原始Observable
        //最靠近的内容，然后继续发射其他和来自 原始Observable（简单的说就是 buffsersize = 1的replaySubject）
        let behaviorSubject = BehaviorSubject(value: "A")
        behaviorSubject.onNext("我从前面来")
        let _ = behaviorSubject.subscribe{
            print("订阅者\($0.element ?? "")")
        }
        
        behaviorSubject.onNext("B")
        behaviorSubject.onNext("C")
        behaviorSubject.onNext("D")
        
        let _ = behaviorSubject.subscribe{
            print("订阅者2\($0.element ?? "")")
        }
        behaviorSubject.onNext("前面来的 我都要")
        behaviorSubject.onNext("前面来的 我都要")
        behaviorSubject.onNext("前面来的 我都要")
    }
    
    //vaeuable:BehaviorSubject的进一层封装，特点不会被显示终结。
    //也就是不会接收到completed或者error这类终结事件，他会主动在构析的时候发送completed
    //deprecated
    func variable() {
        let disposeBag = DisposeBag()
        
        let variable = Variable<String>("默认值")
        variable.asObservable().subscribe { (event) in
            print("NO1",event)
        }.disposed(by: disposeBag)
        
        variable.value = "第一个值"
        variable.value = "第二个值"
        
        variable.asObservable().subscribe { (event) in
            print("NO2",event)
        }.disposed(by: disposeBag)
        variable.value = "第三个值"
        variable.value = "第四个值"
    }
    
}
