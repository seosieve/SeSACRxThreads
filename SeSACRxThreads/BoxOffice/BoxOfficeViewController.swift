//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by 서충원 on 8/7/24.
//

import UIKit
import Then
import SnapKit
import RxSwift

class BoxOfficeViewController: UIViewController {
    
    let viewModel = BoxOfficeViewModel()
    
    let disposeBag = DisposeBag()
    
    let identifier = (collectionView: MovieCollectionViewCell.description(), tableView: MovieTableViewCell.description())
    
    let layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 120, height: 40)
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .yellow
        $0.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: identifier.0)
    }
    
    lazy var tableView = UITableView().then {
        $0.backgroundColor = .systemGreen
        $0.rowHeight = 100
        $0.register(MovieTableViewCell.self, forCellReuseIdentifier: identifier.1)
    }
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
        configureConstraints()
        configureRx()
    }
    
    func configureSubViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
    }
    
    func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureRx() {
        
        var recentText = PublishSubject<String>()
        
        let input = BoxOfficeViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked,
                                             searchText: searchBar.rx.text.orEmpty,
                                             recentText: recentText)
        
        let output = viewModel.transform(input: input)
        
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: identifier.0, cellType: MovieCollectionViewCell.self)) { row, element, cell in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
        
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: identifier.1, cellType: MovieTableViewCell.self)) { row, element, cell in
                cell.appNameLabel.text = element
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected)
            .map { "검색어는 \($0)" }
            .subscribe(with: self, onNext: { owner, value in
                recentText.onNext(value)
            })
            .disposed(by: disposeBag)
    }
}
