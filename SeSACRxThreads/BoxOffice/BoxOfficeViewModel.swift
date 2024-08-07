//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by 서충원 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
    
    let disposeBag = DisposeBag()
    
    let movieList = Observable.just(["daw", "daw", "aaa"])
    var recentList = ["aaa"]
    
    ///Input Observable
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        
        let recentText: PublishSubject<String>
    }
    
    ///Output Observable
    struct Output {
        let movieList: Observable<[String]>
        let recentList: BehaviorSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        input.searchButtonTap
            .subscribe(with: self) { owner, _ in
                print("Tap")
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        
        
        let recentList = BehaviorSubject<[String]>(value: recentList)
        
        input.recentText
            .bind(with: self) { owner, value in
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        return Output(movieList: movieList, recentList: recentList)
    }
}
