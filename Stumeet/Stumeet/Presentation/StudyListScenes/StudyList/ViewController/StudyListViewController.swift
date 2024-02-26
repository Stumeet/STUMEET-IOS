//
//  StudyListViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/21/24.
//

import UIKit

class StudyListViewController: BaseViewController {

    let button: UIButton = {
        return UIButton().makeRegisterBottomButton(text: "활동", color: .black)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        button.tapPublisher
            .sink { _ in
                let vc = StudyActivityViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
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
