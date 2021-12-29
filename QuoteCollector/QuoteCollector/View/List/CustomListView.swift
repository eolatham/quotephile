import SwiftUI
import CoreData

/**
 * A generic list view supporting grouping, sorting, selecting, editing, moving, and deleting
 * entities from a sectioned fetch request in a navigation view context.
 */
struct CustomListView<
    Entity: NSManagedObject,
    EntityRowView: View,
    EntityPageView: View,
    ConstantListPrefixView: View,
    ConstantListSuffixView: View,
    AddEntitySheetContentView: View,
    EditParentSheetContentView: View,
    BulkEditSheetContentView: View,
    BulkMoveSheetContentView: View
>: View {
    @SectionedFetchRequest var entities: SectionedFetchResults<String, Entity>
    @Binding var searchQuery: String
    @Binding var selectedSort: Sort<Entity>
    var sortOptions: [Sort<Entity>]
    var entityRowViewBuilder: (Entity) -> EntityRowView
    var entityPageViewBuilder: (Entity) -> EntityPageView
    var constantListPrefixViewBuilder: (() -> ConstantListPrefixView)? = nil
    var constantListSuffixViewBuilder: (() -> ConstantListSuffixView)? = nil
    var addEntitySheetContentViewBuilder: (() -> AddEntitySheetContentView)? = nil
    var editParentSheetContentViewBuilder: (() -> EditParentSheetContentView)? = nil
    var bulkEditSheetContentViewBuilder: ((Set<Entity>) -> BulkEditSheetContentView)? = nil
    var bulkMoveSheetContentViewBuilder: ((Set<Entity>) -> BulkMoveSheetContentView)? = nil
    var bulkDeleteFunction: ((Set<Entity>) -> Void)? = nil
    var bulkDeleteAlertMessage: String = "This action cannot be undone!"

    @State private var selectedEntities: Set<Entity> = []
    @State private var inSelectionMode: Bool = false
    @State private var showAddEntityView: Bool = false
    @State private var showEditParentView: Bool = false
    @State private var showBulkEditView: Bool = false
    @State private var showBulkMoveView: Bool = false
    @State private var showBulkDeleteAlert: Bool = false

    var body: some View {
        List {
            if constantListPrefixViewBuilder != nil {
                constantListPrefixViewBuilder!()
            }
            ForEach(entities) { section in
                Section(header: Text(section.id)) {
                    ForEach(section, id: \.self) { entity in
                        CustomListItemView(
                            entity: entity,
                            selectedEntities: $selectedEntities,
                            inSelectionMode: inSelectionMode,
                            rowViewBuilder: entityRowViewBuilder,
                            pageViewBuilder: entityPageViewBuilder
                        )
                    }
                }
            }
            if constantListSuffixViewBuilder != nil {
                constantListSuffixViewBuilder!()
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchQuery)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if inSelectionMode {
                    let disabled: Bool = selectedEntities.isEmpty
                    if bulkEditSheetContentViewBuilder != nil {
                        Button { showBulkEditView = true }
                            label: { Text("Edit") }.disabled(disabled)
                    }
                    if bulkMoveSheetContentViewBuilder != nil {
                        Button { showBulkMoveView = true }
                            label: { Text("Move") }.disabled(disabled)
                    }
                    if bulkDeleteFunction != nil {
                        Button { showBulkDeleteAlert = true }
                            label: { Text("Delete") }.disabled(disabled)
                    }
                } else {
                    CustomListSortSelectView<Entity>(
                        selectedSort: $selectedSort,
                        sortOptions: sortOptions
                    )
                    if addEntitySheetContentViewBuilder != nil {
                        Button { showAddEntityView = true } label: { Text("Add") }
                    }
                    if editParentSheetContentViewBuilder != nil {
                        Button { showEditParentView = true } label: { Text("Edit") }
                    }
                }
                Button {
                    if inSelectionMode { selectedEntities = [] }
                    inSelectionMode.toggle()
                } label: {
                    Text(inSelectionMode ? "Done" : "Select")
                }
            }
        }
        .sheet(isPresented: $showAddEntityView ) {
            // Only renders when addEntitiesheetContentViewBuilder != nil
            addEntitySheetContentViewBuilder!()
        }
        .sheet(isPresented: $showEditParentView ) {
            // Only renders when editParentSheetContentViewBuilder != nil
            editParentSheetContentViewBuilder!()
        }
        .sheet(isPresented: $showBulkEditView ) {
            // Only renders when bulkEditSheetContentViewBuilder != nil
            bulkEditSheetContentViewBuilder!(selectedEntities)
        }
        .sheet(isPresented: $showBulkMoveView ) {
            // Only renders when bulkMoveSheetContentViewBuilder != nil
            bulkMoveSheetContentViewBuilder!(selectedEntities)
        }
        .alert(isPresented: $showBulkDeleteAlert) {
            // Only renders when bulkDeleteFunction != nil
            Alert(
                title: Text("Are you sure?"),
                message: Text(bulkDeleteAlertMessage),
                primaryButton: .destructive(Text("Yes, delete")) {
                    withAnimation {
                        bulkDeleteFunction!(selectedEntities)
                        selectedEntities = []
                    }
                },
                secondaryButton: .cancel(Text("No, cancel"))
            )
        }
    }
}

struct CustomListItemView<
    Entity: NSManagedObject,
    RowView: View,
    PageView: View
>: View {
    @ObservedObject var entity: Entity
    @Binding var selectedEntities: Set<Entity>
    var inSelectionMode: Bool

    let rowView: RowView
    let pageView: PageView

    init(
        entity: Entity,
        selectedEntities: Binding<Set<Entity>>,
        inSelectionMode: Bool,
        @ViewBuilder rowViewBuilder: (Entity) -> RowView,
        @ViewBuilder pageViewBuilder: (Entity) -> PageView
    ) {
        self.entity = entity
        _selectedEntities = selectedEntities
        self.inSelectionMode = inSelectionMode
        self.rowView = rowViewBuilder(entity)
        self.pageView = pageViewBuilder(entity)
    }

    var body: some View {
        let isSelected: Bool = selectedEntities.contains(entity)
        if inSelectionMode {
            HStack {
                Button {
                    if isSelected { selectedEntities.remove(entity) }
                    else { selectedEntities.update(with: entity) }
                } label: {
                    Image(
                        systemName: isSelected
                            ? "checkmark.circle.fill"
                            : "checkmark.circle"
                    )
                }
                rowView
            }.foregroundColor(isSelected ? .accentColor : .primary)
        } else { NavigationLink { pageView } label: { rowView } }
    }
}

struct CustomListSortSelectView<E>: View {
    @Binding var selectedSort: Sort<E>
    let sortOptions: [Sort<E>]

    var body: some View {
        Menu {
            Picker("Sort By", selection: $selectedSort) {
                ForEach(sortOptions, id: \.self) { sort in
                    Text(sort.name)
                }
            }
        } label: { Text("Sort") }
        .pickerStyle(.inline)
    }
}

