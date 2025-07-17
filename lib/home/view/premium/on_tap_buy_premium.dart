import 'package:flutter/material.dart';

class OnTapBuyPremium extends StatefulWidget {
  const OnTapBuyPremium({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const OnTapBuyPremium());
  }

  @override
  State<OnTapBuyPremium> createState() => _OnTapBuyPremiumState();
}

class _OnTapBuyPremiumState extends State<OnTapBuyPremium> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _buttonFadeAnimation;
  late bool _animationIntialized = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _buttonFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationIntialized = true;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  String? selectedPlan = 'basic';
  int count = 1;
  bool havePromoCode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium plans')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.green[200],
              ),
              child: Center(
                child: Text(
                  'Choose Subscription Plan Below',
                  style: TextStyle(fontSize: 16, color: Colors.green.shade900),
                ),
              ),
            ),
            const SizedBox(height: 40),

            SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildCard(),
                ),
            ),
            const SizedBox(height:30),
            if(!havePromoCode)...[
              InkWell(
                onTap: (){
                  setState(() {
                    havePromoCode = true;
                  });
                },
                child: const Text(
                  'Have a Promo Code?',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
            ]else
              _buildPromoCodeTextField(),
            const SizedBox(height:30),

            if(_animationIntialized)
              SlideTransition(
                  position: _buttonSlideAnimation,
                 child: FadeTransition(
                     opacity: _buttonFadeAnimation,
                     child:  ElevatedButton(
                         onPressed: (){
                           //Navigate to Payment page
                         },
                         style: ElevatedButton.styleFrom(
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(5),
                             )
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Align(
                               alignment: Alignment.center,
                               child: Text(
                                 'Buy Now',
                                 style: TextStyle(
                                     fontWeight: FontWeight.w900,
                                     color: Colors.white,
                                     fontSize: 18
                                 ),
                               ),
                             ),
                             Align(
                               alignment: Alignment.centerRight,
                               child: Row(
                                 children: [
                                   Text(
                                     'INR ${500*count}',
                                     style: const TextStyle(
                                         color: Colors.white,
                                         fontWeight: FontWeight.normal,
                                         fontSize: 18
                                     ),
                                   ),
                                   const Icon(
                                       Icons.navigate_next_sharp,
                                       color: Colors.white,
                                   )
                                 ],
                               ),
                             )
                           ],
                         )
                     ),
                 ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(){
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child: RadioListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('1 year premium subscription'),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(width:5),
                  Text('INR 500')
                ],
              ),
              const SizedBox(height: 10),
              _buildButton(),
              const SizedBox(height: 10),
            ],
          ),
          value: 'basic',
          groupValue: selectedPlan,
          onChanged: (value) {
            setState(() {
              selectedPlan = value;
            });
          }
      ),
    );
  }

  Widget _buildButton(){
    return Row(
      children: [
        const Text('Quantity'),
        const SizedBox(width:10),
        Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              IconButton(
                onPressed: (){
                  setState(() {
                    if(count == 1){
                      return;
                    }
                    count--;
                  });
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const Spacer(),
              Text(
                count.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: (){
                  setState(() {
                    count++;
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCodeTextField(){
    return Row(
      children: [
        const SizedBox(width:5),
        const SizedBox(
          height: 40,
          width: 250,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                hintText: 'Enter Promo Code',
                hintStyle: TextStyle(
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey
                    )
                )
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: (){
            //Check the promo code is valid or not
          },
          child: const Text(
            'Apply',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900
            ),
          ),
        ),
        const Spacer()
      ],
    );
  }
}
