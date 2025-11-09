class BasicDetails {
  final String? parentName;
  final String? relation;
  final String? parentContact;
  final String? childFullName;
  final String? childGender;
  final DateTime? dateOfBirth;
  final String? city;
  final String? basicEducation;

  BasicDetails({
    this.parentName,
    this.relation,
    this.parentContact,
    this.childFullName,
    this.childGender,
    this.dateOfBirth,
    this.city,
    this.basicEducation,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
      parentName: json['parentName'],
      relation: json['relation'],
      parentContact: json['parentContact'],
      childFullName: json['childFullName'],
      childGender: json['childGender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      city: json['city'],
      basicEducation: json['basicEducation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parentName': parentName,
      'relation': relation,
      'parentContact': parentContact,
      'childFullName': childFullName,
      'childGender': childGender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'city': city,
      'basicEducation': basicEducation,
    };
  }
}

class AdvancedDetails {
  final String? lifeGoals;
  final List<String>? travelledPlaces;
  final String? education;
  final String? profession;
  final String? currentCity;
  final String? religiousPractice;
  final String? foodHabits;
  final String? familyDetails;

  AdvancedDetails({
    this.lifeGoals,
    this.travelledPlaces,
    this.education,
    this.profession,
    this.currentCity,
    this.religiousPractice,
    this.foodHabits,
    this.familyDetails,
  });

  factory AdvancedDetails.fromJson(Map<String, dynamic> json) {
    return AdvancedDetails(
      lifeGoals: json['lifeGoals'],
      travelledPlaces: json['travelledPlaces'] != null
          ? List<String>.from(json['travelledPlaces'])
          : null,
      education: json['education'],
      profession: json['profession'],
      currentCity: json['currentCity'],
      religiousPractice: json['religiousPractice'],
      foodHabits: json['foodHabits'],
      familyDetails: json['familyDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lifeGoals': lifeGoals,
      'travelledPlaces': travelledPlaces,
      'education': education,
      'profession': profession,
      'currentCity': currentCity,
      'religiousPractice': religiousPractice,
      'foodHabits': foodHabits,
      'familyDetails': familyDetails,
    };
  }
}

class Profile {
  final String? id;
  final String profileCode;
  final String shareableLink;
  final BasicDetails? basicDetails;
  final AdvancedDetails? advancedDetails;
  final List<String>? photos;
  final String status;
  final DateTime? createdAt;
  final DateTime? completedAt;

  Profile({
    this.id,
    required this.profileCode,
    required this.shareableLink,
    this.basicDetails,
    this.advancedDetails,
    this.photos,
    required this.status,
    this.createdAt,
    this.completedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'] ?? json['id'],
      profileCode: json['profileCode'] ?? '',
      shareableLink: json['shareableLink'] ?? '',
      basicDetails: json['basicDetails'] != null
          ? BasicDetails.fromJson(json['basicDetails'])
          : null,
      advancedDetails: json['advancedDetails'] != null
          ? AdvancedDetails.fromJson(json['advancedDetails'])
          : null,
      photos: json['photos'] != null
          ? List<String>.from(json['photos'])
          : null,
      status: json['status'] ?? 'draft',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileCode': profileCode,
      'shareableLink': shareableLink,
      'basicDetails': basicDetails?.toJson(),
      'advancedDetails': advancedDetails?.toJson(),
      'photos': photos,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
