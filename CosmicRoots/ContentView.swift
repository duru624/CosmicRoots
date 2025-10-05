//
//  ContentView.swift
//  CosmicRoots
//
//  Created by Esra Ataç on 14.09.2025.
//

import SwiftUI


@main
struct CosmicRootsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// HEX Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// First Page
struct ContentView: View {
    @State private var showLogin = false
    var body: some View {
        VStack(spacing:10){
            if let _ = UIImage(named: "icon") {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
            }
            Text("Welcome")
                .font(.system(size:36))
            Text("")
            Text("to Türkiye's first agricultural application for farmers and Anatolian people.")
                .font(.system(size:16))
                .multilineTextAlignment(.center)
            Text("")
            Text("“The foundation of the national economy is agriculture. If the vast majority of our nation were not farmers, we would not be on Earth today.”")
            Text("– M. K. Atatürk")
                .font(.system(size:12))
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: { showLogin = true }) {
                Text("Get Started!")
                    .padding(20)
                    .background(Color(hex: "#4CAF50"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showLogin) {
                KayıtGirişView()
            }
        }
        .padding()
    }
}

// Rounded Header
struct RoundedHeader: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "0f321e")
                .clipShape(RoundedCorner(radius: 28))
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                Image("icon").resizable().frame(width: 200, height:200)
            }
            .padding(.bottom, 24)
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 20
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: radius, height: radius))
        return path
    }
}

// Button Styles
struct FillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(Color(Color(hex: "#EBAB3B")))
            .foregroundColor(.white)
            .cornerRadius(22)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius:22).stroke(Color.green, lineWidth: 2)
            )
            .foregroundColor(Color.green)
            .background(Color.clear)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct ToolButton<Destination: View>: View {
    var title: String
    var image: String
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 10) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 4)
        }
    }
}

// Login/Signup
struct KayıtGirişView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                RoundedHeader().frame(height: 350)
                Spacer()
                NavigationLink(destination: SignUpView()) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(OutlineButtonStyle())
                NavigationLink(destination: LoginView()) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(OutlineButtonStyle())
            }
            .padding()
            .navigationBarHidden(true)
            .background(Color(hex: "0f321e"))
        }
    }
}

// Sign Up View
struct SignUpView: View {
    @AppStorage("savedUsername") private var savedUsername: String = "User"
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack(spacing:20) {
            RoundedHeader().frame(height: 200)
            
            VStack(spacing: 20) {
                TextField("User Name", text: $name)
                TextField("E-Mail Address", text: $email)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
                SecureField("Repeat Password", text: $password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 28)
            
            Button(action: signUp) {
                Text("Sign In").frame(maxWidth: .infinity)
            }
            .buttonStyle(FillButtonStyle())
            .padding(.horizontal, 28)
            Spacer()
        }
        .navigationBarTitle("Sign In", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Done"),
                  message: Text("Signed in successfully! You can log in now."),
                  dismissButton: .default(Text("OK!")) {
                    presentation.wrappedValue.dismiss()
                  })
        }
    }
    
    func signUp() {
        guard !email.isEmpty, !password.isEmpty else {return}
        UserDefaults.standard.set(email, forKey: "savedEmail")
        UserDefaults.standard.set(password, forKey: "savedPassword")
        savedUsername = name
        showAlert = true
    }
}

// Login View
struct LoginView: View {
    @State private var isLoggedIn = false
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            RoundedHeader()
                .frame(height: 220)
                .ignoresSafeArea(edges: .top)

