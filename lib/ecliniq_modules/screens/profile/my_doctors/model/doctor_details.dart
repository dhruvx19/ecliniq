class FavouriteDoctor {
  final String id;
  final String name;
  final String specialization;
  final String qualification;
  final int experienceYears;
  final double rating;
  final int fee;
  final String availableTime;
  final String availableDays;
  final String location;
  final double distanceKm;
  final int availableTokens;
  final String nextAvailable;
  final bool isFavorite;
  final bool isVerified;
  final String profileInitial; // e.g. 'M', 'A'

  FavouriteDoctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.experienceYears,
    required this.rating,
    required this.fee,
    required this.availableTime,
    required this.availableDays,
    required this.location,
    required this.distanceKm,
    required this.availableTokens,
    required this.nextAvailable,
    this.isFavorite = false,
    this.isVerified = false,
    required this.profileInitial,
  });

  factory FavouriteDoctor.fromJson(Map<String, dynamic> json) {
    return FavouriteDoctor(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      experienceYears: json['experienceYears'],
      rating: json['rating'].toDouble(),
      fee: json['fee'],
      availableTime: json['availableTime'],
      availableDays: json['availableDays'],
      location: json['location'],
      distanceKm: json['distanceKm'].toDouble(),
      availableTokens: json['availableTokens'],
      nextAvailable: json['nextAvailable'],
      isFavorite: json['isFavorite'] ?? false,
      isVerified: json['isVerified'] ?? false,
      profileInitial: json['profileInitial'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialization': specialization,
    'qualification': qualification,
    'experienceYears': experienceYears,
    'rating': rating,
    'fee': fee,
    'availableTime': availableTime,
    'availableDays': availableDays,
    'location': location,
    'distanceKm': distanceKm,
    'availableTokens': availableTokens,
    'nextAvailable': nextAvailable,
    'isFavorite': isFavorite,
    'isVerified': isVerified,
    'profileInitial': profileInitial,
  };
}
