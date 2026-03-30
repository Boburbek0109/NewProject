//
//  ContentView.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 2/8/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.cyan, .green, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 10) {
                    Text(weatherData?.condition ?? "Loading weather...")
                        .font(.title)
                    if let weatherData = weatherData {
                        Text(weatherData.locationName)
                            .font(.title2)
                    }
                    
                    Image(systemName: weatherSymbolName(for: weatherData?.condition))
                        //.symbolRenderingMode(.multicolor)
                        .resizable()
                        .frame(width: 120, height: 120)
                    
                    Text("\(Date().formatted(.dateTime.day().month().weekday())) | \(Date().formatted(.dateTime.hour().minute()))")
                        .font(.title2)
                    
                    if let weatherData = weatherData {
                        Text("\(Int(weatherData.temperature.rounded()))°")
                            .font(.system(size: 60))
                            //.frame(width: 150)
                    } else {
                        ProgressView()
                    }
                        
                    
                    HStack(spacing: 8) {
                        Text("H:27")
                        Text("L:18")
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.ultraThinMaterial)
                            .frame(height: 150)
                            .padding()
                        
                        
                        HStack{
                            Spacer()
                            
                            VStack{
                                Image("rain.umbrella")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                
                                Text("80%")
                                Text("Rain")
                            }
                            Spacer()
                            
                            VStack{
                                Image("wind.speed")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Text("8km/h")
                                Text("Wind Speed")
                            }
                            Spacer()
                            
                            VStack{
                                Image("humidity")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Text("60%")
                                Text("Humidity")
                            }
                            Spacer()
                        }
                        
                    }
                    
                    HStack{
                        Text("Today")
                            .font(.title)
                            .foregroundStyle(Color.yellow)
                        
                        Spacer()
                        
                        NavigationLink("Next 7 days >") {
                            WeeklyWeather()
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal){
                        HStack(spacing: 16){
                            ForEach(0..<10){ i in
                                
                                let newDate = Calendar.current.date(byAdding: .hour, value: i, to: Date()) ?? Date()
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 90, height: 150)
                                        .opacity(0.3)
                                    
                                    VStack(spacing: 10){
                                        Text(newDate.formatted(.dateTime.hour()))
                                        
                                        Image(systemName: "cloud.sun")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        
                                        Text("25°")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                }
                .foregroundStyle(.white.gradient)
                .onAppear {
                    locationManager.requestLocation()
                }
                .onReceive(locationManager.$location) { location in
                    guard let location else { return }
                    fetchWeatherData(for: location)
                }
            }
        }
    }
    
    
    
    private func fetchWeatherData(for location: CLLocation) {
        let apiKey = "abc25637c8e72d3b22aec85adb7ef927"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        
        URLSession.shared.dataTask(with: url) {data, _ , error in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                
                DispatchQueue.main.async {
                    weatherData = WeatherData(locationName: weatherResponse.name,
                                              temperature: weatherResponse.main.temp,
                                              condition: weatherResponse.weather.first?.description ?? "")
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

    private func weatherSymbolName(for condition: String?) -> String {
        guard let condition else {
            return "cloud.sun.fill"
        }

        if condition.contains("rain") || condition.contains("drizzle") {
            return "cloud.rain.fill"
        }

        if condition.contains("clear") || condition.contains("sun") {
            return "sun.max.fill"
        }

        if condition.contains("thunder") {
            return "cloud.bolt.rain.fill"
        }

        if condition.contains("snow") {
            return "snow.fill"
        }

        if condition.contains("cloud") {
            return "cloud.fill"
        }

        return "cloud.sun.fill"
    }
    
}

#Preview {
    ContentView()
}
