//
//  CoreImageManager.swift
//  Feelter
//
//  Created by 이정동 on 8/26/25.
//

import CoreImage
import UIKit

struct FilterChange {
    let filterType: FilterAttributeType
    let beforeValue: Float
    let afterValue: Float
}

final class CoreImageManager {
    static let context = CIContext()
    
    private var originCIImage: CIImage?
    
    private(set) var undoStack: [FilterChange] = []
    private(set) var redoStack: [FilterChange] = []
    private var currentState: [FilterAttributeType: Float] = [:]
    
    init(originalImage: UIImage) {
        let ciImage = CIImage(image: originalImage)
        self.originCIImage = ciImage
    }
    
    func filterStateValue(for type: FilterAttributeType) -> Float {
        currentState[type] ?? type.filter.parameter.defaultValue
    }
    
    func applyFilter(type: FilterAttributeType, value: Float) -> UIImage? {
        // 현재 상태를 복사하고 임시로 새 값 추가 (실시간 미리보기용)
        var tempState = currentState
        tempState[type] = value
        
        // 임시 상태로 우선순위 정렬하여 필터 적용
        return applyFilters(tempState)
    }
    
    func appendHistory(type: FilterAttributeType, value afterValue: Float) {
        let beforeValue = filterStateValue(for: type)
        
        // 값이 변경된 경우에만 히스토리 추가
        guard beforeValue != afterValue else { return }
        
        let change = FilterChange(
            filterType: type,
            beforeValue: beforeValue,
            afterValue: afterValue
        )
        undoStack.append(change)
        redoStack.removeAll() // 새로운 변경 시 redo 스택 초기화
        
        // 현재 상태에 새 값 저장
        currentState[type] = afterValue
    }
    
    func undo() -> UIImage? {
        guard let lastChange = undoStack.popLast() else { return nil }
        
        // Redo 스택에 현재 변경사항 저장
        redoStack.append(lastChange)
        
        // 현재 상태를 이전 값으로 되돌리기
        if lastChange.beforeValue == lastChange.filterType.filter.parameter.defaultValue {
            currentState.removeValue(forKey: lastChange.filterType)
        } else {
            currentState[lastChange.filterType] = lastChange.beforeValue
        }
        
        // 현재 상태로 이미지 생성
        return applyFilters(currentState)
    }
    
    func redo() -> UIImage? {
        guard let change = redoStack.popLast() else { return nil }
        
        // Undo 스택에 다시 저장
        undoStack.append(change)
        
        // 현재 상태를 다시 적용 값으로 변경
        currentState[change.filterType] = change.afterValue
        
        // 현재 상태로 이미지 생성
        return applyFilters(currentState)
    }
}

extension CoreImageManager {
    
    private func applyFilters(_ state: [FilterAttributeType: Float]) -> UIImage? {
        guard let originalImage = originCIImage else { return nil }
        
        // 우선순위 순서로 필터 정렬
        let sortedFilters = state
            .compactMap { (filterType: FilterAttributeType, value: Float) -> (FilterAttributeType, Float)? in
                // 기본값이 아닌 것만 필터링
                guard value != filterType.filter.parameter.defaultValue else { return nil }
                return (filterType, value)
            }
            .sorted { $0.0.priority < $1.0.priority }
        
        // 원본 이미지부터 순차적으로 필터 적용
        var result = originalImage
        for (filterType, value) in sortedFilters {
            guard let filteredCIImage = applyFilter(result, filter: filterType.filter, value: value),
                  let ciImage = CIImage(image: filteredCIImage) else { continue }
            result = ciImage
        }
        
        // 최종 UIImage로 변환
        guard let cgImage = Self.context.createCGImage(result, from: result.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    private func applyFilter(_ ciImage: CIImage?, filter: CoreImageFilter, value: Float) -> UIImage? {
        guard let ciImage,
              let ciFilter = CIFilter(name: filter.name) else { return nil }
        
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // TODO: 수정 필요
        switch filter.parameter.valueType {
        case .number:
            ciFilter.setValue(value, forKey: filter.parameter.key)
        case .vector:
            let vector = CIVector(x: CGFloat(value), y: 0)
            ciFilter.setValue(vector, forKey: filter.parameter.key)
        }
        
        return createUIImage(from: ciFilter, originalExtent: ciImage.extent)
    }
    
    private func createUIImage(from filter: CIFilter, originalExtent: CGRect) -> UIImage? {
        guard let outputImage = filter.outputImage,
              let cgImage = Self.context.createCGImage(
                outputImage,
                from: originalExtent
              ) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}

