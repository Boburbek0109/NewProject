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
        
        VStack{
            Image(systemName: iconName)
                .resizable()
                .frame(width: 45, height: 45)
            
            Text(value)
            Text(title)
        }
    }
}

