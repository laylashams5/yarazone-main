class Chat {
final int id;
  final String conversation_id;
  final String? user_id;
  final String? message;
  final List? attachments;
  final String created_at;
  final String updated_at;
  Chat(
      {required this.id,
      required this.conversation_id,
      this.user_id=null,
      this.message=null,
      this.attachments,
      required this.created_at,
      required this.updated_at,
      });
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        id: json["id"],
        conversation_id: json["conversation_id"],
        user_id: json["user_id"],
        message: json["message"],
        attachments: json["attachments"],
        created_at: json["created_at"],
        updated_at: json["updated_at"],
        );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversation_id,
        "user_id": user_id,
        "message": message,
        "attachments": attachments == null
            ? null
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "created_at": created_at,
        "updated_at": updated_at,
      };
}