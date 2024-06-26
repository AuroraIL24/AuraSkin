//
//  IngredientsEffectListComponent.swift
//  AuraSkin
//
//  Created by M. Ilham Syaputra on 11/05/24.
//

import SwiftUI

struct IngredientEffectList: View {
    var ingredients: [IngredientsEffect]
    var effectType: IngredientsEffectType
    
    init( _ effectType: IngredientsEffectType, _ ingredients: [IngredientsEffect]) {
        self.ingredients = ingredients
        self.effectType = effectType
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(ingredients, id: \.effect) { item in
                    let data: IngredientsEffect = item

                NavigationLink {
                    IngredientsEffectDetailView(data: data)
                        .toolbar(.visible, for: .tabBar)
                } label: {
                    HStack {
                        Image(item.symbol)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.black)

                        VStack {
                            Text(item.effect)
                                .font(.title3)
                                .foregroundStyle(.black)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            Text(item.description)
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 10)

                        Spacer()

                        Text("\(item.count)")
                            .foregroundStyle(.gray)

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        .padding(.bottom)
                    }
                }

            }
        }

        .padding(.top)
    }
}


#Preview {
    IngredientEffectList(IngredientsEffectType.pros, prosIngredientsDummy)
}
