// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      id: (json['user_id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      farmName: json['farm_name'] as String,
      address: json['address'] as String,
      pincode: json['pincode'] as String,
      taluka: json['taluka'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      village: json['village'] as String,
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'farm_name': instance.farmName,
      'address': instance.address,
      'pincode': instance.pincode,
      'taluka': instance.taluka,
      'district': instance.district,
      'state': instance.state,
      'country': instance.country,
      'village': instance.village,
    };
