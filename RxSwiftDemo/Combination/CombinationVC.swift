//
//  CombinationVC.swift
//  RxSwiftDemo
//
//  Created by 俊文 on 2021/4/20.
//

import UIKit
import RxSwift
import RxCocoa

class CombinationVC: UIViewController {

    let disposedBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
//        startWith()
//        merge()
//        zip()
//        combineLatest()
//        map()
//        flatMap()
//        scan()
//        filter()
//        distinctUntilChanged()
//        elementAt()
//        single()
//        take()
//        takeLast()
//        takeWhile()
//        takeUntil()
//        skip()
//        skipWhile()
        skipUntil()
    }
    
    //在Observable源发出元素前，发出特定的元素
    func startWith() {
        Observable.of(1,2,3)
            .startWith(6)
            .subscribe(onNext: {    print($0)   })
            .disposed(by: disposedBag)
    }
    
    //将源可观察序列的元素组合成一个新的可观察序列
    //ps:自动合并里面的元素
    func merge() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.of(subject1,subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
        
        subject1.onNext("?️")
        subject1.onNext("?️")
        subject2.onNext("①")
        subject2.onNext("②")
        subject1.onNext("?")
        subject2.onNext("③")
    }
    
    //将可观察序列合并成一个新的可观察序列
    //ps:两个信号发生改变时才会接收到信号
    func zip() {
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject, intSubject) { stringElement,intElement in
            "\(stringElement) \(intElement)"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposedBag)
        
        stringSubject.onNext("?")
//        stringSubject.onNext(":")
        
        intSubject.onNext(5)
        intSubject.onNext(6)
        
        stringSubject.onNext("?")
        intSubject.onNext(7)
        intSubject.onNext(8)
        stringSubject.onNext(":")
    }
    
    //将可观察队列合并成单个新的可观察队列，当多个源至少有一个的时候发出信号
    //ps:改变一个信号发送一个组合
    func combineLatest() {
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.combineLatest(stringSubject, intSubject) { stringElement,intElement in
            "\(stringElement) \(intElement)"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposedBag)
        
        stringSubject.onNext("?")
        stringSubject.onNext("?")
        
        intSubject.onNext(1)
        intSubject.onNext(2)
        
        stringSubject.onNext("?")
        intSubject.onNext(3)
    }
    
    //转换可观察队列发出的Next事件里元素的操作,将转换闭包应用于可观察序列发出的元素，并返回已转换元素的一个新的可观察序列。
    func map() {
        Observable.of(1,2,3)
            .map { $0 * $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //将Observable队列发出的元素转换成一个新的可观察队列，并将两者的输出组合成一个新的可观察队列，意思就是说会监听原队列，也会监听你闭包中转换过的队列。
    //ps:转换过的队列都会监听
    func flatMap() {
        struct Player {
            var score: Variable<Int>
        }
        
        let a = Player(score: Variable(80))
        let b = Player(score: Variable(90))
        
        let player = Variable(b)
        
        player.asObservable()
            .flatMap{ $0.score.asObservable() }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
        
        b.score.value = 85
        
        player.value = a
        
        b.score.value = 95
        
        a.score.value = 100
    }
    
    //以初始值开始，然后将一个累加器闭包应用于可观察序列所发射的每个元素，并将每个中间结果作为一个元素可观察序列返回
    //ps:就相当于个累加器,把of里面的元素一个个加起来，scan里面的参数是初始值
    func scan() {
        Observable.of(10,100,1000)
            .scan(2) { aggregateValue,newValue in
                aggregateValue + newValue
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //类似于 swift 语法中的filter，筛选出符合条件的信号
    func filter() {
        Observable.of(
            "?","?","?",
            "?","?","?",
            "?","2","1")
            .filter{
                $0 == "?"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //直到信号变化时，才发出信号，比如使用 textfield 只有内容变化时才发出信号
    func distinctUntilChanged() {
        Observable.of("?","?","?",
                      "?","?","?",
                      "?","1")
            .distinctUntilChanged()
            .subscribe(onNext: { print($0) })   //?,1
            .disposed(by: disposedBag)
    }
    
    //获取序列中的第某个信号,按下标来
    func elementAt() {
        Observable.of("?","?","2",
                      "3","?","?",
                      "?")
            .elementAt(3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //序列发出的第一个元素（或满足条件的第一个元素）。如果序列中有多个满足条件的或者不存在满足条件的，则抛出一个错误。
    func single() {
        Observable.of("?","?","?","?","?","?","?")
            .single{ $0 == "?" }
            .subscribe{ print($0) }
            .disposed(by: disposedBag)
    }
    
    //从序列的开头获取指定数量的信号
    func take() {
        Observable.of("1","2","3","4","5","6","7")
            .take(3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //从序列的结尾获取指定数量的元素。
    func takeLast() {
        Observable.of("1","2","3","4","5","6","7")
            .takeLast(3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //在指定的条件满足时，则从可观察序列的开头发出元素
    func takeWhile() {
        Observable.of(1,2,3,4,5,6)
            .takeWhile{ $0 < 4 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //从源序列中获取元素，直到引用可观察序列发出元素结束
    //打印前3个？
    func takeUntil() {
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence.takeUntil(referenceSequence)
            .subscribe { print($0) }
            .disposed(by: disposedBag)
        
        sourceSequence.onNext("?")
        sourceSequence.onNext("?")
        sourceSequence.onNext("?")
        
        referenceSequence.onNext("?")
        
        sourceSequence.onNext("?")
        sourceSequence.onNext("?")
        sourceSequence.onNext("?")
    }
    
    //从序列的开头跳过指定数量的元素
    func skip() {
        Observable.of("1","2","3","4","5","6","7")
            .skip(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //从序列的开头跳过满足条件的元素
    func skipWhile() {
        Observable.of(1,2,3,4,5,6,7)
            .skipWhile{ $0 < 4 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
    }
    
    //从源序列中跳过元素，直到引用可观察序列发出元素。
    //打印后3个？
    func skipUntil() {
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .skipUntil(referenceSequence)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposedBag)
        
        sourceSequence.onNext("?")
        sourceSequence.onNext("?")
        sourceSequence.onNext("?")
        
        referenceSequence.onNext("?")
        
        sourceSequence.onNext("?")
        sourceSequence.onNext("?")
        sourceSequence.onNext("?")
    }

}
