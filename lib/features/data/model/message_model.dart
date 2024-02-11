

import 'package:json_annotation/json_annotation.dart';



part 'message_model.g.dart';

@JsonSerializable()
class Message{



String? messageId;
String? content;
List? seenby;
String? sender;
DateTime? timeStamp;

  Message({ this.messageId,this.content,this.seenby,this.sender,this.timeStamp});


   factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<dynamic, dynamic> toJson() => _$MessageToJson(this); 


}