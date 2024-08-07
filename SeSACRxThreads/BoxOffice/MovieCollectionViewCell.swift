//
//  MovieCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 서충원 on 8/7/24.
//

import UIKit
import Then
import SnapKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    let borderView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
    }
    
    let label = UILabel().then {
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubViews() {
        contentView.addSubview(borderView)
        contentView.addSubview(label)
    }
    
    func configureConstraints() {
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
