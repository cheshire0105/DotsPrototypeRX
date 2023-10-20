//
//  ViewController.swift
//  DotsPrototypeRX
//
//  Created by cheshire on 10/19/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    let viewModel: FruitsViewModel
    let disposeBag = DisposeBag()

    init(viewModel: FruitsViewModel = FruitsViewModel(fruits: fruits)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = FruitsViewModel(fruits: fruits)
        super.init(coder: coder)
    }

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // 왼쪽과 오른쪽에 16의 간격 설정
        flowLayout.minimumInteritemSpacing = 8 // 셀 간의 간격 설정 (필요한 경우 값을 조절하세요)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "customCell")
        return collectionView
    }()

    lazy var compositionalCollectionViewTwo: UICollectionView = {
        let layout = createCompositionalLayoutTwo()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true // 스크롤 활성화
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "compositionalCellTwo")
        return collectionView
    }()

    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfFruits>(
        configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "compositionalCellTwo", for: indexPath) as! CustomCell
            cell.label.text = item
            cell.backgroundColor = .blue
            cell.layer.cornerRadius = 10
            cell.contentView.clipsToBounds = true
            return cell
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderView
                header.label.text = dataSource[indexPath.section].header
                return header
            }
            return UICollectionReusableView()
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindCollectionView()
        bindCompositionalCollectionViewTwo()

        compositionalCollectionViewTwo.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }

    func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        view.addSubview(compositionalCollectionViewTwo)
        compositionalCollectionViewTwo.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom) // 탭바를 침범하지 않도록 safe area에 맞춤
        }
    }

    func createCompositionalLayoutTwo() -> UICollectionViewLayout {
        // For the new section
        let newItemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(330))
        let newItem = NSCollectionLayoutItem(layoutSize: newItemSize)
        newItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let newGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(330))
        let newGroup = NSCollectionLayoutGroup.horizontal(layoutSize: newGroupSize, subitems: [newItem])

        let newSection = NSCollectionLayoutSection(group: newGroup)
        newSection.orthogonalScrollingBehavior = .continuous

        // For the existing section
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let groupWidth = CGFloat(133)
        let groupHeight = CGFloat(190)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]

        // Combine the two sections
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                return newSection
            } else {
                return section
            }
        }

        return layout
    }

    func bindCompositionalCollectionViewTwo() {
        // 세 개의 섹션을 추가
        let newItems = Array(repeating: "New Item", count: 10) // 여기서 10개의 "New Item"을 생성
        let sections = [
            SectionOfFruits(header: "New Section", items: newItems),
            SectionOfFruits(header: "Section 1", items: viewModel.fruitNames),
            SectionOfFruits(header: "Section 2", items: viewModel.fruitNames)
        ]
        Observable.just(sections)
            .bind(to: compositionalCollectionViewTwo.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    func bindCollectionView() {
        let items = Observable.just(viewModel.fruitNames)

        items.bind(to: collectionView.rx.items(cellIdentifier: "customCell", cellType: CustomCell.self)) { (row, text, cell) in
            cell.label.text = text
            cell.backgroundColor = .gray
            cell.layer.cornerRadius = 10
            cell.contentView.clipsToBounds = true
        }.disposed(by: disposeBag)

        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            print("Selected item at \(indexPath.row)")
        }).disposed(by: disposeBag)

        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    // UICollectionViewDelegateFlowLayout 메서드를 직접 구현
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 73, height: 34) // 원하는 크기로 설정
    }
}
