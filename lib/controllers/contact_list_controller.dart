import 'package:get/get.dart';
import 'package:itp_voice/controllers/call_history_controller.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/contactList.dart';
import 'package:itp_voice/repo/contacts_repo.dart';

class ContactListController extends GetxController {

Rx<bool> isListLoading= false.obs;
Rx<bool> isLoadingMore= false.obs;
ContactsRepo repo = ContactsRepo();
List<ContactList> list = [];
Rx<int> offset = 0.obs;

fetchList() async {
  list.clear();
  isListLoading.value= true;
offset.value=0;
final res =await repo.getContactsLists( offset);

if(res!=null){
 list.addAll(res);
}
else{
  print("SOMETHING FISHY");
}

offset.value=15;
isListLoading.value=false;
update();
}



loadMoreList() async {
isLoadingMore.value=true;

final res = await repo.getContactsLists(offset);
if(res!=null){
  list.addAll(res);
}
else{
  //Nothing would happen
}

offset.value+=10;
update();
}

editListName(String name, String id) async {
  isLoadingMore.value= true;
  final res = await repo.updateListName(name, id);
  if(res!=null){
    
  }
  else{
    print("SOMETHING FISHY");
  }


isLoadingMore.value= false;
}

addList(String name) async {
  isLoadingMore.value= true;
  await repo.addList(name);
  
  
  
  isLoadingMore.value=false;
}

deleteList(String id) async {
  isLoadingMore.value= true;
  final res = await repo.deleteList(id);
  if(res!=null){
    
  }
  else{
    print("SOMETHING FISHY");
  }
  isLoadingMore.value= false;

}
}