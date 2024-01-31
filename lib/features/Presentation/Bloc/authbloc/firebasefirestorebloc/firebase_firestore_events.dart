abstract class FirebaseFirestoreEvents {}

class FirebaseInitializedEvent extends FirebaseFirestoreEvents {}

class AddDocumentEvent extends FirebaseFirestoreEvents {
  final Map<String, dynamic> data;

  AddDocumentEvent(this.data);
}

class ModifyDocumentEvent extends FirebaseFirestoreEvents {
  final String docId;
  final Map<String, dynamic> updatedData;

  ModifyDocumentEvent(this.docId, this.updatedData);
}

class DeleteDocumentEvent extends FirebaseFirestoreEvents {
  final String docId;

  DeleteDocumentEvent(this.docId);
}

