//
//  CalenderViewSwiftUIView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/24.
//

import SwiftUI

struct CalenderSwiftUIView<ViewModel: CalenderViewModel>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            dateHeaderView
            lineView
            dayOfTheWeekView
            calendarGridView
                .padding(.horizontal, 18)
        }
    }
    
    private var lineView: some View {
        Color(StumeetColor.gray75.color)
            .frame(height: 1)
    }
    
    private var dateHeaderView: some View {
        HStack(spacing: 0) {
            Text(viewModel.currentMonthString)
                .font(Font(StumeetFont.subTitleSemiBold.font))
                .foregroundStyle(Color(StumeetColor.gray800.color))
            
            Spacer()
            
            Button(action: {
                viewModel.changeMonth(by: -1)
            }, label: {
                Image(.Calendar.iconArrowLeft)
                    .frame(width: 32, height: 32)
            })
            .buttonStyle(.plain)
            .disabled(viewModel.isLeftButtonDisable)

            
            Button(action: {
                viewModel.changeMonth(by: 1)
            }, label: {
                Image(.Calendar.iconArrowRight)
                    .frame(width: 32, height: 32)
            })
            .buttonStyle(.plain)
            .disabled(viewModel.isRightButtonDisable)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    private var dayOfTheWeekView: some View {
        HStack(spacing: 5) {
            ForEach(Calendar.korean.veryShortWeekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(Font(StumeetFont.captionMedium12.font))
                    .foregroundStyle(Color(StumeetColor.gray400.color))
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 32)
        .padding(.bottom, 5)
        .padding(.horizontal, 18)
    }

    private var calendarGridView: some View {
        let daysInMonth: Int = viewModel.numberOfDays()
        let firstWeekday: Int = viewModel.firstWeekdayOfMonth() - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                    } else {
                        let date = viewModel.getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        let selected = viewModel.checkIfSelectedDate(date)
                        let isEvent = viewModel.checkEventForSelectedDate(date)
                        
                        CellView(day: day,
                                 date: date,
                                 selected: selected,
                                 isEvent: isEvent)
                            .onTapGesture {
                                viewModel.setSelectedDate(date)
                            }
                    }
                }
            }
        }
    }
}

private struct CellView: View {
    var day: Int
    var date: Date
    var selected: Bool = false
    var isEvent: Bool = false
    
    init(day: Int, date: Date, selected: Bool, isEvent: Bool) {
        self.day = day
        self.date = date
        self.selected = selected
        self.isEvent = isEvent
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if selected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(StumeetColor.primary100.color))
                        .frame(width: 32, height: 32)
                }
                
                Text(String(day))
                    .font(Font(StumeetFont.bodyMedium16.font))
                    .foregroundStyle(Color(date.dateString == Date().dateString ? StumeetColor.primary700.color : StumeetColor.gray800.color))
                    .frame(width: 32, height: 32)
            }
            
            if isEvent {
                Circle()
                    .fill(Color(StumeetColor.primary700.color))
                    .frame(width: 8, height: 8)
                    .padding(.top, 4)
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 56)
    }
}
