//
//  HourModel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/25/26.
//

import SwiftUI
import Foundation


func WeatherModel(day: String, icon: String, title: String, high: Int, low: Int) -> some View{
    HStack{
        Text(day)
            .frame(width: 60, alignment: .leading)
        
        Image(systemName: icon)
            .resizable()
            .frame(width: 40, height: 40)
            .symbolRenderingMode(.multicolor)
        
        Text(title)
        
        Spacer()
        
        Text("\(high)° / \(low)°")
            .font(.body)
            .opacity(0.6)
    }
}

