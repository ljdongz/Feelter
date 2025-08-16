//
//  ChattingDateFormatter.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

final class CustomDateFormatter {
    static let shared = CustomDateFormatter()
    
    private let calendar: Calendar
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private lazy var monthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private lazy var yearMonthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private lazy var fullDateWithWeekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private init() {
        self.calendar = Calendar.current
    }
    
    func formatDate(_ date: Date) -> String {
        let now = Date()
        
        // 오늘인지 확인
        if calendar.isDate(date, inSameDayAs: now) {
            return timeFormatter.string(from: date)
        }
        
        // 어제인지 확인
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(date, inSameDayAs: yesterday) {
            return "어제"
        }
        
        // 같은 년도인지 확인
        let dateYear = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: now)
        
        if dateYear == currentYear {
            return monthDayFormatter.string(from: date)
        } else {
            return yearMonthDayFormatter.string(from: date)
        }
    }
    
    /// 어떤 날짜든 '2025.8.14 목요일' 형식으로 포맷팅
    func formatFullDateWithWeekday(_ date: Date) -> String {
        return fullDateWithWeekdayFormatter.string(from: date)
    }
    
    /// 어떤 날짜든 시간만 표시 (오후 8:00, 오전 12:32)
    func formatTimeOnly(_ date: Date) -> String {
        return timeFormatter.string(from: date)
    }
}
