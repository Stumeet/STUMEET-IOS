//
//  OnboardingViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import UIKit

class OnboardingViewController: BaseViewController {
    // TODO: - viewmodel 연결
    let pages = ["스터디 그룹을 생성하고, 초대해요 1", "스터디 그룹을 생성하고, 초대해요 2", "스터디 그룹을 생성하고, 초대해요 3", "스터디 그룹을 생성하고, 초대해요 4"]
    
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let bottomVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing =  33
        return stackView
    }()

    private let onboardingCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let startButtonContainer: UIView = {
        let view =  UIView()
        return view
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.applyStyle(.abled)
        button.setTitle("시작!", for: .normal)
        return button
    }()
    
    private let pageControlContainer: UIView = {
        let view =  UIView()
        return view
    }()
    
    private let pageControl = BasePageControl()
    
    // MARK: - Properties
    private let viewModel: OnboardingViewModel
        
    // MARK: - Init
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        self.view.backgroundColor = .white
        pageControl.backgroundColor = .white
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 1
        pageControl.dotRadius = 4
        pageControl.dotSpacings = 8
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = StumeetColor.primary700.color
    }
    
    override func setupAddView() {
        view.addSubview(rootVStackView)
        
        startButtonContainer.addSubview(startButton)
        pageControlContainer.addSubview(pageControl)
        
        [
            pageControlContainer,
            startButtonContainer
        ]   .forEach { bottomVStackView.addArrangedSubview($0) }
        
        [
            onboardingCollectionView,
            bottomVStackView
        ]   .forEach { rootVStackView.addArrangedSubview($0) }
        
    }

    override func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
            $0.height.equalTo(72)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        registerCell()
    }
    
    private func setupDelegate() {
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.delegate = self
    }
    
    private func registerCell() {
        onboardingCollectionView.register(OnboardingCollectionViewCell.self,
                                          forCellWithReuseIdentifier: OnboardingCollectionViewCell.defaultReuseIdentifier)
    }

}

extension OnboardingViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.defaultReuseIdentifier,
                                                            for: indexPath) as? OnboardingCollectionViewCell
        else { fatalError("Unable to dequeue OnboardingCollectionViewCell")}
        cell.configure(text: pages[indexPath.item], imageName: "changeProfileCharacter")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.frame.size
    }
}
