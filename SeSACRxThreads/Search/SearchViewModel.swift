//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 서충원 on 8/7/24.
//

import Foundation
import RxSwift

class SearchViewModel {
    
    let disposeBag = DisposeBag()
    
    let inputQuery = PublishSubject<String>()
    let inputSearchButtonTap = PublishSubject<Void>()
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    lazy var list = BehaviorSubject<[String]>(value: data)
    
    init() {
        inputQuery
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter{ $0.contains(value) }
                
                owner.list.onNext(result)
                
            }
            .disposed(by: disposeBag)
        
        inputSearchButtonTap
            .withLatestFrom(inputQuery)
            .subscribe(onNext: { value in
                print(value)
                self.data.insert(value, at: 0)
                self.list.onNext(self.data)
            })
            .disposed(by: disposeBag)
    }
}
