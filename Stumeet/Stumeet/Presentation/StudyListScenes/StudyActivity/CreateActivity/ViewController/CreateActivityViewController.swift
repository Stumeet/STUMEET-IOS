//
//  CreateActivityViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 3/18/24.
//

import Combine
import UIKit
import PhotosUI

final class CreateActivityViewController: BaseViewController {
    
    typealias Section = CreateActivitySection
    typealias SectionItem = CreateActivitySectionItem
    
    // MARK: - UIComponents
    
    private let topView = UIView()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xMark"), for: .normal)
        
        return button
    }()
    
    private let topLabel: UILabel = {
        return UILabel().setLabelProperty(text: "활동 생성", font: StumeetFont.titleMedium.font, color: nil)
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(StumeetColor.primary700.color, for: .normal)
        
        return button
    }()
    
    private let categoryButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.attributedTitle = AttributedString("자유")
        config.image = UIImage(named: "greenDownPolygon")
        config.imagePlacement = .trailing
        config.baseForegroundColor = .black
        
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.layer.borderColor = StumeetColor.primary700.color.cgColor
        
        return button
    }()
    
    private lazy var categoryStackViewContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = StumeetColor.gray75.color.cgColor
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.layer.masksToBounds = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        containerView.addSubview(stackView)
        containerView.isHidden = true
        
        return containerView
    }()
    
    private lazy var freedomButton: UIButton = createCategoryItemButton(category: .freedom)
    private lazy var meetingButton: UIButton = createCategoryItemButton(category: .meeting)
    private lazy var homeWorkButton: UIButton = createCategoryItemButton(category: .homework)
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목 이름"
        textField.setPlaceholder(font: .subTitleMedium2, color: .gray600)
        
        return textField
    }()
    
    private let seperationLine: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.gray100.color
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
    
        return scrollView
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용을 입력하세요"
        textView.textColor = StumeetColor.gray300.color
        textView.font = StumeetFont.bodyMedium15.font
        textView.isScrollEnabled = false
        
        return textView
        
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.register(DetailStudyActivityPhotoCell.self, forCellWithReuseIdentifier: DetailStudyActivityPhotoCell.identifer)
        
        return collectionView
    }()
    
    private let linkLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.primary700.color
        label.setPadding(top: 20, bottom: 19, left: 16, right: 16)
        label.backgroundColor = StumeetColor.primary50.color
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        
        
        return label
    }()
    
    private let bottomView = UIView()
    
    private let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addImageButton"), for: .normal)
        
        return button
    }()
    
    private let linkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .createActivityLink), for: .normal)
        
        return button
    }()
    
    private let noticeLabel: UILabel = {
        return UILabel().setLabelProperty(text: "공지 등록", font: StumeetFont.bodyMedium14.font, color: .gray500)
    }()
    
    private let noticeSwitch = UISwitch()
    
    // MARK: - Properties
    
    private let viewModel: CreateActivityViewModel
    private let coordinator: CreateActivityNavigation
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    
    // MARK: - Subjects
    
    private let selecetedPhotoSubject = PassthroughSubject<[UIImage], Never>()
    private let cellXButtonTapSubject = PassthroughSubject<UIImage, Never>()
    
    // MARK: - Init
    
    init(viewModel: CreateActivityViewModel, coordinator: CreateActivityNavigation) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatasource()
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - SetUp
    
    override func viewDidLayoutSubviews() {
        bottomView.layer.addBorder([.top, .bottom], color: StumeetColor.gray100.color, width: 1)
        categoryStackViewContainer.layer.addBorder([.left, .right, .bottom], color: StumeetColor.gray100.color, width: 1)
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
        noticeSwitch.transform = CGAffineTransform(scaleX: 36 / 51, y: 20 / 31)
        let buttonWidth = UIScreen.main.bounds.width - 32
        categoryButton.configuration?.imagePadding =  269 * buttonWidth / 380
    }
    
    override func setupAddView() {
        
        let stackView = categoryStackViewContainer.subviews.first as? UIStackView
        
        [
            freedomButton,
            meetingButton,
            homeWorkButton
        ]   .forEach { stackView?.addArrangedSubview($0) }
        
        [
            imageButton,
            noticeLabel,
            linkButton,
            noticeSwitch
        ]   .forEach { bottomView.addSubview($0) }
        
        [
            xButton,
            topLabel,
            nextButton
        ]   .forEach { topView.addSubview($0) }

        [
            categoryButton,
            titleTextField,
            seperationLine,
            contentTextView,
            photoCollectionView,
            linkLabel,
            categoryStackViewContainer
        ]   .forEach(scrollView.addSubview)
        
        [
            topView,
            scrollView,
            bottomView
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        
        topView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(71)
            make.height.equalTo(48)
        }
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        topLabel.snp.makeConstraints { make in
            make.leading.equalTo(xButton.snp.trailing).offset(24)
            make.top.equalTo(xButton)
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(topLabel)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(21)
            make.horizontalEdges.equalTo(view).inset(16)
            make.height.equalTo(56)
        }
        
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(xButton.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view).inset(24)
            make.height.equalTo(22)
        }
        
        seperationLine.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleTextField)
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.height.equalTo(1)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(view)
            make.top.equalTo(seperationLine.snp.bottom).offset(24)
            make.height.equalTo(0)
        }
        
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(seperationLine.snp.bottom).offset(200)
            make.horizontalEdges.equalTo(view).inset(24)
            make.height.equalTo(0)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(seperationLine.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(view).inset(20)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.height.equalTo(64)
        }
        
        imageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        linkButton.snp.makeConstraints { make in
            make.leading.equalTo(imageButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        noticeSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(noticeSwitch.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        categoryStackViewContainer.snp.makeConstraints { make in
            make.height.equalTo(168)
            make.top.equalTo(categoryButton.snp.bottom).offset(-8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(view).inset(16)
        }
        
        categoryStackViewContainer.subviews[0].snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        
        // MARK: - Input
        
        let categoryButtonTaps = Publishers.Merge3(
            freedomButton.tapPublisher.map { ActivityCategory.freedom },
            meetingButton.tapPublisher.map { ActivityCategory.meeting },
            homeWorkButton.tapPublisher.map { ActivityCategory.homework })
        
        let input = CreateActivityViewModel.Input(
            didChangeTitle: titleTextField.textPublisher,
            didChangeContent: contentTextView.textPublisher,
            didBeginEditing: contentTextView.didBeginEditingPublisher,
            didTapCategoryButton: categoryButton.tapPublisher,
            didTapCategoryItem: categoryButtonTaps.eraseToAnyPublisher(),
            didTapXButton: xButton.tapPublisher,
            didTapNextButton: nextButton.tapPublisher,
            didTapImageButton: imageButton.tapPublisher,
            didSelectedPhotos: selecetedPhotoSubject.eraseToAnyPublisher(),
            didTapCellXButton: cellXButtonTapSubject.eraseToAnyPublisher(),
            didTapLinkButton: linkButton.tapPublisher
        )
        
        
        // MARK: - Output
        
        let output = viewModel.transform(input: input)
        
        // textview placeholder 지우기
        output.isBeginEditing
            .filter { $0 }
            .removeDuplicates()
            .map { _ in }
            .receive(on: RunLoop.main)
            .sink(receiveValue: setBeginEditingText)
            .store(in: &cancellables)
        
        // 다음 버튼 enable 설정
        output.isEnableNextButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: checkNavigateToSettingVC)
            .store(in: &cancellables)
        
        // 카테고리 스택뷰 업데이트
        output.isHiddenCategoryItems
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: categoryStackViewContainer)
            .store(in: &cancellables)
        
        // 선택한 category UI binding
        output.selectedCategory
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateCategoryItem)
            .store(in: &cancellables)
        
        // 500자 이상일 경우 SnackBar 표시
        output.maxLengthText
            .filter { $0 != "" }
            .receive(on: RunLoop.main)
            .sink(receiveValue: showMaxLengthContentSnackBar)
            .store(in: &cancellables)
        
        // 앨범화면 전환
        output.presentToPickerVC
            .map { _ in self }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToPHPickerVC)
            .store(in: &cancellables)
        
        // 선택한 사진 바인딩
        output.photosItem
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        // linkPopUpVC로 화면 전환
        output.presentToLinkPopUpVC
            .map { self }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.presentToLinkPopUpVC)
            .store(in: &cancellables)
        
        // dismiss
        output.dismiss
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.dismiss)
            .store(in: &cancellables)
    }
}

