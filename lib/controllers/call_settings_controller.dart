import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:itp_voice/models/call_forwarding_setting_model.dart';
import 'package:itp_voice/repo/auth_repo.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/storage_keys.dart';

class CallSettingsController extends GetxController {
  RxBool isLoading = false.obs;
  AuthRepo authRepo = AuthRepo();
  CallForwardSettings? setting;
  VoicemailDetails? voicemailDetails ;
  

  RxBool callForwarding = false.obs;

  // CALLER ID SETTINGS
  final RxBool _overrideDefaultCallerIdSettings = false.obs;
  bool get overrideDefaultCallerIdSettings => _overrideDefaultCallerIdSettings.value;
  set overrideDefaultCallerIdSettings(bool value) {
    print(value);
    if (value == false) {
      SharedPreferencesMethod.storage.remove(StorageKeys.CURRENT_CALL_NAME);
      SharedPreferencesMethod.storage.remove(StorageKeys.CURRENT_CALL_NUMBER);
    }
    _overrideDefaultCallerIdSettings.value = value;
    isLoading.value = true;
    isLoading.value = false;
  }

  TextEditingController callerNameController = TextEditingController();
  TextEditingController callerNnumberController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  updateOverriddenCallerData() async {
    await SharedPreferencesMethod.storage.setString(StorageKeys.CURRENT_CALL_NAME, callerNameController.text);
    await SharedPreferencesMethod.storage.setString(StorageKeys.CURRENT_CALL_NUMBER, callerNnumberController.text);
  }

  RxBool forwardDirectCallsOnly = false.obs;
  RxBool keepOriginalCallerId = false.obs;
  RxBool callRecordingInternal = false.obs;
  RxBool callRecordingExternal = false.obs;
  RxBool voiceMail =false.obs;
  RxBool deleteVoiceMail = false.obs;

  @override
  Future<void> onInit() async {
    String? callNumber = SharedPreferencesMethod.storage.getString(StorageKeys.CURRENT_CALL_NUMBER);
    if (callNumber != null) {
      callerNameController.text = SharedPreferencesMethod.storage.getString(StorageKeys.CURRENT_CALL_NAME) ?? '';
      callerNnumberController.text = SharedPreferencesMethod.storage.getString(StorageKeys.CURRENT_CALL_NUMBER) ?? '';
      _overrideDefaultCallerIdSettings.value = true;
      
    }
    isLoading.value = true;
    isLoading.value = false;
    await getSettings();
    super.onInit();
  }

  getSettings()async{
    isLoading.value = true;
    setting = await authRepo.getSettings();
    voicemailDetails = await authRepo.getSettingsVoice();
    callForwarding.value = setting!.callforwardEnable ?? false;
    forwardDirectCallsOnly.value = setting!.callforwardQueueCalls ?? false;
    keepOriginalCallerId.value = setting!.callforwardKeepCallerCallerId ?? false;
    numberController.text = setting!.callforwardNumber ?? '';
    callerNameController.text = setting!.callername ?? '';
    callerNnumberController.text = setting!.callernumber ?? '';
    callRecordingInternal.value = setting!.internalCall ?? false;    
    callRecordingExternal.value = setting!.externalCall ?? false;
    voiceMail.value = voicemailDetails!.sendVoicemail =="yes"?true:false;
    deleteVoiceMail.value = voicemailDetails!.deleteVoicemail =="yes"?true:false;


    isLoading.value = false;
  }

  setEnableCallForwarding(body,value) async {
    
    bool status = await authRepo.setEnableCallForwarding(body,value);
    
    if(status){
      print("All clear");
    }
    else{
      print("Not loaded");
    }

    


  }

  setEnableVoice(body,value) async {
    
    bool status = await authRepo.setEnableVoice(body,value);
    
    if(status){
      print("All clear");
    }
    else{
      print("Not loaded");
    }

    


  }


  setCallerId()async{
    bool status = await authRepo.setCallerId(callerNameController.text, callerNnumberController.text);
    
    if(status){
      print("All clear");
      Get.snackbar("Saved", "Number saved successfully");
    }
    else{
      Get.snackbar("Not Saved", "Saving Unsuccessful");
    }
  }

  setCallForwardingNumber(String number) async {
    
    bool status = await authRepo.setCallForwardingNumber(number);
    
    if(status){
      print("All clear");
      Get.snackbar("Saved", "Number saved successfully");
    }
    else{
      Get.snackbar("Not Saved", "Saving Unsuccessful");
    }

    


  }


    validate(String value) {
    // Trim the input string
    String trimmedValue = value.trim();

    

    // Try parsing the string to a number
    if (double.tryParse(trimmedValue) == null) {
     Get.snackbar("Number invalid",'Please enter a valid number' );
     return false;
    }

    // Return null if the input is a valid number (indicating no error)
    return true;
  }





}


