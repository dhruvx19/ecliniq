class Doctor {
  final String id;
  final String name;
  final String? profilePhoto;
  final double? rating;
  final List<String> specializations;
  final List<String> degreeTypes;
  final int? yearOfExperience;

  Doctor({
    required this.id,
    required this.name,
    this.profilePhoto,
    this.rating,
    required this.specializations,
    required this.degreeTypes,
    this.yearOfExperience,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profilePhoto: json['profilePhoto'],
      rating: json['rating']?.toDouble(),
      specializations: (json['specializations'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
      degreeTypes: (json['degreeTypes'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
      yearOfExperience: json['yearOfExperience'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (profilePhoto != null) 'profilePhoto': profilePhoto,
      if (rating != null) 'rating': rating,
      'specializations': specializations,
      'degreeTypes': degreeTypes,
      if (yearOfExperience != null) 'yearOfExperience': yearOfExperience,
    };
  }
}

class TopDoctorsResponse {
  final bool success;
  final String message;
  final List<Doctor> data;
  final dynamic errors;
  final dynamic meta;
  final String timestamp;

  TopDoctorsResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
    required this.meta,
    required this.timestamp,
  });

  factory TopDoctorsResponse.fromJson(Map<String, dynamic> json) {
    return TopDoctorsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Doctor.fromJson(item))
          .toList() ?? [],
      errors: json['errors'],
      meta: json['meta'],
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((doctor) => doctor.toJson()).toList(),
      'errors': errors,
      'meta': meta,
      'timestamp': timestamp,
    };
  }
}

class TopDoctorsRequest {
  final double latitude;
  final double longitude;

  TopDoctorsRequest({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
