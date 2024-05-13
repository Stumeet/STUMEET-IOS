//
//  StudyListViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/21/24.
//

import UIKit

class StudyListViewController: BaseViewController {

    // MARK: - UIComponents
    
    let button: UIButton = {
        return UIButton().makeRegisterBottomButton(text: "활동", color: .black)
    }()
    
    // MARK: - Properties
    
    private let coordinator: StudyListNavigation
    
    // MARK: - Init
    
    init(coordinator: StudyListNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        button.tapPublisher
            .sink(receiveValue: coordinator.goToStudyActivityList)
            .store(in: &cancellables)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
