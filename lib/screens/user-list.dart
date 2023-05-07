import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yarazon/helpers/constants.dart';
import 'package:yarazon/helpers/helper.dart';
import 'package:yarazon/screens/home.dart';
import 'package:yarazon/screens/message-list.dart';

enum NavigateFrom { addMembers, userList }

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key, required this.navigateFrom})
      : super(key: key);
  final NavigateFrom navigateFrom;

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> with UserListener {
  List<User> userList = [];
  List<User> addMemberList = [];
  Set<int> selectedIndex = {};
  var selectedLanguage = Get.locale?.languageCode.obs;
  bool isLoading = true;
  bool hasMoreUsers = true;

  late UsersRequest usersRequest;

  @override
  void onUserOnline(User user) {
    if (userList.contains(user)) {
      int index = userList.indexOf(user);
      userList[index].status = CometChatUserStatus.online;
      setState(() {});
    }
  }

  @override
  void onUserOffline(User user) {
    if (userList.contains(user)) {
      int index = userList.indexOf(user);
      userList[index].status = CometChatUserStatus.offline;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    CometChat.addUserListener("user_Listener_id", this);
    getUserData();
    requestBuilder();
  }

  requestBuilder() {
    usersRequest = (UsersRequestBuilder()..limit = 30
        // ..searchKeyword = "abc"
        // ..userStatus = CometChatUserStatus.online
        // ..hideBlockedUsers = true
        // ..friendsOnly = true
        // ..tags = []
        // ..withTags = true
        // ..uids = []
        )
        .build();

    loadMoreUsers();
  }

  loginUser() async {
    String authKey = CometChatAuthConstants.authKey;
    await CometChat.login(USERID, authKey, onSuccess: (User user) {
      debugPrint("Login Successful : $user");
    }, onError: (CometChatException e) {
      debugPrint("Login failed with exception:  ${e.message}");
    });
  }

  getUserData() async {
    var user = await CometChat.getLoggedInUser();
    setState(() {
      USERID = user!.uid;
      loginUser();
    });
  }

  //Function to load more users
  loadMoreUsers() async {
    isLoading = true;

    await usersRequest.fetchNext(onSuccess: (List<User> fetchedList) {
      print('onSuccess');
      //-----if fetch list is empty then there no more users left----
      debugPrint(fetchedList.toString());

      if (fetchedList.isEmpty) {
        setState(() {
          isLoading = false;
          hasMoreUsers = false;
        });
      }
      //-----else more users will be fetch at end of list----
      else {
        setState(() {
          isLoading = false;
          userList.addAll(fetchedList);
        });
      }
    }, onError: (CometChatException exception) {
      print('exception $exception');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffbfbfb),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            '',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xff333333),
                fontFamily: selectedLanguage == 'en' ? 'lucymar' : 'LBC'),
          ),
          leading: IconButton(
              onPressed: () {
                print('Go To Home');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xff333333),
                size: 22,
                textDirection: selectedLanguage == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
              )),
        ),
        body: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                //-----Search Box on user list-----
                Container(
                  height: 50,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: Color(0xfff4f4f4))),
                  child: Center(
                    child: TextField(
                      onSubmitted: (String val) {
                        usersRequest = (UsersRequestBuilder()
                              ..limit = 30
                              ..searchKeyword = val)
                            .build();
                        userList = [];
                        setState(() {});

                        loadMoreUsers();
                      },
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 17),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xfff4f4f4),
                        hintText: "Search Support".tr,
                        hintStyle: TextStyle(
                            color: Color(0xff333333),
                            fontFamily:
                                selectedLanguage == 'en' ? 'lucymar' : 'LBC',
                            fontSize: 14),
                        prefixIcon: Icon(
                          Icons.search,
                          color: const Color(0xff141414).withOpacity(0.40),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(width: 2, color: Color(0xfff4f4f4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                        color: primaryColor,
                        size: 30,
                      ))
                    : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: hasMoreUsers
                              ? userList.length + 1
                              : userList.length,
                          itemBuilder: (context, index) {
                            if (index >= userList.length && hasMoreUsers) {
                              //-----if end of list then fetch more users-----
                              if (!isLoading) {
                                loadMoreUsers();
                              }
                              return Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: primaryColor,
                                  size: 30,
                                ),
                              );
                            }

                            final user = userList[index];

                            return Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: selectedIndex.contains(index)
                                    ? Colors.grey
                                    : Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xfff4f4f4), width: 1)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffccccccc),
                                    blurRadius: 4,
                                    offset: Offset(4, 8),
                                  )
                                ],
                              ),
                              child: Center(
                                child: ListTile(
                                    onTap: () {
                                      CometChat.getConversation(
                                          user.uid, ConversationType.user,
                                          onSuccess:
                                              (Conversation conversation) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MessageListScreen(
                                                      conversation:
                                                          conversation,
                                                    )));
                                      }, onError: (CometChatException e) {
                                        Conversation createConversation =
                                            Conversation(
                                          conversationType:
                                              ConversationType.user,
                                          conversationWith: user,
                                        );
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MessageListScreen(
                                                      conversation:
                                                          createConversation,
                                                    )));
                                      });
                                    },
                                    leading: CircleAvatar(
                                        maxRadius: 25,
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                                maxRadius: 25,
                                                backgroundColor:
                                                    Color(0xfff4f4f4),
                                                foregroundColor:
                                                    Color(0xff333333),
                                                child: user.avatar != null &&
                                                        user.avatar!.isNotEmpty
                                                    ? Image.network(
                                                        user.avatar!)
                                                    : Text(user.name
                                                        .substring(0, 1))),
                                            if (widget.navigateFrom ==
                                                    NavigateFrom.userList &&
                                                user.status != null)
                                              Positioned(
                                                height: 12,
                                                width: 12,
                                                right: 1,
                                                bottom: 1,
                                                child: Container(
                                                  height: 12,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                      color: user.status ==
                                                              CometChatUserStatus
                                                                  .online
                                                          ? Colors.green
                                                          : Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              )
                                          ],
                                        )),
                                    title: Text(
                                      user.name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff333333),
                                          fontFamily: selectedLanguage == 'en'
                                              ? 'lucymar'
                                              : 'LBC'),
                                    ),
                                    subtitle: Text('${user.uid}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff666666),
                                            fontFamily: selectedLanguage == 'en'
                                                ? 'lucymar'
                                                : 'LBC'))),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            )));
  }
}
