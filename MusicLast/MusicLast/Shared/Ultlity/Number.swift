//
//  Number.swift
//  MusicLast
//
//  Created by Macbook on 16/10/24.
//

import Foundation


func formatString(value: String) -> String? {
    guard let number = Double(value) else {
        return nil
    }

    if number >= 1_000_000 {
        // Định dạng cho triệu (M)
        let million = number / 1_000_000.0
        return String(format: "%.1fM", million)
    } else if number >= 1_000 {
        // Định dạng cho nghìn (K)
        let thousand = number / 1_000.0
        return String(format: "%.1fK", thousand)
    } else {
        // Trả về giá trị gốc nếu nhỏ hơn 1.000
        return String(number)
    }
}
