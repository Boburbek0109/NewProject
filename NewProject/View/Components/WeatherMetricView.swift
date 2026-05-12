//
//  WeatherMetricView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/2/26.
//

import SwiftUI

struct WeatherMetricView: View{
    let iconName: String
    let value: String
    let title: String
    
    var body: some View{
        
        VStack(spacing: 6){
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            
            Text(value)
                .font(.subheadline)
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}