// MARK: - CollectionViewLayout

extension CreateActivityViewController {
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: - Datasource

extension CreateActivityViewController {
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .photoCell(let image):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DetailStudyActivityPhotoCell.identifer,
                    for: indexPath)
                        as? DetailStudyActivityPhotoCell else { return UICollectionViewCell() }
                
                cell.xButton.tapPublisher
                    .map { image }
                    .sink(receiveValue: self.cellXButtonTapSubject.send)
                    .store(in: &cell.cancellables)
                
                cell.configureCreateActivityPhotoCell(image: image)
                
                return cell
            }
        })
    }
}

// MARK: UpdateUI

extension CreateActivityViewController {
    
    private func createCategoryItemButton(category: ActivityCategory) -> UIButton {
        
        var config = UIButton.Configuration.plain()
        config.title = category.title
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22.8, bottom: 0, trailing: 0)
        
        if case .freedom = category {
            config.baseForegroundColor = StumeetColor.primary700.color
        } else { config.baseForegroundColor = StumeetColor.gray400.color}

        let button = UIButton()
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        return button
    }
    
    private func updateIsHiddenCategoryItem(isHidden: Bool) {
        categoryStackViewContainer.isHidden = isHidden
    }
    
    private func checkNavigateToSettingVC(isEnable: Bool) {
        if isEnable {
            coordinator.goToStudyActivitySettingVC()
        } else {
            showSnackBar(text: "! 활동 작성이 완료되지 않았어요.")
        }
    }
    
    private func showSnackBar(text: String) {
        let snackBar = SnackBar(frame: .zero, text: text)
        
        view.addSubview(snackBar)
        
        snackBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.bottomView.snp.top).offset(-24)
            make.height.equalTo(74)
        }
        
        snackBar.isHidden = false
        snackBar.alpha = 0

        UIView.animate(withDuration: 0.3) {
            snackBar.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.3) {
                    snackBar.alpha = 0
                } completion: { _ in
                    snackBar.isHidden = true
                    snackBar.removeFromSuperview()
                }
            }
        }
    }
    
    private func updateCategoryItem(selectedCategory: ActivityCategory) {
        
        let categoryButtons: [ActivityCategory: UIButton?] = [
            .freedom: freedomButton,
            .meeting: meetingButton,
            .homework: homeWorkButton
        ]
        
        categoryButton.configuration?.attributedTitle = AttributedString(selectedCategory.title)
        
        categoryButtons.forEach { category, button in
            if category == selectedCategory {
                button?.configuration?.baseForegroundColor = StumeetColor.primary700.color
            } else {
                button?.configuration?.baseForegroundColor = .black
            }
        }
    }
    
    private func showMaxLengthContentSnackBar(text: String) {
        contentTextView.text = String(contentTextView.text?.dropLast() ?? "")
        showSnackBar(text: text)
    }
    
    private func setBeginEditingText() {
        contentTextView.text = ""
        contentTextView.textColor = StumeetColor.gray800.color
    }
}

