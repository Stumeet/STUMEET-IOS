//
//  StudyActivity.swift
//  Stumeet
//
//  Created by 정지훈 on 2/27/24.
//

import Foundation

struct Activity: Hashable {
    let tag: String?
    let title: String
    let content: String?
    let time: String?
    let place: String?
    let image: String?
    let name: String?
    let day: String?
    let status: String?
}

extension Activity {
    static let allData: [Activity] = [
        Activity(
            tag: "모임",
            title: "캠스터디",
            content: "이번주 캠스터디 진행합니다. 참여하시는 분들은 디디디디디",
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: "김철수",
            day: "2일 전",
            status: nil
        ),
        Activity(
            tag: "과제",
            title: "캠스터디",
            content: "이번주 캠스터디 진행합니다. 참여하시는 분들은 디디디디디",
            time: "2024.02.00 00:00",
            place: nil,
            image: nil,
            name: "김철수",
            day: "2일 전",
            status: nil
        ),
        Activity(
            tag: "자유",
            title: "캠스터디",
            content: "이번주 캠스터디 진행합니다. 참여하시는 분들은 디디디디디",
            time: nil,
            place: nil,
            image: nil,
            name: "김철수",
            day: "2일 전",
            status: nil
        ),
        Activity(
            tag: "과제",
            title: "캠스터디",
            content: "이번주 캠스터디 진행합니다. 참여하시는 분들은 디디디디디",
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: "김철수",
            day: "2일 전",
            status: nil
        )
    ]
    
    static let groupData: [Activity] = [
        Activity(
            tag: nil,
            title: "캠스터디1",
            content: nil,
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "시작 전"
        ),
        Activity(
            tag: nil,
            title: "캠스터디2",
            content: nil,
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "미참여"
        ),
        Activity(
            tag: nil,
            title: "캠스터디3",
            content: nil,
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "인정결석"
        ),
        Activity(
            tag: nil,
            title: "캠스터디4",
            content: nil,
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "출석"
        ),
        Activity(
            tag: nil,
            title: "캠스터디5",
            content: nil,
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "결석"
        ),
        Activity(
            tag: nil,
            title: "캠스터디6",
            content: nil,
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "지각"
        ),
        Activity(
            tag: nil,
            title: "캠스터디7",
            content: nil,
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "출석"
        ),
        Activity(
                tag: nil,
                title: "캠스터디8",
                content: nil,
                time: "2024.02.00 00:00",
                place: "서울여자대학교",
                image: nil,
                name: nil,
                day: nil,
                status: "출석"
        ),
        Activity(
            tag: nil,
            title: "캠스터디9",
            content: nil,
            time: "2024.02.00 00:00",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "출석"
        )
    ]
    
    static let taskData: [Activity] = [
        Activity(
            tag: nil,
            title: "캠스터디1",
            content: nil,
            time: "2024.02.23 23:59까지",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "시작 전"
        ),
        Activity(
            tag: nil,
            title: "캠스터디2",
            content: nil,
            time: "2024.02.23 23:59까지",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "미참여"
        ),
        Activity(
            tag: nil,
            title: "캠스터디3",
            content: nil,
            time: "2024.02.23 23:59까지",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "미수행"
        ),
        Activity(
            tag: nil,
            title: "캠스터디4",
            content: nil,
            time: "2024.02.23 23:59까지",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "수행"
        ),
        Activity(
            tag: nil,
            title: "캠스터디5",
            content: nil,
            time: "2024.02.23 23:59까지",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "미수행"
        ),
        Activity(
            tag: nil,
            title: "캠스터디6",
            content: nil,
            time: "2024.02.23 23:59까지",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "지각제출"
        ),
        Activity(
            tag: nil,
            title: "캠스터디7",
            content: nil,
            time: "2024.02.23 23:59까지",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "수행"
        ),
        Activity(
                tag: nil,
                title: "캠스터디8",
                content: nil,
                time: "2024.02.23 23:59까지",
                place: "서울여자대학교",
                image: nil,
                name: nil,
                day: nil,
                status: "수행"
        ),
        Activity(
            tag: nil,
            title: "캠스터디9",
            content: nil,
            time: "2024.02.23 23:59까지",
            place: "서울여자대학교",
            image: nil,
            name: nil,
            day: nil,
            status: "수행"
        )
    ]
}
