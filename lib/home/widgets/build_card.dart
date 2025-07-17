import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:powergodha/home/view/bottomNavigation/on_tap_details_page.dart';
import 'package:powergodha/shared/api/api_models.dart';

class BuildCard extends StatefulWidget{
  final ProfitableDairyFarmingData item;
  const BuildCard({
    required this.item ,super.key
  });

  @override
  State<BuildCard> createState() => _BuildCardState();
}

class _BuildCardState extends State<BuildCard> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 8),
     child: InkWell(
       onTap: (){
         Navigator.of(context).push(OnTapDetailsPage.route(widget.item));
       },
       child: Card(
         shape: const RoundedRectangleBorder(
           
         ),
         elevation: 2,
         child: Padding(
           padding: const EdgeInsets.all(8),
           child: Column(
             children: [
               Row(
                 children: [
                   SizedBox(
                     height: 110,
                     width: 110,
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(10),
                       child: CachedNetworkImage(
                         imageUrl: widget.item.coverImg,
                         fit: BoxFit.cover,
                         placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                         errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                       ),
                     ),
                   ),
                   const SizedBox(width: 5),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                             widget.item.header,
                             maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                             style: const TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18
                             )
                         ),
                         const SizedBox(height: 5),

                         Text(
                           widget.item.summary,
                           overflow: TextOverflow.ellipsis,
                           style: const TextStyle(
                             color: Colors.grey,
                           ),
                         ),

                         if(showMore != true)
                           Align(
                             alignment: Alignment.bottomRight,
                             child: ElevatedButton(
                               onPressed: () {
                                 setState(() {
                                   showMore = true;
                                 });
                               },
                               style: ElevatedButton.styleFrom(
                                   elevation: 0,
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(60)
                                   ),
                                   foregroundColor: Colors.red,
                                   backgroundColor: Colors.red[100],
                                   minimumSize: const Size(80, 20),
                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5)
                               ),
                               child: const Text(
                                 'More info',
                                 style: TextStyle(
                                   fontSize: 13,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                           )else const SizedBox(height: 50)
                       ],
                     ),
                   ),
                 ],
               ),
               if(showMore == true)...[
                 const SizedBox(height: 20),
                 Text(
                   widget.item.summary,
                   style: TextStyle(
                     color: Colors.grey[600],
                   ),
                 ),

                 Align(
                   alignment: Alignment.bottomRight,
                   child: ElevatedButton(
                     onPressed: (){
                       setState(() {
                         showMore = false;
                       });
                     },
                     style: ElevatedButton.styleFrom(
                       elevation: 0,
                       foregroundColor: Colors.red,
                       backgroundColor: Colors.red[100],
                       minimumSize: const Size(60, 20),
                       padding: const EdgeInsets.symmetric(horizontal:8,vertical: 5),
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(60)
                       ),
                     ),
                     child: const Text(
                       'Less',
                       style: TextStyle(
                           fontSize: 12
                       ),
                     ),
                   ),
                 ),
               ]
             ],
           ),
         ),
       ),
     ),
   );
  }
}