// MARK: - PHPickerViewDelegate

extension CreateActivityViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()

        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.selecetedPhotoSubject.send(images)
            self.coordinator.dismiss()
        }
    }

    
    private func updateSnapshot(items: [UIImage]) {
        guard let datasource = datasource else { return }
        if items.isEmpty {
            photoCollectionView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            
            contentTextView.snp.makeConstraints { make in
                make.top.equalTo(seperationLine.snp.bottom).offset(6)
            }
        } else {
            photoCollectionView.snp.updateConstraints { make in
                make.height.equalTo(160)
            }
            
            contentTextView.snp.updateConstraints { make in
                make.top.equalTo(photoCollectionView.snp.bottom)
            }
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        items.forEach { snapshot.appendItems([.photoCell($0)]) }
        datasource.apply(snapshot)
    }
}

extension CreateActivityViewController: CreateActivityLinkDelegate {
    func didTapRegisterButton(link: String) {
        let imageAttachment = NSTextAttachment()
        let image = UIImage(resource: .createActivityLink).withTintColor(StumeetColor.primary700.color)
        imageAttachment.image = image
        let imageOffsetY: CGFloat = -(image.size.height - linkLabel.font.capHeight) / 2
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 24, height: 24)
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(attachment: imageAttachment))
        text.append(NSAttributedString(string: "  "))
        text.append(NSAttributedString(string: link))
        linkLabel.attributedText = text
        
        linkLabel.snp.updateConstraints { make in
            make.height.equalTo(56)
        }
    }
}
