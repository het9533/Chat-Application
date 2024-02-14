import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/domain/usecase/chat_features_usercase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatFeaturesUseCase chatFeaturesUseCase;
  UserSession userSession;
  ChatBloc({required this.chatFeaturesUseCase, required this.userSession})
      : super(InitialChatState()) {
    on<InitialChatEvent>(_initalChat);
    on<AddChatEvent>(_addChat);
    on<LoadChatEvent>(_loadChat);
    on<DeleteChatEvent>(_deleteChat);
    on<AddMessageEvent>(_addMessage);
    on<UpdateMessageEvent>(_updateMessage);
    on<DeleteMessageEvent>(_deleteMessage);
  }

  void _initalChat(InitialChatEvent event, Emitter<ChatState> emit) async {
    emit(InitialChatState());
    try {} catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _addChat(AddChatEvent event, Emitter<ChatState> emit) async {
    emit(InitialChatState());
    try {
      await chatFeaturesUseCase.sendMessage(
          event.chatId, event.chat, event.message);
      emit(ChatAddedState());
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _loadChat(LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(InitialChatState());
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(event.chatId)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .listen((event) {
            print(event.docs);
        add(UpdateMessageEvent(docs: event.docs));
      });
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _addMessage(AddMessageEvent event, Emitter<ChatState> emit) async {
    emit(InitialChatState());
    try {
      await chatFeaturesUseCase.sendMessage(
          event.chatId, event.chat, event.message);

      emit(ChatAddedState());
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _deleteChat(DeleteChatEvent event, Emitter<ChatState> emit) async {
    emit(InitialChatState());
    try {} catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _updateMessage(UpdateMessageEvent event, Emitter<ChatState> emit) async {
    emit(InitialChatState());
    try {
      emit(MessageUpdatedState(docs: event.docs));
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _deleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
    emit(InitialChatState());
    try {} catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }
}
