//
//  PdfList.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import Foundation

class PdfList {
    let itemList = ["aws_reInvent", "kb_economy", "kb_real_estate", "swift_basic", "swift_practice", "swift_programing", "kb_real_estate"]
    
    func titleMap(_ titleString: String) -> String {
        switch titleString {
        case "aws_reInvent":
            return Title.aws_reInvent.rawValue
        case "kb_economy":
            return Title.kb_economy.rawValue
        case "kb_real_estate":
            return Title.kb_real_estate.rawValue
        case "swift_basic":
            return Title.swift_basic.rawValue
        case "swift_practice":
            return Title.swift_practice.rawValue
        case "swift_programing":
            return Title.swift_programing.rawValue
        default:
            return ""
        }
    }
    
    func originalFileName(_ titleString: String) -> String {
        switch titleString {
        case "aws_reInvent":
            return "[AWS reInvent 2022] 클라우드의 혁신 그리고 진화_vf.pdf"
        case "kb_economy":
            return "수소경제의 최근 동향과 전망.pdf"
        case "kb_real_estate":
            return "2022 KB 부동산 보고서.pdf"
        case "swift_basic":
            return "꼼꼼한 재은씨의 스위프트 기본편.pdf"
        case "swift_practice":
            return "꼼꼼한 재은씨의 스위프트 실전편.pdf"
        case "swift_programing":
            return "스위프트 프로그래밍 3판.pdf"
        default:
            return ""
        }
    }
}

enum Title: String {
    case aws_reInvent = "클라우드의 혁신 그리고 진화"
    case kb_economy = "수소경제의 최근 동향과 전망"
    case kb_real_estate = "KB부동산 보고서"
    case swift_basic = "스위프트 기본편"
    case swift_practice = "스위프트 실전편"
    case swift_programing = "스위프트 프로그래밍"
}
