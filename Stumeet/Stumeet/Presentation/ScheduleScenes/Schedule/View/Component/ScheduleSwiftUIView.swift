//
//  ScheduleSwiftUIView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/24.
//

import SwiftUI

struct ScheduleSwiftUIView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CalenderSwiftUIView(viewModel: viewModel)
            
            lineView
            
            GeometryReader { geometry in
                ScrollView {
                    if viewModel.scheduleDetailList.count > 0 {
                        ForEach(viewModel.scheduleDetailList) { schedule in
                            detailScheduleView(schedule)
                            lineView
                        }
                    } else {
                        nonScheduleView
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(schedule.displayTitle)
                    .font(Font(StumeetFont.bodyMedium16.font))
                    .foregroundStyle(Color(StumeetColor.gray700.color))
                    .lineLimit(1)
                    .padding(.top, -1)
                
                Spacer()
                
                if let state = schedule.displayState {
                    stateBadgeView(state)
                }
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    switch schedule.type {
                    case .homework:
                        Image(.clock)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text(schedule.displayEndTime)
                            .font(Font(StumeetFont.captionMedium13.font))
                            .foregroundStyle(Color(StumeetColor.gray300.color))
                            .lineLimit(1)
                    case .meeting:
                        Image(.clock)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text(schedule.displayStartTiem)
                            .font(Font(StumeetFont.captionMedium13.font))
                            .foregroundStyle(Color(StumeetColor.gray300.color))
                            .lineLimit(1)
                    default:
                        EmptyView()
                    }
                }
                
                HStack(spacing: 4) {
                    switch schedule.type {
                    case .meeting:
                        Image(.marker)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text(schedule.displayLocation)
                            .font(Font(StumeetFont.captionMedium13.font))
                            .foregroundStyle(Color(StumeetColor.gray300.color))
                            .lineLimit(1)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .padding(.top, 22)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
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