            VStack(spacing: 20) {
                Text("Log In")
                    .font(.largeTitle)

                TextField("User Name", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                NavigationLink(destination: MainView(), isActive: $isLoggedIn) {
                    Button("Log In") {
                        if !username.isEmpty && !password.isEmpty {
                            isLoggedIn = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#EBAB3B"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Main View
struct MainView: View {
    @AppStorage("savedUsername") private var savedUsername: String = "User"
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherManager = WeatherManager()
    @State private var showMenu = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        HStack{
                            // Welcome Header
                            Text("Welcome \(savedUsername),")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#262525"))
                                .padding(.horizontal)
                                .padding(.top)
                            Spacer()
                            // Top Menu
                            Button(action:{
                                withAnimation(.easeInOut){
                                    showMenu.toggle()
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .padding()
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)
                        
                        // Featured Article Card
                        VStack(alignment: .leading, spacing: 8) {
                            Image("farmers view")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .clipped()
                                .cornerRadius(15)
                            
                            Text("Modern Irrigation Techniques")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text("Increasing populations and water demands necessitate efficient irrigation methods in agriculture. Drip, sprinkler, and smart systems save up to 70% of water and increase yields by up to 40%. Modern irrigation both protects the environment and offers farmers an economic advantage.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                            
                            NavigationLink(destination: SulamaTek()) {
                                Text("About 5 minutes of reading →")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#591212"))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                        
                        // Today's Insights
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Today's Insights")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            VStack(spacing: 12) {
                                // Şehir girişi
                                HStack {
                                    TextField("Enter your city...", text: $locationManager.city)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    Button(action: {
                                        Task {
                                            await locationManager.fetchCoordinates()
                                            if let lat = locationManager.latitude,
                                               let lon = locationManager.longitude {
                                                await weatherManager.fetchWeather(lat: lat, lon: lon)
                                                print("🌤️ Weather fetched: \(weatherManager.temperature ?? -999)")
                                            } else {
                                                print("❌ Coordinates missing")
                                            }
                                        }
                                    }) {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color(hex: "#236D43"))
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                                // 🔹 Mini Hava Durumu Kart
                                if let _ = weatherManager.temperature {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(locationManager.city)
                                                .font(.headline)
                                            Text("\(Int(weatherManager.temperature ?? 0))°C")
                                                .font(.largeTitle)
                                                .fontWeight(.bold)
                                            Text(weatherManager.condition ?? "weather")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: weatherManager.icon ?? "cloud.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.yellow)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#F7D470"))
                                    .cornerRadius(15)
                                }
                            }
                            
                            // Alt kısımdaki küçük linkler
                            VStack(spacing: 10) {
                                NavigationLink(destination: RecentHumidity()) {
                                    HStack {
                                        Image("soil")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                        Text("Recent Soil Humidity")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                                
                                NavigationLink(destination: RainfallForecast()) {
                                    HStack {
                                        Image("rainfall")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                        Text("Rainfall Forecast")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                        
                        // Quick Access Tools
                        Text("Quick Access Tools")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ToolButton(title: "Soil Humidity", image: "soil", destination: Soil())
                            ToolButton(title: "Weather", image: "weather", destination: Weather())
                            ToolButton(title: "Water Levels", image: "water", destination: Water())
                            ToolButton(title: "Soil Quality", image: "SQuality", destination: SQuality())
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                if showMenu {
                    Color.black.opacity(0.3) // arka plan karartma
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showMenu = false }
                        }
                        .zIndex(0)
                    SideMenuView(showMenu: $showMenu)
                        .frame(width: 260)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }
                // kategoriler
            }
            .animation(.easeInOut, value: showMenu)
        }
    }
    
    
    // Other Pages
    struct SideMenuView: View {
        @Binding var showMenu: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 25) {
                HStack {
                    Image(systemName: "leaf.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                    Text("Menu")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.top, 60)
                
                Divider()
                
                // 🔹 Menü bağlantıları
                NavigationLink(destination: FarmerView()) {
                    Label("Farmer", systemImage: "leaf.fill")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    withAnimation(.easeInOut) { showMenu = false }
                })
                
                NavigationLink(destination: BlogPage()) {
                    Label("Blog", systemImage: "book.fill")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    withAnimation(.easeInOut) { showMenu = false }
                })
                
                NavigationLink(destination: ChildView()) {
                    Label("Children", systemImage: "gamecontroller.fill")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    withAnimation(.easeInOut) { showMenu = false }
                })
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: 250, alignment: .leading)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .shadow(radius: 10)
        }
    }
    
    struct BlogPage: View {
        var body : some View {
            VStack {
                ScrollView {
                    Text ("Cosmic Roots Blog ")
                        .font(.largeTitle)
                        .foregroundStyle(Color.black)
                    Spacer()
                    NavigationLink(destination: SoilAnalysis()) {
                        HStack {
                            VStack {
                                Spacer()
                                Text("SOIL ANALYSIS")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                Text("Soil analysis is a key process that studies the physical, chemical, and biological properties of soil to optimize fertilization, improve efficiency, and protect the environment for sustainable agriculture.")
                                    .foregroundStyle(Color.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Image("soil2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(30)
                                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }
                    .background(Color(Color(hex: "#d9d9d9")))
                    NavigationLink(destination: Fertilizer()) {
                        HStack {
                            VStack {
                                Spacer()
                                Text("FERTILIZER PRODUCTION AND CONSUMPTION IN TURKIYE")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                Text("Fertilizer use in Turkey boosts productivity and food security, but import dependence and limited organic use highlight the need for sustainable practices and stronger farmer support.")
                                    .foregroundStyle(Color.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Image("fertilizer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(30)
                                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }
                    .background(Color(Color(hex: "#d9d9d9")))
                    NavigationLink(destination: PlantDiseases()) {
                        HStack {
                            VStack {
                                Spacer()
                                Text("PLANT DISEASES")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                Text("Plant diseases, caused by biotic and abiotic factors, reduce crop yield and quality worldwide, and in Turkey they significantly affect major crops making integrated pest management, biological control, and smart farming technologies essential for sustainable agriculture.")
                                    .foregroundStyle(Color.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Image("diseases")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(30)
                                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }
                    .background(Color(Color(hex: "#d9d9d9")))
                    NavigationLink(destination: Products()) {
                        HStack {
                            VStack {
                                Spacer()
                                Text("COMMON IN TURKIYE'S PRODUCTS")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                Text("With its rich climate diversity and fertile lands, Turkey stands out as a global agricultural hub, cultivating everything from staple grains and legumes to valuable fruits, vegetables, and industrial crops that drive both domestic consumption and export growth.")
                                    .foregroundStyle(Color.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Image("products")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(30)
                                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }
                    .background(Color(Color(hex: "#d9d9d9")))
                    NavigationLink(destination: WaterUsage()) {
                        HStack {
                            VStack {
                                Spacer()
                                Text("WATER USAGE ")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                Text("Turkiye’s limited freshwater resources are increasingly strained by agriculture, industry, population growth, and climate change, making the adoption of modern irrigation systems and sustainable water management crucial for the country’s future.")
                                    .foregroundStyle(Color.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Image("waterU")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(30)
                                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }
                    .background(Color(Color(hex: "#d9d9d9")))
                    NavigationLink(destination: SulamaTek()) {
                        HStack {
                            VStack {
                                Spacer()
                                Text("MODERN IRRIGATION TECHNIQUES ")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                Text("Rising population and water demand make efficient irrigation vital. Drip, sprinkler, micro, and smart systems save up to 70% water and boost yield by 40%, protecting the environment and supporting farmers economically.")
                                    .foregroundStyle(Color.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Image("irrigation")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .cornerRadius(30)
                                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }
                    .background(Color(Color(hex: "#d9d9d9")))
                    NavigationLink(destination: ndvi()) {
                        HStack {
                            VStack {
                                Spacer()
                                Text("NORMALIZED DIFFERENCE VEGETATION INDEX")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                Text("NDVI is a satellite-based index that measures vegetation health and density using red and near-infrared light, widely applied in Turkey for monitoring agriculture, drought, and ecological changes.")
                                    .foregroundStyle(Color.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Image("ndvi")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                    }
                    .background(Color(Color(hex: "#d9d9d9")))
                }
                .background(Color(Color(hex: "#E6E6E6")))
            }
        }
    }
    
    struct SoilAnalysis: View {
        var body: some View {
            ScrollView {
                Image("soil2")
                    .frame(width: 30, height: 30)
                Text("Soil Analysis")
                    .bold(true)
                Text("""
                     Soil analysis in agriculture, increase efficiency, correct fertilization of plants avoid damage to the environment and meet the needs of the soil physical, chemical and biological properties of the study in a laboratory environment.
                     Through this analysis, soil structure, nutrient availability, pH, salinity, organic matter, moisture many factors such as capacity is revealed.
                     Ensure efficiency in agriculture, soil analysis, to prevent waste of water, adequate and proper fertilizer use, environmental protection, and the soil is very important and necessary for the long-term health.
                      
                     Soil analysis, physical analysis,chemical analysis,biological analysis, and 4 Special analysis on the basis of types are there.
                      
                     1.      Soil physical analysis:this analysis of soil structure ,texture , and water Relations shows. Irrigation plan, and efficiency is important. In its own right, separate topics is divided into.These;Texture (Texture) Analysis: Sand, silt and clay ratio is measured.Water holding capacity: irrigation scheduling is used.Bulk density and porosity: Stuck soils, root growth becomes more difficult.Soil color and its structure: indicate the presence of organic matter and minerals.
                     2.      Soil chemical analysis:analysis of fertilization farmers directly for the analysis uncovered in Turkey, the most common is a kind of.pH Analysis, Salinity (EC) Analysis, organic analysis, nutrient Analysis, macro elements: Nitrogen (n), phosphorus (P), potassium (K), Calcium (We), magnesium (mg), sulfur (s). Micro-elements: iron (Fe), Zinc (Zn), boron (B), Copper (Fr), manganese (Mn). Lime (CaCO₂ ) Analysis
                     3.       Biological soil analysis is not yet very common in Turkey, is done in universities and research institutes. Microorganism count; bacteria, fungi, actinomycetes of the density.Soil respiration test; shows the vitality of Soil enzyme activitymeasurement, Phosphatase, dehydrogenase enzymes, such as with the health of the soil is measured. Organic carbon Analysis: in terms of climate change and the carbon cycle is critical.
                     4.      Special soil analysis: areas and industrial agriculture is done at the risk of environmental pollution. Analysis of heavy metal (Pb, Cd, as, HG, etc.) Pesticide residues, Radioactivity Measurements, Sodium Hazard (ESP, SAR)
                     """)
                Image("soilgraph1")
                    .frame(width: 30, height: 30)
                Text("""
                     Chemical analysis → the most common (over 80%, the majority of the analysis).
                     o    pH, salinity, organic matter, macro/micro nutrients.
                     ·         Physical analysis → less (%around 10-15).
                     o    Water holding capacity, texture, bulk density.
                     ·         Biological analysis → very limited (1-2% in the vicinity of).
                     o    Usually universities and research projects.
                     ·         Special analysis (heavy metals, pesticides, radioactivity, etc.) → Is below 1%.
                     o    Environmental risk areas, or special projects is done.
                      
                     SOIL ANALYSIS IS DONE HOW?
                     The entry field of homogeneous regionsare.
                     D 0-20 cm Depth from a zigzag in the form of a 5-10 point the sample is taken.
                     The current received mixed samples are placed in a clean bag.
                     Tagged entries sent to the laboratory.
                     The current analysis of the results showed that fertilization and irrigation plan is prepared.
            """)
                Image("soilgraph2")
                    .frame(width: 30, height: 30)
                Text("""
Regional Distribution Of Soil Analysis In Turkey
□ OfAegean and Marmara → is the highest rate (30-35%).
□ Ofinner Anatolia → intermediate level (%20-25).
□ Ofthe Black Sea → lower (15-20% about).
□ Ofeastern and southeastern Anatolia → the lowest rate (by 10-15%).
 
In Turkey, farmers only 20-25% percent of soil analysis, having done this wrong situation and more with fertilization, environmental damage, such as loss of yield many problems it brings. Some universities in Turkey and the ministry is working to increase this ratio.
""")
                NavigationLink(destination: BlogPage()) {
                    Text("READ MORE OF OUR BLOGS")
                        .foregroundStyle(Color(hex: "#EBAB3B"))
                }
            }
        }
    }
    struct Products: View {
        var body: some View {
            ScrollView {
                Image("products")
                    .frame(width: 30, height: 30)
                Text("Common in Turkiye' Products")
                    .bold(true)
                Text("""
Thanks to the diversity of Turkiye's soil and climate , a lot of suitable conditions for the growth of the product provided. October Area, production quantity, economic value, export, share, and climate/soil suitability using criteria such as “most produced, used, that are most convenient to be produced” as products are determined.
Grains and legumes; covers the largest portion of agricultural land in Turkiye.
·         Wheat
o    Annual production: ~20 million tons (TSI, 2023).
o    Most central Anatolia, Southeast Thrace is produced.
o    Turkey's main product is food safety.

·         Barley
o    Annual production: ~8.5 million tons.
o    As feed for livestock is critical.

·         Sweetcorn
o    ~9 million tons.
o    Cukurova, in the southeast the Black Sea and stands out.

·         Lentils (especially red)
o    Turkey production in the top 3 in the world.
o    In the Southeast intensive.

·         Chickpeas
o    Turkey, chickpea is the world's largest producers.
o    Leading central Anatolia and Southeast.
 
FRUITS;
 Turkey, thanks to the diversity of climate, is contained in the first 5 in the world.

   Nuts
Annual production: ~700 thousand tons.
The world's production of 60%+click from the Black Sea.

   Grape
~4 million tons.
Aegean (Manisa), central Anatolia and southeastern important.

   Apricot
Malatya apricot production of the world alone provides 50%.

   Apple
~4.5 million tons.
Nigde, Isparta, Karaman, Konya in front of him.

   Olive
~2 million tonnes (table + oil).
Turkey, Spain and Italy in the top 3.
 
 
VEGETABLES;
  Vegetable production in Turkey takes the first place in Europe.
  Tomato
~13 million tons.
Important exports, particularly Russia and the Middle East.
  Pepper
~3 million tons.
  Potatoes
~5 million tons.
Niğde, Nevşehir, Afyon, Konya is the center of.
 Onion
~2.5 million tons.
Ankara, Amasya, Çorum, and Yozgat, in front of.
Industrial Crops;high economic value and strategic products.

 Cotton
~2.5 million tons of cotton.
The southeastern Anatolia Project (gap) has increased thanks to production
.
 Sunflower
Thrace and Anatolia.
In Turkey, the need for oil is critical.

Sugar Beet
~20 million tons.
Konya, Kayseri, Eskişehir, Turkey, Amasya, Yozgat.

Tobacco
More Aegean, Black Sea.
Have a special share in exports.
Suitable Products According To The Climate

Mediterranean region → olives, citrus fruits (orange, lemon, tangerine), bananas, and tomatoes.
The Black Sea region → nuts, tea, corn, Kiwi.
Central Anatolia → wheat, barley, chickpea, lentil, potato, sugar beet.
Aegean region → grapes, figs, cotton, olives, tobacco.
Southeastern Anatolia → lentils, cotton, pistachios, wheat.
Eastern Anatolia → barley, wheat, forage crops, apples, suitable for the production of livestock feed.
""")
                Image("products1")
                    .frame(width: 30, height: 30)
                Image("products2")
                    .frame(width: 30, height: 30)
                NavigationLink(destination: BlogPage()) {
                    Text("READ MORE OF OUR BLOGS")
                        .foregroundStyle(Color(hex: "#EBAB3B"))
                }
            }
        }
    }
    
    struct PlantDiseases: View {
        var body: some View {
            ScrollView {
                Image("diseases")
                    .frame(width: 30, height: 30)
                Text("Plant Diseases")
                    .bold(true)
                Text("""
                 Plant diseases are disorders that arise as a result of living or environmental factors, hinder plant growth, and cause differences in yield and quality.
                  
                 Biotic Plant Diseases (Living Agents)
                 ·  Fungi: The most common plant disease, spread by spores. Examples include mildew, powdery mildew, rust, and root rot.
                 ·  Bacteria: Formed when bacteria settle in leaf, stem, fruit, and root tissues. They are usually spread through water droplets, injuries, and insects. Examples include fire blight and bacterial spot.
                 ·  Viruses: Transmitted by insects (especially aphids and whiteflies) and mechanically. Causes symptoms such as mosaic, stunting, and leaf curling in plants. Mosaic viruses, leaf curl virus.
                 ·  Nematodes: Microscopic worms that cause  swelling and galls on roots. They hinder the plant's ability to absorb nutrients and water. Root-knot nematodes.
                 Abiotic Diseases (Environmental Factors)
                 ·  Nutrient deficiencies: Nitrogen deficiency → yellowing; Iron deficiency → chlorosis.
                 ·  Excessive water/drought stress.
                 ·  Cold, frost, heat damage.
                 ·  Chemical damage: Pesticide phytotoxicity, salinity, acid rain.
                 ·  Air pollution: Ozone and SO₂ damage.
                  
                 Due to the coexistence of many climates in Turkey and the diversity of agricultural products, many plant diseases are observed. In cereals: rust diseases, powdery mildew. In fruit trees: fire blight, root rot. In vegetables: bacteria, viruses, mildew. In cotton and industrial crops: wilting and spots. These are some of the diseases observed. These diseases have many negative effects.
                 These include yield loss, quality decline, economic damage, food safety risks, and ecological damage.
""")
                Image("diseases1")
                    .frame(width: 30, height: 30)
                Text("""
STEPS TO PREVENT PLANT DISEASES

a) Cultural Measures
•⁠  ⁠Practice crop rotation, i.e., do not continuously plant the same crop in the same field.
•⁠  ⁠Choose disease-resistant plant varieties.
•⁠  ⁠Ensure that seeds and seedlings are disease-free.
•⁠  ⁠Ensure balanced irrigation and fertilization.
•⁠  ⁠Disposing of plant residues after harvest.
 
b) Biological Control
•⁠  ⁠Use beneficial microorganisms (such as Trichoderma, Bacillus).
•⁠  ⁠Protect natural enemies.
 
c) Chemical Control
•⁠  ⁠Using chemicals such as fungicides, bactericides, and nematicides. However, it is important to remember that excessive use can harm the environment and health; therefore, we must be careful.
 
d) Integrated Pest Management (IPM)
•⁠  ⁠Using cultural, biological, and chemical methods together in a balanced and sustainable manner.
 
e) Remote Sensing and Technology
•⁠  ⁠We can detect plant stress at an early stage using satellite data such as NDVI.
•⁠  ⁠Smart farming applications make it possible to manage pesticide application and irrigation more effectively
Control Approaches in Turkiye

Integrated pest management (IPM): Resistant varieties, cultural measures, biological agents, etc.
Agricultural faculties and TAGEM (Ministry of Agriculture and Forestry Research Institutes) monitor the spread of diseases.
Chemical control is still widely used, but it is limiting in terms of the environment and cost.
""")
                NavigationLink(destination: BlogPage()) {
                    Text("READ MORE OF OUR BLOGS")
                        .foregroundStyle(Color(hex: "#EBAB3B"))
                }
            }
        }
    }
    
    struct Fertilizer: View {
        var body: some View {
            ScrollView {
                Image("fertilizer")
                    .frame(width: 30, height: 30)
                Text("Fertilizer Production and Consumption in Turkiye")
                    .bold(true)
                Text("""
In crop production, which is one of the most influential factors in productivity growth in the country in parallel to the production of chemical fertilizers, have seen a significant increase in consumption. Annual manure production is higher in the case of consumption in our country is around 4-5 million on average around 6-7 million of Turkiye's done and this lowers fertilizer fertilizer consumption importer status.
""")
                Image("fertilizer1")
                    .frame(width: 30, height: 30)
                Text("""
Fertilizer, agricultural productivity increases significantly. Missing nutrients in the soil meets and contributes to achieving a higher quality product. When used correctly supports sustainability in agricultural production. Turkey has a strategic importance for food security in the country, such as high capacity of agricultural production.
 In total, around 10 large fertilizer production facility has. These are the best known of them: Toros Tarım Gemlik Fertilizer, Bagfas, meat, fertilizer, fertilizer industry Istanbul (IGSAS), such as smoking. Despite the high production capacity in Turkey, nitrogen, phosphorus and potassium, a large proportion of raw materials is imported, making this the cost is dependent on foreign currency. This greatly increases the cost of production and energy.
Types of fertilizer used; nitrogenous fertilizers (urea, ammonium sulphate, ammonium nitrate, CAN), phosphorous fertilizers (DAP, TSP, MAP), potassium fertilizers (K₂SO₄, KNO₃ etc.).
""")
                Image("fertilizer2")
                    .frame(width: 30, height: 30)
                Text("""
Nitrogenous fertilizers; fertilizer that is produced and consumed in Turkey, most of the group. Urea (46% N), Ammonium Sulfate (21% N), ammonium nitrate (%steps 26 through 33 N), can (calcium ammonium nitrate %26N-shaped types. Natural gas as a raw material is required, and where the cost of production are mostly imported natural gas in Turkey is quite high. Pretty improves the yield, but use more groundwater nitrate pollution, greenhouse gas emissions (N₂O) have adverse effects such as, can. IGSAS (Kocaeli), Toros Tarım (Ceyhan and Samsun), Gemlik Fertilizer nitrogen fertilizer in the field of production stands out.
 
Phosphorus Fertilizers; Fertilizer Group Limited in Turkey produced, plant root growth, flowering and improves product quality. Phosphorus in the soil can connect and become unusable over time as a negative aspect; also overuse is causing water pollution. DAP (Diammonium Phosphate 18% N, 46% P₂O₅), TSP (triple super phosphate 46% P₂O₅), MAP (Monoammonium phosphate) include species such as. Enough raw materials for phosphate rock reserves in Turkey, Tunisia, Morocco and Jordan, such as imported from countries that are being cost increases. Bagfas (Balıkesir), Toros Tarım Manure and beef manufactures in this field.
 
Potassium fertilizers; unfortunately, there aren't OK so no potassium mines in Turkey ,Russia, Canada,Belarus are imported from countries such as. OK have been imported as quite low utilization rate in the state. Potassium sulfate (K₂SO₄), Potassium Nitrate (KNO₃), Potassium Chloride (KCl), such as species. When it is used because it is expensive fertilizer that enhances the quality of fruit and vegetables is not preferred by farmers group, and this lowers the yield.
Most of the land in Turkey basic needs nitrogen → more farmers use nitrogen fertilizer. Phosphorus and potassium imported raw material prices are high.
The majority of farmers, soil analysis , abnormal fertilization is doing → the easiest and cheapest solution as urea, ammonium sulfate, BELL, such as nitrogen fertilizers are turning to products that's why you can turn to our proposal needs your soil soil analysis.
Greenhouse gas emissions during production, waste management, emissions that cause acid rain. So eco-friendly use of organic fertilisers is also very important. The production and use of organic fertilizers should be encouraged.
 The territory of Turkey is the lack of organic matter and the issue is dependent on imports of chemical fertilizers when considering organic and biomass , the use of strategic importance.
 These fertilizers to farmers get to choose:
·         Support payments have to be increased
·         Training and extension activities should be done,
·         Biogas and composting plants should be encouraged
·         College–the private sector in collaboration with the biomass R & D should be strengthened.
 
Organic fertilizers;animal wastes (manure), vegetable waste (compost), the fertilizers are derived from plant or biogas from city waste. The physical structure of the soil improves water holding capacity, aeration). Unlike chemical fertilizers,the soil while feeding the long-term data provides. Supports beneficial microorganisms in the soil. Contributes to the evaluation of waste (environmental benefit).
Of our soilsorganic matter ratio of 1.5% to around 2, so it is below the critical level. Therefore, the use of organic fertilizers is very important, but farmers are still mainly using chemical fertilizer. To change this situation in recent years the Ministry of Agriculture to support the use of organic fertilizer was included.
 
Are biyofertilizers; fertilizers that contain microorganisms that support plant growth are. For example :Rhizobium → nitrogen bonds in the roots of legumes. Azotobacter , Azospirillum → free-living nitrogen-binding bacteria. Mycorhizae mushrooms → surface extends to the root of the plant, if the intake of phosphorus increases. Phosphate solvent bacteria → phosphorus in the soil available to the plant makes. Biomass reduces the use of chemical fertilizer use. Environmentally friendly, does not create greenhouse gas emissions. Plant nutrient uptake and stress conditions (drought, salinity) durability increases.Again, also in our country is not known,farmers must be given to training in this regard. The Ministry of Agriculture of biyogubre certification and is taking steps on promotion.
 
 The result is organic and we get out of this post biyogubre theturkey and the environmental sustainability of both to reduce dependence on imports is one of the most critical goals for solutions. However, significant government support for expansion are required to notify and the farmer.
""")
                NavigationLink(destination: BlogPage()) {
                    Text("READ MORE OF OUR BLOGS")
                        .foregroundStyle(Color(hex: "#EBAB3B"))
                }
            }
        }
    }
    
    struct WaterUsage: View {
        var body: some View {
            ScrollView {
                Image("waterU")
                    .frame(width: 30, height: 30)
                Text("Water Usage")
                    .bold(true)
                Text("""
The presence of the Earth's total water 3/4 water U 1.4 billion km3.What a pity this water, only 2.5% is’u sweet water sweet water, 69% of glaciers are reserved and can be used in this is not the case, 30% of the amount that is only accessible to people resides under the ground because it’s %1.
According to data from 2020, spent most of the area where fresh water is, of course, also is agriculture.
""")
                Image("usage1")
                    .frame(width: 30, height: 30)
                Text("""
Be understood from the graph tatlu water
 Supporting:%agriculture 69,
Supporting:%industry 19,
Supporting:%12 drinking and household uses for.
Turkey, fresh water rivers,lakes,dams,rain water,groundwater and source water creates.
 The longest rivers: the Red River, the Euphrates, Sakarya, Tigris.
 Energy production, is used to provide drinking water and agricultural irrigation.
Lakes: in Turkey, there are approximately 120 natural lakes.
Fresh lake water quality, especially in Eğirdir, Beyşehir and Sapanca Lake.
Dams and reservoirs: more than 850 dams in Turkey, there are.the most known ones among Atatürk, Keban, Karakaya, hirfanlı dam is like.
Underground waters.In Turkey, the potential for ground water per year, about 14 billion m3’tour.Wells, and aquifers artezyen through cikarililan groundwater is of very great importance.
Especially the Konya plain, the plain of Çukurova and the UK extensively, such as in agricultural areas are used.Water over-extraction in Konya obruk formation, the Aegean and the sea of Marmara to groundwater salinisation lead.
Source waters.Turkey geography is mountainous, thanks to a very rich source waters has.These are very important in terms of the wishes of drinking water source waters and valuable.  For example: sources of Uludag (Bursa) Bolu Abant and resources, eastern Black Sea Resources.
""")
                Image("usage2")
                    .frame(width: 30, height: 30)
                Text("""
In Turkey, the annual average rainfall 501 billion m3 water is.
This entry:
·         274 billion m3 returns to the atmosphere by evaporation,
·         Exudes 69 billion m3 underground,
·         With 158 billion m3 of surface flow in streams will be.
Entries today, the amount of water technically and economically available approximately 112 billion m3.

FRESH WATER USAGE RATES IN TURKEY
""")
                Image("usage3")
                    .frame(width: 30, height: 30)
                Text("""
Annual average 112 billion m3 of fresh water available there.This distribution of Water shown in the chart as :
·         74% in agriculture (irrigation),
·         15% in the industry,
·         11% drinking and domestic use.
 In Turkiye, the annual per capita rate of ~1.300 m3 , and this value is Turkey water stress among the countries that have been included.
Population growth, rapid industrialization and unplanned urbanization, the demand for water is constantly increasing. Climate change, drought, especially in central Anatolia, Southeast Anatolia and Aegean regions threatens agricultural production.
Our recommendations for this situation modern irrigation techniques should be used to prevent the wastage of water, everyone should be educated.
""")
                NavigationLink(destination: BlogPage()) {
                    Text("READ MORE OF OUR BLOGS")
                        .foregroundStyle(Color(hex: "#EBAB3B"))
                }
            }
        }
    }
    struct ndvi: View {
        var body: some View {
            ScrollView {
                Image("ndvi")
                    .frame(width: 30, height: 30)
                Text("Normalized Difference Vegetation Index")
                    .bold(true)
                Text("""
NDVI (Normalized Difference Vegetation Index) mean Normalized Difference vegetation Indexmeans. Using satellite imagesof vegetation density, is used to measure health and development.
NDVI, plants, red light (Red) absorption and near-infrared light (NIR) is based on the reflection characteristics. Healthy plants are strongly red light gauge NIR light due to the cell structure of the Leaf reflects the high proportion. Under stress/drying plants,Than absorbs less red light, less reflects NIR. Soil, water, and snow, NDVI value is quite low.
FORMULA;NDVI=(NIR+Red)/(NIR−Red)
Value range: -1 to +1 varies between . +Close to 1 → dense, healthy vegetation
Around 0 → Empty sparse vegetation or soil. Close to -1 → water, snow, cloud, artificial surfaces.
NDVI in Turkey agriculture, drought monitoring, Forestry, desertification and erosion, Urban Development and is used in many fields such as ecology.
For example:Inner NDVI values are low during dry periods in Anatolia on the way out, high NDVI values are observed in the Black Sea throughout the year.
""")
                Image("ndvi1")
                    .frame(width: 30, height: 30)
                Text("""
General 's trends in NDVI in Turkey
 
The Black Sea region: high NDVI throughout the year (the dense forest cover).
 
Marmara & Aegean: Agriculture + Forestry → medium-high NDVI.
 
Central Anatolia: the type of agricultural production in the period of medium-high NDVI in winter is low.
 
Southeastern Anatolia: non-irrigation areas is very low, are higher in areas with irrigation.
 
East: summer foliage increases, the NDVI decreases in winter due to snow.
NASA NDVI satellite data for open access presents:
MODIS (Terra & Aqua Satellites) Resolution: 250 m – 500 m. Timescale: daily, 8-day, monthly. Usage: agricultural and ecological monitoring in Turkey.
 Landsat (NASA + the USGS, satellites 8 and 9) Resolution: 30 m. Timescale: 16 days. Usage: Detailed plots of agricultural, forest studies.
Sentinel-2 (ESA, NASA sponsored partnerships) Resolution: 10 m. Timescale: 5 days. Usage: agricultural Detailed monitoring (eg. corn, cotton, wheat).
NASA EarthData portal with online access to NDVI time series can be downloaded and Giovanni. Scientists are using this platform and public institutions in Turkey.
 
NASA NDVI data Analysis for Turkey
MODIS NDVI time series (2000-2025) examined:
Average NDVI values of 0.35 – 0.45 between.
The Black Sea is always high (>0.6).
An increase in central Anatolia and Southeast in the middle of summer, winter, fall.
In dry years (2007, 2014, 2021) NDVI values %15 to 25 across the country declined.
""")
                NavigationLink(destination: BlogPage()) {
                    Text("READ MORE OF OUR BLOGS")
                        .foregroundStyle(Color(hex: "#EBAB3B"))
                }
            }
        }
    }
    struct FarmerView: View {
        var body: some View {
            VStack {
                Text("Welcome to FarmerView")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
        }
    }
    struct ChildView: View {
        var body: some View {
            VStack {
                Text("Welcome to Child View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Text("Agriculture Game For Kids")
                Text("COMING SOON!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#262525"))
            }
        }
    }
    struct RainfallForecast: View {
        var body: some View {
            
        }
    }
    struct RecentHumidity: View {
        var body: some View {
            
        }
    }
    struct SQuality: View {
        var body: some View {
            Text("Toprak verimi metni koyulacak")
                .padding()
        }
    }
    
    struct Water: View {
        var body: some View {
            Text("Su seviyeleri metni koyulacak")
                .padding()
        }
    }
    
    struct Weather: View {
        var body: some View {
            Text("Hava durumu API koyulacak")
                .padding()
        }
    }
    
    struct SulamaTek: View {
        var body: some View {
            ScrollView {
                Image("irrigation")
                    .frame(width: 30, height: 30)
                Text("MODERN IRRIGATION TECHNIQUES") .padding()
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Text("""
The world's population and are increasing every day as the population increases, the need for products is increasing. Agricultural products in the importance of Agriculture for the supply of every part of the world are very great.Agriculture increases the need for agricultural irrigation by growing.Water usage in our article as we mentioned, the biggest role agriculture plays in the consumption of natural water resources.  All these combined, the value of modern irrigation techniques with each passing day in our lives is increasing. The useof traditional irrigation as well as more convenient and economical because it is growing every day with this system the farmers of energy, water and labor costs.  
Modern irrigation systems, or techniques, to ensure the efficient operation of water in agriculture, in order to avoid wastage and increase product yield improvedtechniques.Traditional methods are inadequate in cases where irrigation modern irrigation systems water to the plant roots to be used more effectively by providing direct access allows.Modern irrigation systems water stress the importance of living in our country as it is in places is very important.
 In Turkey, the available water 74% in agriculture is consumed.Traditional irrigation (irrigation wild) methods → water 50% of wasting.
With modern irrigation systems:
o    In the years to 20-25 billion m3 water savings can be made.
o    In agriculture yield of 30-40% may increase.
o    Less fertilizer/drug consumption → environmental pollution is reduced.
 Modern irrigation techniques: Dripirrigation,sprinkler irrigation, Underground (both " room), drip irrigation, micro-sprinkler, intelligent and Automated irrigation systems.
Come on, let us examine under 5 main headings of this system.
Drip irrigation system,low water pressure in pipes and drippers Te this technique with a slow and controlled manner to the roots of the plant is given. Especially in the Aegean, Mediterranean and southeastern Anatolia regions, are widely used.
Benefits %40-60 much water savingsit provides.Fertilizer directly to the root and medicine, since it significantly reduces loss of nutrients. Soil erosion and runoff is at a minimal level. To a large extent prevented the development of weeds.
Disadvantages: the initial investment cost is quite high. The tip of clogging of drippers is a common problem.
Sprinkler irrigation system, with the help of pressurized water pipes or sprinklers just like rain to the fields is returned.This method of Central Anatolia and Thrace are used widely.
Advantagesof different types of soil and plant can be made use of. .Water, homogenously distributed product development for more regular.
Traditional irrigation compared to 30-50% water savings.
Disadvantages:Wind and evaporation often due to water loss can be experienced.Installation and energy cost is quite high.
 
Micro-sprinkler systems, these systems are low pressure water sprinkler heads, nozzles with small plant to the environment is given.Mediterranean citrus production in the Aegean and is more desirable.
Advantages:provides homogeneous irrigation fruit trees and vineyards. Protection against the risk of frost during the flowering periodcan provide.Fertilizer and spraying can be integrated with.
Disadvantages:evaporation losses in drip irrigation more than classic.
 
Underground (both " room), drip irrigation,drip irrigation pipes placed under the ground to prevent loss and evaporation provides water directly to the plant roots for a given yield and waste both prevents.The use is currently limited, although cotton and corn in the fields began to appear.
Advantages:Evaporation loss is almost zero.%60-70 percent water savings it provides.Foreign output weed is minimal.
 Disadvantages:theInitial investment cost is very high.The pipes and is difficult to maintain control.
 
Intelligent and automated irrigation systems water of their needs in the most efficient and effective manner to meet you, Moisture sensors, weather stations, and IoT (Internet of things), such as advanced technologies faydalananir. Some greenhouses in Antalya and the Aegean agricultural cooperatives are being used.
 Advantages:the plant needs as much water as is given → 50% water and energy saving.Remote control, there is the possibility (via mobile apps).More irrigation-induced salinity and erosion is prevented.
 Disadvantages: High capital investment and technology requires.
💧 Drip Irrigation
Water Efficiency: 40% - 60%
Initial Investment: 🟨 Medium
Operational Cost: Low
Overall Score: ★★★★☆
Best Suited For: Vegetables, orchards, vineyards, greenhouses. High-value row crops.
Pros: Very high efficiency, minimizes weed growth, direct-to-root watering.
Cons: Can clog without proper filtration, initial setup can be labor-intensive.
🚿 Sprinkler Irrigation
Water Efficiency: 30% - 50%
Initial Investment: 🟧 Medium-High
Operational Cost: Medium
Overall Score: ★★★☆☆
Best Suited For: Grains (wheat, barley), cotton, potatoes, forage crops. Large, open fields.
Pros: Covers large areas effectively, relatively easy to automate.
Cons: Prone to high water loss from evaporation and wind drift.
🌱 Subsurface Drip
Water Efficiency: 60% - 70%
Initial Investment: 🟥 High
Operational Cost: Very Low
Overall Score: ★★★★◐
Best Suited For: Corn, cotton, alfalfa, olive groves. Long-term, high-value crops in arid regions.
Pros: Highest water efficiency, no surface evaporation, reduces soil disease.
Cons: Very high installation cost, inspection and repair are difficult.
💨 Micro-Sprinkler
Water Efficiency: 30% - 40%
Initial Investment: 🟨 Medium
Operational Cost: Low
Overall Score: ★★★☆☆
Best Suited For: Citrus, vineyards, tree orchards. Also used for frost protection.
Pros: Excellent coverage for root zones of individual trees, good for sloped land.
Cons: Lower efficiency than drip, susceptible to wind.
🤖 Smart / Automated
Water Efficiency: 40% - 50%
Initial Investment: 🚨 Very High
Operational Cost: Very Low
Overall Score: ★★★★★
Best Suited For: Large-scale modern farms, high-tech greenhouses, precision agriculture.
Pros: Data-driven precision, optimizes water/fertilizer, saves labor.
Cons: Extremely high initial cost, requires technical expertise and infrastructure.
""")
                NavigationLink(destination: BlogPage()) {
                    Text("READ MORE OF OUR BLOGS")
                        .foregroundStyle(Color(hex: "#EBAB3B"))
                }
               }
            .padding(12)
        }
    }
    
    struct Soil: View {
        var body: some View {
            Text("Toprak nemi metni koyulacak")
                .padding()
        }
    }
    
    
    
    
    
    
    
    
}

