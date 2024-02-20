import 'dart:async';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/chat_features_usercase.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatFeaturesUseCase chatFeaturesUseCase;
  UserSession userSession = sl<UserSession>();
  StreamSubscription? streamSubscription;
  StreamSubscription? chatstreamSubscription;
  List<StreamSubscription?>? countSubscriptions;
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase = sl<FirebaseFirestoreUseCase>();


  ChatBloc({required this.chatFeaturesUseCase})
      : super(InitialChatState()) {
    on<InitialChatEvent>(_initalChat);
    on<AddChatEvent>(_addChat);
    on<LoadMessageEvent>(_loadMessage);
    on<DeleteChatEvent>(_deleteChat);
    on<AddMessageEvent>(_addMessage);
    on<UpdateMessageEvent>(_updateMessage);
    on<DeleteMessageEvent>(_deleteMessage);
    on<EditedMessageEvent>(_editMessage);
    on<LoadChatEvent>(_loadChat);
    on<UpdateUnreadCountEvent>(_updateUnreadCount);
    on<UpdatedChatEvent>(_updateChat);
  }

  void _initalChat(InitialChatEvent event, Emitter<ChatState> emit) async {
   
    try {} catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _addChat(AddChatEvent event, Emitter<ChatState> emit) async {

    try {
      await chatFeaturesUseCase.sendMessage(
          event.chatId, event.chat, event.message);
      emit(ChatAddedState());
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _loadChat(LoadChatEvent event, Emitter<ChatState> emit) async {
        
    try {
        chatstreamSubscription = FirebaseFirestore.instance
            .collection('chats')
            .where('users',arrayContains: userSession.userDetails!.userId)
            .orderBy('lastMessage.timeStamp', descending: true)
            .snapshots()
            .listen(
          (event) {
            userSession.unReadCount.clear();
            List<Chat> chats = [];


        countSubscriptions?.forEach((element) => element?.cancel());

        countSubscriptions = List.filled(event.docs.length, null);
        for (int i = 0; i < event.docs.length; i++) {
          final chat = Chat.fromJson(
            event.docs[i].data(),
          );

          countSubscriptions![i] = FirebaseFirestore.instance
              .collection('chats')
              .doc(event.docs[i].id)
              .collection('messages')
              .where('sender',isNotEqualTo: userSession.userDetails?.userId)
              .where('unseenby', arrayContains: userSession.userDetails?.userId)
              .snapshots()
              .listen((ev) {
              
              userSession.unReadCount[event.docs[i].id] = ev.docs.length;
            add(UpdateUnreadCountEvent());
          });
          chats.add(
            chat,
          );
        }
        
        userSession.chats = chats;
        add(UpdatedChatEvent());
      },
    );
 
            
    } catch (e) {
      emit(ChatErrorState(error: e.toString()));
    }
  }

  void _loadMessage(LoadMessageEvent event, Emitter<ChatState> emit) async {
     
    try {
      if (streamSubscription != null) {
        streamSubscription?.cancel();
      }
      final chatId = event.chatId;
      streamSubscription = FirebaseFirestore.instance
          .collection('chats')
          .doc(event.chatId)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .listen((event) {
        print(event.docs);

        List<Message> messages = [];
        messages = event.docs.map((e) => Message.fromJson(e.data())).toList();

        int i = 0;
        while (userSession.userDetails!.userId != messages[i].sender &&
            (messages[i].unseenby!.contains(userSession.userDetails!.userId))) {
          messages[i].unseenby?.remove(userSession.userDetails!.userId);
          FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .doc(messages[i].messageId)
              .update({'unseenby': messages[i].unseenby});
          i++;
        }

        add(UpdateMessageEvent(docs: messages));
      });
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _editMessage(EditedMessageEvent event, Emitter<ChatState> emit) async {
        
    try {
      await chatFeaturesUseCase.updateMessage(
          event.chatId, event.messageId, event.newMessage);
      emit(EditedMessageState());
    } catch (e) {
      emit(ChatErrorState(error: e.toString()));
    }
  }

  void _addMessage(AddMessageEvent event, Emitter<ChatState> emit) async {
        
    try {
      await chatFeaturesUseCase.sendMessage(
          event.chatId, event.chat, event.message);

      emit(ChatAddedState());
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _deleteChat(DeleteChatEvent event, Emitter<ChatState> emit) async {
   
    try {} catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _updateMessage(UpdateMessageEvent event, Emitter<ChatState> emit) async {
       
    try {
      List<Message> messages =
          event.docs.map((e) => Message.fromJson(e.toJson())).toList();

      emit(MessageUpdatedState(docs: messages));
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _deleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
       
    try {
      await chatFeaturesUseCase.deleteMessage(event.chatId, event.MessageId);
      emit(DeletedMessageState());
    } catch (error) {
      emit(ChatErrorState(error: error.toString()));
    }
  }

  void _updateUnreadCount(
      UpdateUnreadCountEvent event, Emitter<ChatState> emit) async {
 
   
    try {
      emit(UpdateUnreadCountState());
    } catch (e) {
      emit(ChatErrorState(error: e.toString()));
    }
  }

  void _updateChat(UpdatedChatEvent event, Emitter<ChatState> emit) async {
         
    
    try {
      emit(UpdatedChatState());
    } catch (e) {
      emit(ChatErrorState(error: e.toString()));
    }
  }
}
