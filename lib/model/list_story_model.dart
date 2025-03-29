import 'package:equatable/equatable.dart';

class ListStory extends Equatable {
  const ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? photoUrl;
  final DateTime? createdAt;
  final double? lat;
  final double? lon;

  factory ListStory.fromJson(Map<String, dynamic> json) {
    return ListStory(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      photoUrl: json["photoUrl"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      lat: json["lat"],
      lon: json["lon"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "photoUrl": photoUrl,
    "createdAt": createdAt?.toIso8601String(),
    "lat": lat,
    "lon": lon,
  };

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    photoUrl,
    createdAt,
    lat,
    lon,
  ];
}