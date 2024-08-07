//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 서충원 on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class PhoneViewModel {
    ///Input Observable
    struct Input {
        let tap: ControlEvent<Void>
        let text: ControlProperty<String?>
    }
    
    ///Output Observable
    struct Output {
        let tap: ControlEvent<Void>
        let initialText: Observable<String>
        let validText: Observable<String>
        let validation: Observable<Bool>
        let validationColor: Observable<UIColor>
    }
    
    func transform(input: Input) -> Output {
        let initialText = Observable.just("010")
        let validText = Observable.just("연락처는 8자 이상")
        let validation = input.text.orEmpty.map{ $0.count >= 8 }
        let validationColor = validation.map{ $0 ? UIColor.black : UIColor.blue }
        
        return Output(tap: input.tap, initialText: initialText,validText: validText, validation: validation, validationColor: validationColor)
    }
}
