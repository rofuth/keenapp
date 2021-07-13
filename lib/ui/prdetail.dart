import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keenapp/modal/PRApproveList.dart';
import 'package:keenapp/modal/mGetapprover.dart';
import 'package:keenapp/modal/mLogPrNumber.dart';
import 'package:keenapp/modal/mUser.dart';
import 'package:keenapp/provider/prList_Provider.dart';
import 'package:keenapp/provider/user_Provider.dart';
import 'package:keenapp/ui/prapprovedAC.dart';
import 'package:provider/provider.dart';

import 'package:keenapp/ui/widgets/responsive_ui.dart';
import 'package:keenapp/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart' as urlLaunch;
import 'package:keenapp/ui/prPDFFile.dart';

class prDetail extends StatelessWidget {
  String PRNumber;
  String type;
  prDetail({this.PRNumber, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: prDetailScreen(
        PRNumber: PRNumber,
      ),
    );
  }
}

class prDetailScreen extends StatefulWidget {
  String PRNumber;
  prDetailScreen({Key key, @required this.PRNumber}) : super(key: key);

  @override
  _prDetailScreenState createState() => _prDetailScreenState();
}

class _prDetailScreenState extends State<prDetailScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  double iconSize = 40;
  List<PrApproveList> _ListPRApproved;
  List<MLogPrNumber> _datalogPR = [];
  var indicator = null;

  @override
  void initState() {
    super.initState();
    getdata();
    getlog();
  }

  Future<void> _openPDF(String types, String filename) async {
    String _url = '${URL}UploadFiles/purchaseRequisition/quotation/$filename';

    if (types == "Upload File") {
      _url = '${URL}UploadFiles/purchaseRequisition/uploadfile/$filename';
    } else {
      _url = '${URL}UploadFiles/purchaseRequisition/quotation/$filename';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => PDFscreen(url: _url),
      ),
    );
  }

  Future<void> _luancherInBrowser(String types, String filename) async {
    String url = '${URL}UploadFiles/purchaseRequisition/quotation/$filename';

    if (types == "Upload File") {
      url = '${URL}UploadFiles/purchaseRequisition/uploadfile/$filename';
    } else {
      url = '${URL}UploadFiles/purchaseRequisition/quotation/$filename';
    }

    // if (await urlLaunch.canLaunch(url)) {
    //   await urlLaunch.launch(
    //     url,
    //     forceSafariVC: false,
    //     forceWebView: false,
    //     headers: <String, String>{'header_key': 'header_value'},
    //   );
    // } else {
    //   throw 'Coun\'t launch $url';
    // }
    var aaa = await urlLaunch.canLaunch(url);

    if (await urlLaunch.canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await urlLaunch.launch(url,
          forceSafariVC: false, forceWebView: false);
      if (!nativeAppLaunchSucceeded) {
        await urlLaunch.launch(url, forceSafariVC: false, forceWebView: false);
      }
    }
  }

  Future<void> getdata() async {
    var postProvider = Provider.of<UserProvider>(context, listen: false);
    mUser user = postProvider.getUser();

    if (user.empEmail != null) {
      var prListtProvider = Provider.of<PRListProvider>(context, listen: false);

      prListtProvider.getAll(user.empEmail, '', widget.PRNumber, '', '', '');

      //Navigator.pop(context);
    }

    return;

    // var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
    // _ListPRApproved = prListtProvider.getPRNumber(widget.PRNumber);

    // setState(() {});
  }

  void getlog() async {
    var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
    List<MLogPrNumber> _logPR = await prListtProvider.getlog(widget.PRNumber);
    _datalogPR = _logPR;
    setState(() {});
    print(_logPR);
  }

  void getalllist() async {
    var postProvider = Provider.of<UserProvider>(context, listen: false);
    mUser user = postProvider.getUser();

    if (user.empEmail != null) {
      var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
      prListtProvider.getAll(user.empEmail, '', '', '', '', '');
      Navigator.pop(context);
    }
  }

  void authenticationmainpage() {
    print("Routing to your account");
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Login Successful')));

    Navigator.of(context).pushReplacementNamed(MAINPAGE);
  }

  void openattachfile(String attachfile, String types) {
    if (attachfile != "") {
      var value = attachfile.split(',');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: TestHead(types, Colors.black, FontWeight.bold),
              content: SizedBox(
                height: _height / 100 * 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var i = 0; i < value.length; i++)
                      OutlineButton(
                        onPressed: () {
                          _openPDF(types, value[i]);
                        },
                        child: TestHead(' >>  ${types} ${i + 1}', Colors.black,
                            FontWeight.bold),
                        borderSide: BorderSide(color: Colors.blue),
                        shape: StadiumBorder(),
                      )
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: TestHead('Close', Colors.black, FontWeight.bold),
                ),
              ],
            );
          });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Can\'t open Attach File..')));
    }
  }

  void showuploadimage(String filename) {
    if (filename != "") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: TestHead("Image", Colors.black, FontWeight.bold),
              content: Container(
                child: Image.network(
                    '${URL}UploadFiles/purchaseRequisition/pictureItem/${filename}'),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: TestHead('Close', Colors.black, FontWeight.bold),
                ),
              ],
            );
          });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Image not upload..')));
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => getalllist(),
        ),
        title: Text("PR Detail..."),
      ),
      body: Container(
        child: Material(
          child: Column(
            children: [
              Expanded(
                child: Consumer<PRListProvider>(builder: (BuildContext context,
                    PRListProvider provider, Widget child) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.prList.length,
                          itemBuilder: (BuildContext context, int index) {
                            PrApproveList _dataPR = provider.prList[index];
                            List<Detail> _detail;
                            _detail = _dataPR.details;

                            return Container(
                              width: _width,
                              constraints: BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    header(_dataPR, context),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    subtotal(_dataPR),
                                    btnapprove(_dataPR),
                                    transection(_datalogPR, context),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(PrApproveList _dataPR, BuildContext context) {
    Color colorstatus = Colors.black;

    if (_dataPR.status == "Draft") {
      colorstatus = Color.fromRGBO(236, 235, 234, 1);
    } else if (_dataPR.status == "Request For Approve" ||
        _dataPR.status == "Wait For Approve") {
      colorstatus = Color.fromRGBO(247, 201, 93, 14);
    } else if (_dataPR.status == "Request For Information" ||
        _dataPR.status == "Request For Discuss") {
      colorstatus = Color.fromRGBO(212, 160, 42, 1);
    } else if (_dataPR.status == "Reject") {
      colorstatus = Color.fromRGBO(241, 95, 80, 1);
    } else if (_dataPR.status == "Approve") {
      colorstatus = Color.fromRGBO(69, 153, 248, 1);
    } else if (_dataPR.status == "Request For Verification") {
      colorstatus = Color.fromRGBO(148, 230, 243, 1);
    } else if (_dataPR.status == "Account Verified" ||
        _dataPR.status == "Purchase Verified" ||
        _dataPR.status == "Verified") {
      colorstatus = Color.fromRGBO(75, 184, 201, 1);
    } else if (_dataPR.status == "Wait For PO") {
      colorstatus = Color.fromRGBO(31, 151, 169, 1);
    } else if (_dataPR.status == "Finish") {
      colorstatus = Color.fromRGBO(9, 152, 11, 1);
    } else if (_dataPR.status == "Delete") {
      colorstatus = Color.fromRGBO(236, 235, 234, 1);
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(5.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('PRNumber :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TestHead('${_dataPR.prNumber}', Colors.black54,
                          FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('Area :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TestHead('${_dataPR.BranchPR}', Colors.black54,
                          FontWeight.bold),
                    ),
                  ],
                ),
                TestHead('${_dataPR.status}', colorstatus, FontWeight.bold),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('Department :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TestHead('${_dataPR.department}', Colors.black54,
                          FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TestHead('Sub_Section :', Colors.black, FontWeight.bold),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: TestHead('${_dataPR.subSection}', Colors.black54,
                            FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('Request By :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TestHead('${_dataPR.requestBy}', Colors.black54,
                          FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('CER Number :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TestHead('${_dataPR.forProject}', Colors.black54,
                          FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('Request Date :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TestHead(
                          '${_dataPR.requestDate.toString().substring(0, 10)}',
                          Colors.black54,
                          FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('Require Date :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TestHead(
                          '${_dataPR.requireDate.toString().substring(0, 10)}',
                          Colors.black54,
                          FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('Vender :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TestHead(
                          '${_dataPR.vender}', Colors.black54, FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TestHead('Remark :', Colors.black, FontWeight.bold),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: SizedBox(
                        width: 320,
                        child: TestHead('${_dataPR.detail}', Colors.black54,
                            FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          attachfile(_dataPR.uploadquotation, _dataPR.uploadfile),
          SizedBox(height: 10),
          detail(context),
          details(_dataPR.details, context),
          const Divider(
            color: Colors.black,
            height: 5,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
        ],
      ),
    );
  }

  Widget details(List<Detail> _details, BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return SizedBox(
      height: _height / 100 * 25,
      child: Expanded(
          child: ListView.builder(
        itemCount: _details.length,
        itemBuilder: (BuildContext context, int index) {
          Detail _detailss = _details[index];

          Widget bodydetail;

          if (index == 0 || _detailss.types == "T") {
            bodydetail = Container();
          } else {
            bodydetail = const Divider(
              color: Colors.grey,
              height: 5,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            );
          }

          if (_detailss.types != "T") {
            return Container(
              child: Column(
                children: [
                  bodydetail,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: _width / 100 * 70.0,
                        child: Column(
                          children: [
                            SizedBox(
                              width: _width,
                              child: Expanded(
                                child: TestHead(
                                    _detailss.productCode +
                                        ' : ' +
                                        _detailss.productName,
                                    Colors.black,
                                    FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: SizedBox(
                                width: _width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TestHead(_detailss.glNo + " : ",
                                        Colors.black, FontWeight.bold),
                                    Expanded(
                                      child: TestHead(_detailss.glDesc,
                                          Colors.grey[600], FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: _width / 100 * 21.0,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TestHead('${_detailss.qty}',
                                        Colors.grey[600], FontWeight.normal),
                                    TestHead(
                                        '${_detailss.discount.toInt().toString() ?? "0"} %',
                                        Colors.grey[600],
                                        FontWeight.normal),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TestNumber(
                                        _detailss.unitPrice.toString() ?? "0",
                                        Colors.grey[600],
                                        TextDecoration.none),
                                    TestNumber(
                                        _detailss.amountDiscount.toString() ??
                                            "0",
                                        Colors.grey[600],
                                        TextDecoration.none),
                                    TestNumber(
                                        _detailss.amount.toString() ?? "0",
                                        Colors.black,
                                        TextDecoration.underline),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              child: SizedBox(
                                height: _large ? 25 : (_medium ? 20 : 18),
                                width: double.infinity,
                                child: new FlatButton(
                                  padding: new EdgeInsets.fromLTRB(0, 0, 50, 0),
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.blue,
                                    size: _large ? 25 : (_medium ? 20 : 18),
                                  ),
                                  onPressed: () {
                                    showuploadimage(
                                        _detailss.uploadPicture.toString());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Container(
              child: TestHead('  >> ${_detailss.textFree}', Colors.grey[600],
                  FontWeight.normal),
            );
          }
        },
      )),
    );
  }

  Widget TestHead(String value, Color Col, FontWeight Weight) {
    return Text(value,
        style: TextStyle(
          color: Col,
          fontWeight: Weight,
          fontSize: _large ? 20 : (_medium ? 13.5 : 13),
        ));
  }

  Widget TestNumber(String value, Color Col, TextDecoration TDecoration) {
    return Text(
        '${NumberFormat("#,###.##").format(double.parse(value)) ?? "0"}',
        style: TextStyle(
          color: Col,
          fontWeight: FontWeight.bold,
          fontSize: _large ? 20 : (_medium ? 13.5 : 13),
          decoration: TDecoration,
          decorationStyle: TextDecorationStyle.double,
        ));
  }

  Widget detail(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Detail...',
          //   style: TextStyle(
          //       color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          // ),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        width: _width / 100 * 70.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TestHead(' Product Name ', Colors.black,
                                FontWeight.bold),
                            TestHead(' GL Code , GL Desc', Colors.black,
                                FontWeight.bold),
                          ],
                        )),
                    Container(
                      width: _width / 100 * 21.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TestHead('Qty', Colors.black, FontWeight.bold),
                              TestHead('Dis.', Colors.black, FontWeight.bold),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TestHead('Price', Colors.black, FontWeight.bold),
                              TestHead('Amount', Colors.black, FontWeight.bold),
                              TestHead('Total', Colors.black, FontWeight.bold),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 5,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
        ],
      ),
    );
  }

  Widget attachfile(String quotation, String attachfile) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            onPressed: () {
              openattachfile(quotation, 'Quotation File');
            },
            child: Column(
              children: [
                TestHead('Quotation File', Colors.black, FontWeight.bold),
                Icon(
                  Icons.file_copy,
                  color: Colors.blue,
                  size: _large ? 30 : (_medium ? 25 : 20),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              openattachfile(attachfile, 'Upload File');
            },
            child: Column(
              children: [
                TestHead('Upload File', Colors.black, FontWeight.bold),
                Icon(
                  Icons.file_copy,
                  color: Colors.blue,
                  size: _large ? 30 : (_medium ? 25 : 25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget subtotal(PrApproveList _dataPR) {
    String Currency = "";
    _dataPR.details.forEach((element) {
      if (element.types != "T") Currency = element.currency;
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(5.0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Row(
                children: [
                  TestHead('Currency : ', Colors.black, FontWeight.bold),
                  TestHead(Currency, Colors.black, FontWeight.bold),
                ],
              )),
              Container(
                child: Row(
                  children: [
                    TestHead('Total : ', Colors.black, FontWeight.bold),
                    Text(
                      '${NumberFormat("#,###.##").format(double.parse(_dataPR.total.toString())) ?? "0"}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: _large ? 20 : (_medium ? 17.5 : 15),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TestHead('Discunt : ', Colors.black, FontWeight.bold),
              TestHead('${_dataPR.discount != 0 ? _dataPR.discount : 0} %',
                  Colors.black54, FontWeight.bold),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TestHead('SubTotal : ', Colors.black, FontWeight.bold),
              TestNumber(_dataPR.subTotal.toString() ?? "0", Colors.black,
                  TextDecoration.underline),
            ],
          ),
        ],
      ),
    );
  }

  Widget transection(List<MLogPrNumber> _datalog, BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    if (_datalog.length > 0) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[100],
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            TestHead('Transection', Colors.black, FontWeight.bold),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: _width / 100 * 95,
                height: 250 / 100 * 80,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: _datalog.length,
                    itemBuilder: (BuildContext context, int index) {
                      MLogPrNumber _log = _datalog[index];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TestHead(
                                  _log.users, Colors.black, FontWeight.normal),
                              TestHead(
                                  _log.status, Colors.black, FontWeight.normal),
                              TestHead(
                                  _log.date, Colors.black, FontWeight.normal),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TestHead('Comment : ', Colors.grey,
                                    FontWeight.normal),
                                Expanded(
                                  child: TestHead(_log.comment, Colors.black,
                                      FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                            width: _width,
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void actionprapprovedAC(String PRNumber, String types) {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return prapprovedAC();
    //     });
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => prapprovedAC(PRNumber: PRNumber, types: types),
      ),
    );
  }

  Widget btnapprove(PrApproveList _dataPR) {
    String Currency = "";
    _dataPR.details.forEach((element) {
      if (element.types != "T") Currency = element.currency;
    });

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: _width / 100 * 29,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                actionprapprovedAC(_dataPR.prNumber, 'Approve');
              },
              child: Text(
                'Approve',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: _large ? 20 : (_medium ? 13.5 : 13),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            width: _width / 100 * 40,
            child: drowdownbtnrequest(
              PRNumber: _dataPR.prNumber,
              currency: Currency,
              cordition: _dataPR.subTotal.toString(),
              date: _dataPR.requestDate.toString(),
              large: _large,
              medium: _medium,
            ),
          ),
          Container(
            width: _width / 100 * 29,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                actionprapprovedAC(_dataPR.prNumber, 'Reject');
                // Respond to button press
              },
              child: Text(
                'Reject',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: _large ? 20 : (_medium ? 13.5 : 13),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class drowdownbtnrequest extends StatefulWidget {
  String PRNumber;
  String currency;
  String cordition;
  String date;
  bool large;
  bool medium;
  drowdownbtnrequest(
      {Key key,
      @required this.PRNumber,
      @required this.currency,
      @required this.cordition,
      @required this.date,
      @required this.large,
      @required this.medium})
      : super(key: key);

  @override
  _drowdownbtnrequestState createState() => _drowdownbtnrequestState();
}

class _drowdownbtnrequestState extends State<drowdownbtnrequest> {
  int _value = 1;

  void actionprapprovedAC(String PRNumber, String types) async {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return prapprovedAC();
    //     });
    //print(types);

    if (types == "Request For Account Verify" ||
        types == "Request For Purchase Verify") {
      var postProvider = Provider.of<UserProvider>(context, listen: false);
      mUser user = postProvider.getUser();

      if (user.empEmail != null) {
        var prListtProvider =
            Provider.of<PRListProvider>(context, listen: false);

        List<MGetapprover> getapprover = await prListtProvider.getapprover(
            user.empDepartment,
            widget.cordition,
            widget.currency,
            user.empEmail,
            widget.date);

        if (getapprover.length > 0) {
          MGetapprover _data = getapprover[0];
          if (_data.levels == "1") {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Can\'t access this Menu..')));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) =>
                    prapprovedAC(PRNumber: PRNumber, types: types),
              ),
            );
          }
        }
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => prapprovedAC(PRNumber: PRNumber, types: types),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.orange[200],
      ),
      height: 38,
      child: Expanded(
        child: DropdownButton(
            dropdownColor: Colors.orange[200],
            value: _value,
            items: [
              DropdownMenuItem(
                child: Text(
                  "Req. For Infomation",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: widget.large ? 20 : (widget.medium ? 12 : 12),
                      fontWeight: FontWeight.bold),
                ),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text(
                  "Req. For Discuss",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: widget.large ? 20 : (widget.medium ? 12 : 12),
                      fontWeight: FontWeight.bold),
                ),
                value: 2,
              ),
              DropdownMenuItem(
                  child: Text(
                    "Req. For Account Verify",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize:
                            widget.large ? 20 : (widget.medium ? 11.5 : 11.5),
                        fontWeight: FontWeight.bold),
                  ),
                  value: 3),
              DropdownMenuItem(
                  child: Text(
                    "Req. For Purchase Verify",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize:
                            widget.large ? 20 : (widget.medium ? 11.5 : 11.5),
                        fontWeight: FontWeight.bold),
                  ),
                  value: 4)
            ],
            onChanged: (value) {
              setState(() {
                _value = value;
                if (value == 1) {
                  actionprapprovedAC(
                      widget.PRNumber, 'Request For Information');
                } else if (value == 2) {
                  actionprapprovedAC(widget.PRNumber, 'Request For Discuss');
                } else if (value == 3) {
                  actionprapprovedAC(
                      widget.PRNumber, 'Request For Account Verify');
                } else if (value == 4) {
                  actionprapprovedAC(
                      widget.PRNumber, 'Request For Purchase Verify');
                }
              });
            }),
      ),
    );
  }
}
