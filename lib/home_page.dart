import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pagination_flutter/provider/data_provider.dart';
import 'package:provider/provider.dart';

import 'models/data_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool isLoading = false;
  ConnectivityResult connectivityResult;
  bool connection=false;

  Future<void> checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      print("Connected to wifi network");
      setState(() {
        connection=true;
      });
    } else if (result == ConnectivityResult.mobile) {
      setState(() {
        connection=true;
      });
      print("Connected to mobile network");
    } else {
      setState(() {
        connection=false;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please Check your internet or wifi connection",
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
      ));
    }
    print("connectionResult$result");
    setState(() {
      connectivityResult = result;

    });
  }
StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    checkConnectivityState();
_streamSubscription=Connectivity().onConnectivityChanged.listen((event) {
  setState(() {
    connectivityResult=event;


  });
  print("connectivityResult$connectivityResult");
});
    var videosBloc = Provider.of<DataProvider>(context, listen: false);
    videosBloc.resetStreams();
    videosBloc.fetchAllUsers(_page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        videosBloc.setLoadingState(LoadMoreStatus.LOADING);
        videosBloc.fetchAllUsers(++_page);
      }
    });
  }
final scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Jakes Git"),
        actions: [
          connection==true?Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.wifi),
          ):Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.wifi_off),
          )
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, usersModel, child) {
          if (usersModel.allUsers != null && usersModel.allUsers.length > 0) {
            return _listView(usersModel);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _listView(DataProvider dataProvider) {
    return ListView.separated(
      itemCount: dataProvider.allUsers.length,
      controller: _scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        print("------------------------------");
        print("index $index");
        print("------------------------------");
        print("dataProvider.allUsers.length ${dataProvider.allUsers.length}");

        if ((index == dataProvider.allUsers.length - 1)) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildRow(dataProvider.allUsers[index]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _buildRow(ItemModel itemModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Column(
        children: [
          Card(
              elevation: 5,
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                child: Image.network(
                                  itemModel.owner.avatarUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        itemModel.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        itemModel.description ?? "",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Icon(
                                            Icons.keyboard_arrow_right_outlined,
                                            size: 15,
                                          ),
                                          Expanded(
                                              child: Text(
                                                itemModel.language.toString(),
                                                style: TextStyle(fontSize: 12),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.insert_emoticon_rounded,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                                child: Text(
                                                  itemModel.watchers.toString(),
                                                  style: TextStyle(
                                                      fontSize: 12),
                                                )),
                                          ],
                                        )),
                                    Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.adb_outlined,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                                child: Text(
                                                  itemModel.forksCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12),
                                                )),
                                          ],
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
