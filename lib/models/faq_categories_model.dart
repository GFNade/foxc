class FaqCategoriesModel {
  FaqCategoriesModel({
    this.status,
    this.message,
    this.data,
  });

  FaqCategoriesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FAQsCategory.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<FAQsCategory>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FAQsCategory {
  FAQsCategory({
    this.id,
    this.title,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.faqs,
  });

  FAQsCategory.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['faqs'] != null) {
      faqs = [];
      json['faqs'].forEach((v) {
        faqs?.add(FAQs.fromJson(v));
      });
    }
  }

  num? id;
  String? title;
  num? isDeleted;
  String? createdAt;
  String? updatedAt;
  List<FAQs>? faqs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['is_deleted'] = isDeleted;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (faqs != null) {
      map['faqs'] = faqs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FAQs {
  FAQs({
    this.id,
    this.faqsTypeId,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
  });

  FAQs.fromJson(dynamic json) {
    id = json['id'];
    faqsTypeId = json['faqs_type_id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  num? id;
  num? faqsTypeId;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['faqs_type_id'] = faqsTypeId;
    map['question'] = question;
    map['answer'] = answer;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
