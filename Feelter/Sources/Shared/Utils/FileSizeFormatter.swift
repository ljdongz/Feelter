//
//  FileSizeFormatter.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import Foundation

struct FileSizeFormatter {
    
    enum FileSizeStyle {
        case adaptive // 자동으로 적절한 단위 선택
        case decimal // 1000 단위 (KB, MB, GB)
        case binary // 1024 단위 (KiB, MiB, GiB)
        case bytes // 항상 바이트로 표시
    }
    
    // MARK: - 기본 포맷팅 메서드
    static func format(bytes: Int, style: FileSizeStyle = .adaptive) -> String {
        switch style {
        case .adaptive:
            return formatAdaptive(bytes: bytes)
        case .decimal:
            return formatDecimal(bytes: bytes)
        case .binary:
            return formatBinary(bytes: bytes)
        case .bytes:
            return formatBytes(bytes: bytes)
        }
    }
    
    // MARK: - iOS 스타일 (1000 단위, 자동 선택)
    private static func formatAdaptive(bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file  // iOS 파일 앱과 동일한 스타일
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    // MARK: - Decimal 단위 (1000 기준)
    private static func formatDecimal(bytes: Int) -> String {
        let units = ["B", "KB", "MB", "GB", "TB", "PB"]
        let divisor = 1000.0
        
        if bytes < 1000 {
            return "\(bytes) B"
        }
        
        var size = Double(bytes)
        var unitIndex = 0
        
        while size >= divisor && unitIndex < units.count - 1 {
            size /= divisor
            unitIndex += 1
        }
        
        if size >= 100 {
            return String(format: "%.0f %@", size, units[unitIndex])
        } else if size >= 10 {
            return String(format: "%.1f %@", size, units[unitIndex])
        } else {
            return String(format: "%.2f %@", size, units[unitIndex])
        }
    }
    
    // MARK: - Binary 단위 (1024 기준)
    private static func formatBinary(bytes: Int) -> String {
        let units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB"]
        let divisor = 1024.0
        
        if bytes < 1024 {
            return "\(bytes) B"
        }
        
        var size = Double(bytes)
        var unitIndex = 0
        
        while size >= divisor && unitIndex < units.count - 1 {
            size /= divisor
            unitIndex += 1
        }
        
        if size >= 100 {
            return String(format: "%.0f %@", size, units[unitIndex])
        } else if size >= 10 {
            return String(format: "%.1f %@", size, units[unitIndex])
        } else {
            return String(format: "%.2f %@", size, units[unitIndex])
        }
    }
    
    // MARK: - 항상 바이트로 표시
    private static func formatBytes(bytes: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return "\(formatter.string(from: NSNumber(value: bytes)) ?? "\(bytes)") bytes"
    }
    
}
