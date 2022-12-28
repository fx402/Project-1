import 'package:flutter/material.dart';

class TransaksiPage extends StatefulWidget {
  static var routeName = "/transaksi";

  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  bool isCheckedHp = false;
  bool isCheckedRadio = false;
  bool isCheckedTV = false;
  bool isCheckedKulkas = false;
  String valueHp = "";
  String valueRadio = "";
  String valueTV = "";
  String valueKulkas = "";
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  _showSimpleModalDialog(context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(20.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: 350),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                          text:"Berat Sampah",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                              wordSpacing: 1
                          )
                      ),
                    ),
                    Form(child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Weight'),
                        ),
                        RaisedButton(
                          onPressed: (){},
                          child: Text('Submit'),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var total;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Transaksi"),
        backgroundColor: Colors.green.shade300,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nama Penukar'
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'No Telepon'
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
                  // CheckboxListTile(title: Text("Hp"),value: true, onChanged: (newValue){},controlAffinity: ListTileControlAffinity.leading,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isCheckedHp,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedHp = value!;
                          _showSimpleModalDialog(context);
                        });
                      },
                    ),
                    Text('Hp'),
                    SizedBox(width: 10,),
                    isCheckedHp ? Text('$valueHp Kg', style: TextStyle(fontWeight: FontWeight.bold),): Text('')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isCheckedRadio,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedRadio = value!;
                        });
                      },
                    ),
                    Text('Radio'),
                    SizedBox(width: 10,),
                    isCheckedRadio ? Text('$valueRadio Kg', style: TextStyle(fontWeight: FontWeight.bold)): Text("")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isCheckedTV,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedTV = value!;
                        });
                      },
                    ),
                    Text('TV'),
                    SizedBox(width: 10,),
                    isCheckedTV ? Text('$valueTV kg', style: TextStyle(fontWeight: FontWeight.bold)): Text(''),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isCheckedKulkas,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedKulkas = value!;
                        });
                      },
                    ),
                    Text('Kulkas'),
                    SizedBox(width: 10,),
                    isCheckedKulkas ? Text('$valueKulkas Kg', style: TextStyle(fontWeight: FontWeight.bold)): Text(""),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Alamat Penukar'
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Total Rp ${total==null?0:total}', style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Montserrat',fontSize: 20),),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: ElevatedButton(style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen, minimumSize: Size(size.width/1.2, 40)),onPressed: (){},child: Text('Checkout'),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
