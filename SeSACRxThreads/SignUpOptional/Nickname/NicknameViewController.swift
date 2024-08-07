//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
    
    let viewModel = NicknameViewModel()
    
    let disposeBag = DisposeBag()
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configureRx()
    }
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configureRx() {
        
        let test = nextButton.rx.tap
            .map{ "안녕하세요 \(Int.random(in: 1...1000))" }
            .asDriver(onErrorJustReturn: "")
        
        test
            .drive(nextButton.rx.title())
            .disposed(by: disposeBag)
        
        test
            .drive(nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        test
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
}
