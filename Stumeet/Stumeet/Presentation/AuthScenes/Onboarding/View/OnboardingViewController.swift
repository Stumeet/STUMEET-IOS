//
//  OnboardingViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import Combine
import UIKit

class OnboardingViewController: BaseViewController {
    // TODO: - viewmodel 연결
    let pages: [(String, ImageResource)] = [("스터디를 생성하고 초대할 수 있어요", .Onboarding.onboardingImg1),
                                            ("칭찬을 주고 받으며 포도알을 채워나가요!", .Onboarding.onboardingImg2),
                                            ("스터밋으로 공부하고\n나의 포도나무를 성장시켜 보세요!", .Onboarding.onboardingImg3)]
    
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let bottomVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing =  57
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
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.titleSemibold.font
        container.foregroundColor = StumeetColor.gray50.color
        configuration.background.cornerRadius = 16
        configuration.attributedTitle = AttributedString("시작!", attributes: container)
        configuration.baseBackgroundColor = StumeetColor.primary700.color
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }()
    
    private let pageControlContainer: UIView = {
        let view =  UIView()
        return view
    }()
    
    private let pageControl = BasePageControl()
    
    // MARK: - Properties
    private let viewModel: OnboardingViewModel
    private weak var coordinator: AuthNavigation!
        
    // MARK: - Init
    init(viewModel: OnboardingViewModel,
         coordinator: AuthNavigation
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
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
        pageControl.pageIndicatorTintColor = .init(hex: "#E4E4E4")
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
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
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
    
    override func bind() {
        // MARK: - Input
        let input = OnboardingViewModel.Input(
            didTapNextButton: startButton.tapPublisher
        )
        
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.navigateToSnsLoginVC
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator.goToSnsLoginVC()
            }
            .store(in: &cancellables)
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
        else { return UICollectionViewCell() }
        cell.configure(text: pages[indexPath.item].0, imageName: pages[indexPath.item].1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.frame.size
    }
}
