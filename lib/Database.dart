import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase
{
  uploadnewuser(String name,String email)
  {
    CollectionReference users= FirebaseFirestore.instance.collection('users');
    users.add({'name': name, 'email': email});
  }
 Future<bool> check_existingusers(String email) async
 {
   bool val;
   QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: email).get();
   if(querySnapshot.docs.length==0)
     return false;
   else
     return true;
 }
  searchusers(String name) async
  {
    return await FirebaseFirestore.instance.collection('users').where("name", isEqualTo: name).get();
  }
  createChatRoom(String user1_user2,String email1,String usern1,String email2,String usern2)
  {
    FirebaseFirestore.instance.collection("chats").doc(user1_user2).set({"chatroomid": user1_user2,"email1": email1,"email2": email2,"participants": [usern1,usern2]});
  }
  getchats(String chatroomid) async
  {
    return FirebaseFirestore.instance.collection("chats").doc(chatroomid).collection("messages").orderBy('time',descending: true).snapshots();
  }
  addmessage(String chatroomid,String text,String sender)
  {
    FirebaseFirestore.instance.collection("chats").doc(chatroomid).collection("messages").add({"sender":sender,"text": text,"time": Timestamp.now()});
  }
  getchatrooms(String name) async
  {
    return FirebaseFirestore.instance.collection("chats").where("participants", arrayContains: name).snapshots();
  }
}