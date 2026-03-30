//
//  WeeklyWeather.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 3/25/26.
//

import SwiftUI

struct WeeklyWeather: View {
    var body: some View {
        ZStack{
            LinearGradient(colors: [.cyan, .green, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack{
                TommorowView()
                
                DaysView()
                
            }
        }
    }
}


#Preview {
    WeeklyWeather()
}
