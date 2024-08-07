//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 서충원 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    ///Input Observable
    struct Input {
        let birthday: ControlProperty<Date>
        let tap: ControlEvent<Void>
    }
    
    ///Output Observable
    struct Output {
        let year: Observable<Int>
        let month: Observable<Int>
        let day: Observable<Int>
        let valid: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        ///Container Output
        let calender = Calendar.current
        
        let currentDate = calender.dateComponents([.year, .month, .day], from: Date())
        
        let date = input.birthday
            .map{ calender.dateComponents([.year, .month, .day], from: $0) }
            .share()
        
        let year = date
            .map { $0.year }
            .compactMap{ $0 }
        
        let month = date
            .map { $0.month }
            .compactMap{ $0 }
        
        let day = date
            .map { $0.day }
            .compactMap{ $0 }
        
        let valid = date
            .map { $0.year! < currentDate.year! - 18 }
        
        return Output(year: year, month: month, day: day, valid: valid, tap: input.tap)
    }
}
