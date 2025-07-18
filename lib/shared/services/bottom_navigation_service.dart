import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/retrofit/retrofit_client.dart';

class BottomNavigationService{
  BottomNavigationService({
    RetrofitClient? client,
  }) : _client = client ?? RetrofitClient();

  final RetrofitClient _client;

  Future<List<BottomNavigationData>> getDataBottomNavigation(int page) async{
    try{
      final response = await _client.getBottomNavigationData(page);

      if(response.success && response.data != null){

        final dataList = response.data as List<dynamic>;
        if(dataList.isNotEmpty){
          final data = dataList.map((e) => BottomNavigationData.fromJson(e as Map<String, dynamic>)).toList();
          return data;
        }else{
          throw Exception('Not data is Found');
        }
      }else{
        throw Exception('Error : ${response.message}');
      }
    }catch(e){
      throw Exception('About app data API call failed: $e');
    }
  }
}
