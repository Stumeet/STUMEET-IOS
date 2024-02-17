//
//  ContentView.swift
//  Stumeet
//
//  Created by Hohyeon Moon on 2/5/24.
//

import SwiftUI

struct FirstViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationContorller = UINavigationController()
        let registerCoordinator = RegisterCoordinator(navigationController: navigationContorller)
        registerCoordinator.start()
        
        return navigationContorller
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

struct ContentView: View {
    @State private var isShowingProfileVC = false

    var body: some View {
        VStack {
            Button("프로필 변경하기") {
                self.isShowingProfileVC = true
            }
            .fullScreenCover(isPresented: $isShowingProfileVC) {
                FirstViewControllerWrapper()
            }
        }
    }
}


#Preview {
    ContentView()
}
