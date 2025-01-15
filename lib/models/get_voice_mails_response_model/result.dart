class VoiceMails {
  String? callerid;
  String? category;
  String? context;
  String? dir;
  int? duration;
  String? flag;
  String? macrocontext;
  String? mailboxcontext;
  String? mailboxuser;
  String? msgId;
  int? msgnum;
  int? origtime;
  int? pk;
  String? usertime;

  VoiceMails({
    this.callerid,
    this.category,
    this.context,
    this.dir,
    this.duration,
    this.flag,
    this.macrocontext,
    this.mailboxcontext,
    this.mailboxuser,
    this.msgId,
    this.msgnum,
    this.origtime,
    this.pk,
    this.usertime,
  });

  factory VoiceMails.fromMap(Map<String, dynamic> map) {
    return VoiceMails(
      callerid: map['callerid'] as String?,
      category: map['category'] as String?,
      context: map['context'] as String?,
      dir: map['dir'] as String?,
      duration: map['duration'] as int?,
      flag: map['flag'] as String?,
      macrocontext: map['macrocontext'] as String?,
      mailboxcontext: map['mailboxcontext'] as String?,
      mailboxuser: map['mailboxuser'] as String?,
      msgId: map['msg_id'] as String?,
      msgnum: map['msgnum'] as int?,
      origtime: map['origtime'] as int?,
      pk: map['pk'] as int?,
      usertime: map['usertime'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callerid': callerid,
      'category': category,
      'context': context,
      'dir': dir,
      'duration': duration,
      'flag': flag,
      'macrocontext': macrocontext,
      'mailboxcontext': mailboxcontext,
      'mailboxuser': mailboxuser,
      'msg_id': msgId,
      'msgnum': msgnum,
      'origtime': origtime,
      'pk': pk,
      'usertime': usertime,
    };
  }
}
