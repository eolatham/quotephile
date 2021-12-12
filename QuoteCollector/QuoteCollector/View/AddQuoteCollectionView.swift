//
//  AddQuoteCollectionView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import SwiftUI
import CoreData

/**
 * For adding and editing quote collections.
 */
struct AddQuoteCollectionView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentation

    @State private var name = ""
    @State private var nameError = false

    var objectId: NSManagedObjectID?
    
    let viewModel = AddQuoteCollectionViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack {
                        TextField(
                            "Name",
                            text: $name,
                            prompt: Text("Name")
                        )
                        if nameError {
                            Text("Name is required")
                                .foregroundColor(.red)
                        }
                    }
                    Button {
                        if name.isEmpty {
                            nameError = name.isEmpty
                        } else {
                            let values = QuoteCollectionValues(name: name)
                            _ = viewModel.addQuoteCollection(
                                context: context, objectId: objectId, values: values
                            )
                            presentation.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                }
                .navigationTitle("\(objectId == nil ? "Add Quote Collection" : "Edit Quote Collection")")
            }
            .onAppear {
                if let quoteCollectionId = objectId,
                   let quoteCollection = viewModel.fetchQuoteCollection(context: context, objectId: quoteCollectionId)
                {
                    name = quoteCollection.name!
                }
            }
        }
    }
}

struct AddQuoteCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteCollectionView()
            .environment(
                \.managedObjectContext,
                 PersistenceManager.preview.container.viewContext
            )
    }
}
