import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/call_history_controller.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/contactList.dart';
import 'package:itp_voice/models/tag_model.dart';
import 'package:itp_voice/repo/contacts_repo.dart';

class TagListController extends GetxController {

Rx<bool> isListLoading= false.obs;
Rx<bool> isLoadingMore= false.obs;
ContactsRepo repo = ContactsRepo();
List<Tag> list = [];
Rx<int> offset = 0.obs;
var currentcolor = Color(0xFFFFFFFF).obs;
RxBool isColor = false.obs;



fetchList() async { 
    list.clear(); // Clear the list initially
    isListLoading.value = true; // Set loading to true
    offset.value = 0; // Reset the offset
    
    try {
      final res = await repo.getTagsList(offset.value); // Fetch the list through API
      
      if (res != null) {
        list.addAll(res); // Add the fetched data to the list
        offset.value += 15; // Increment the offset for the next batch
      } else {
        print("SOMETHING FISHY");
      }
    } catch (e) {
      print("Error fetching list: $e");
    } finally {
      isListLoading.value = false; // Set loading to false after completion
      update(); // Notify the UI to refresh
    }
  }



loadMoreList() async {
isLoadingMore.value=true;

final res = await repo.getTagsList(offset);
if(res!=null){
  list.addAll(res);
}
else{
  //Nothing would happen
}

offset.value+=10;
update();
}

editTagName(String name, String id,String colors) async {
  isLoadingMore.value= true;
  if(colors=="FFFF"){
    colors ="";
  }
  final res = await repo.updateTagInfo(name, id, colors);
  if(res!=null){
    
  }
  else{
    print("SOMETHING FISHY");
  }


isLoadingMore.value= false;
}


addTagOnContact(String contactId, List tags,) async {
  isLoadingMore.value= true;
  final res = await repo.addTagOnContact(contactId,tags);
  if(res!=null){
   print("Just OK Nothing to change");
  }
  else{
    print("SOMETHING FISHY");
  }
  Get.snackbar("Tag Added", 'Tag has been added to the contact');
  isLoadingMore.value = false;
}




addTag(String name, String color) async {
  isListLoading.value= true;
  final res = await repo.addTag(name, color);
  if(res!=null){
    list.add(res);
  }
  else{
    print("SOMETHING FISHY");
  }
}

deleteTag(String id) async {
  isListLoading.value= true;
  print("____________________________________________________");
  await repo.deleteTag(id);
  print("_________________________________after delete");
  


isListLoading.value= false;
}



}