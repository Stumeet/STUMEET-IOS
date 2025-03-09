//
//  CalenderScheduleSwiftUIView.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/20.
//

import SwiftUI

struct CalenderScheduleSwiftUIView<ViewModel: CalenderViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CalenderSwiftUIView(viewModel: viewModel)
            
            lineView
            
            GeometryReader { geometry in
                ScrollView {
                    if viewModel.scheduleDetailList.count > 0 {
                        ForEach(viewModel.scheduleDetailList) { schedule in
                            detailScheduleView(schedule)
                        }
                        
                    } else {
                        nonScheduleView
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .safeAreaInset(edge: .top, spacing: 0) {
                    Spacer().frame(height: 16)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Spacer().frame(height: 16)
                }
                
            }
        }
        .background(.white)
        .onAppear {
            viewModel.loadData.send()
        }
    }
    
    private var lineView: some View {
        Rectangle()
            .fill(Color(StumeetColor.primary50.color))
            .frame(maxWidth: .infinity, maxHeight: 1)
    }
    
    private func detailScheduleView(_ schedule: ScheduleItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(schedule.displayStudyName)
                    .lineLimit(1)
                    .font(Font(StumeetFont.captionMedium13.font))
                    .foregroundStyle(Color(StumeetColor.gray400.color))
                    
                Spacer()
                
                Text(schedule.type?.title ?? "알 수 없음")
                    .lineLimit(1)
                    .font(Font(StumeetFont.captionMedium13.font))
                    .foregroundStyle(Color(StumeetColor.gray400.color))
            }
            
            Text(schedule.displayTitle)
                .lineLimit(1)
                .font(Font(StumeetFont.bodysemibold.font))
                .foregroundStyle(Color(StumeetColor.gray800.color))
                .padding(.top, 12)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(.clock)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text(schedule.displayDate)
                            .font(Font(StumeetFont.captionMedium13.font))
                            .foregroundStyle(Color(StumeetColor.gray300.color))
                    }
                    
                    if let displayLocation = schedule.activity.place {
                        HStack(spacing: 4) {
                            Image(.marker)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            
                            Text(displayLocation)
                                .font(Font(StumeetFont.captionMedium13.font))
                                .foregroundStyle(Color(StumeetColor.gray300.color))
                        }
                    }
                }
                    
                Spacer()
                
                Text(schedule.displayRemainingTime)
                    .font(Font(StumeetFont.bodyMedium14.font))
                    .foregroundStyle(Color(schedule.isTimeExpired ? StumeetColor.gray300.color : StumeetColor.primary700.color))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .background(Color(schedule.isTimeExpired ? StumeetColor.gray75.color : StumeetColor.primary50.color))
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color(StumeetColor.gray50.color))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }
    
    private func stateBadgeView(_ state: ActivityState) -> some View {
        Text(state.rawValue)
            .font(Font(StumeetFont.bodyMedium14.font))
            .foregroundStyle(Color(state.primaryColor))
            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
            .background(Color(state.secondaryColor))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var nonScheduleView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(.Common.tablerCheckupList)
            Text("일정이 없어요")
                .font(Font(StumeetFont.bodyMedium16.font))
                .foregroundStyle(Color(StumeetColor.gray300.color))
            
            Spacer()
        }
    }
}
