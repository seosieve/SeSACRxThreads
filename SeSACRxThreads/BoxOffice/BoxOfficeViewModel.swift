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
    
    var recentList = ["aaa"]
    
    ///Input Observable
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        
        let recentText: PublishSubject<String>
    }
    
    ///Output Observable
    struct Output {
        let movieList: Observable<[DailyBoxOfficeList]>
        let recentList: BehaviorSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        let recentList = BehaviorSubject<[String]>(value: recentList)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map { Int($0) ?? 20231010 }
            .flatMap { NetworkManager.shared.callBoxOffice($0) }
            .subscribe { movie in
                boxOfficeList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        input.recentText
            .bind(with: self) { owner, value in
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        return Output(movieList: boxOfficeList, recentList: recentList)
    }
}
