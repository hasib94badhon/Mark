import 'package:flutter/material.dart';
import 'package:namer_app/widgets/Container_button_model.dart';

class AdvertDetailsPopup extends StatelessWidget {

  final iStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showModalBottomSheet(
      backgroundColor: Colors.transparent,
        context: context,
        builder: (context)=>Container(
          height: MediaQuery.of(context).size.height/2.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),

            )
          ),
        ),
       );
      },

      child: ContainerButtonModel(
        containerWidth: MediaQuery.of(context).size.width/1.5,
        itext: "Call Now",
        bgColor: Colors.green,
      ),
    );
  }
}
