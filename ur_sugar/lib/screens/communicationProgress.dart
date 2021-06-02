import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:ur_sugar/apis/inprogress-api.dart';
import 'package:http/http.dart' as http;
import 'package:ur_sugar/screens/logDetails.dart';
import 'package:ur_sugar/screens/scheduleActivity.dart';
import 'package:ur_sugar/utils/comProgressModal.dart';
import 'package:ur_sugar/utils/nowLoading.dart';

class CommunicationProgress extends StatefulWidget {
  const CommunicationProgress({Key key, this.referral_code_id, this.userId})
      : super(key: key);
  final int referral_code_id;
  final int userId;

  @override
  _CommunicationProgressState createState() => _CommunicationProgressState();
}

class _CommunicationProgressState extends State<CommunicationProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Communication Inprogress,',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'DmSans'),
                  ),
                  Text(
                    'check out your communications!',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        fontFamily: 'DmSans'),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Table2>>(
              future: fetchProgress(http.Client(), widget.referral_code_id),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? CommunicationList(
                        communications: snapshot.data,
                        userId: widget.userId,
                        referral_code_id: widget.referral_code_id)
                    : Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      )),
    );
  }
}

class CommunicationList extends StatefulWidget {
  const CommunicationList(
      {Key key, this.communications, this.referral_code_id, this.userId})
      : super(key: key);
  final List<Table2> communications;
  final int referral_code_id;
  final int userId;

  @override
  _CommunicationListState createState() => _CommunicationListState();
}

class _CommunicationListState extends State<CommunicationList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: widget.communications.length,
      itemBuilder: (context, index) {
        Table2 item = widget.communications[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 4,
            child: Container(
              height: 195,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(left: 6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#' + item.caseId,
                            style: TextStyle(
                                fontFamily: 'DmSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 9),
                          ),
                          Spacer(),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey.shade100),
                            child: IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.blueGrey.shade800,
                                  size: 16,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10)),
                                      ),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ModalPopup(
                                            refId: widget.referral_code_id,
                                            userId: widget.userId,
                                            namePatient: item.patientName,
                                            age: item.age,
                                            docId: item.doctorId,
                                            casedId: item.caseId,
                                            patientId: item.patientId,
                                            doctorName: item.doctorName,
                                            gender: item.gender);
                                      });
                                }),
                          )
                        ],
                      ),
                      Text(
                        item.patientName,
                        style: TextStyle(
                            fontFamily: 'DmSans',
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                      Row(
                        children: [
                          (item.gender == 1)
                              ? Text(
                                  item.age + ' yrs/Male',
                                  style: TextStyle(
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: Colors.grey.shade500),
                                )
                              : Text(
                                  item.age + ' yrs/Female',
                                  style: TextStyle(
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: Colors.grey.shade500),
                                ),
                          Spacer(),
                          Text(
                            item.phoneNumber1 ?? 'not registered',
                            style: TextStyle(
                                fontFamily: 'DmSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 8,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            item.doctorName,
                            style: TextStyle(
                                fontFamily: 'DmSans',
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            item.hospitalName,
                            style: TextStyle(
                                fontFamily: 'DmSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey.shade500),
                          ),
                          Spacer(),
                          Text(
                            item.doctorPhoneNumber ?? 'not registered',
                            style: TextStyle(
                                fontFamily: 'DmSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'magic internal doctor',
                            style: TextStyle(
                                fontFamily: 'DmSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey.shade500),
                          ),
                          Spacer(),
                          Text(
                            item.classification ?? 'null',
                            style: TextStyle(
                                fontFamily: 'DmSans',
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.lightBlue.shade500),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        width: 220,
                        decoration:
                            BoxDecoration(color: Colors.blueGrey.shade200),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Text(
                                'Referred Date - ',
                                style: TextStyle(
                                    fontFamily: 'DmSans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                              Text(
                                item.createdOn,
                                style: TextStyle(
                                  fontFamily: 'DmSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Colors.blueGrey.shade800,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'first referral for this patient',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'DmSans',
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Colors.grey.shade600),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
