// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

class CustomDebug {
  String fileName = "";
  String className = "";
  String functionName = "";
  String functionParameters = "";

  CustomDebug(
    this.fileName,
    this.className,
    this.functionName,
    this.functionParameters,
  );

  void writeLog({String state = "", String value = ""}) {
    String logMessage = "";
    String logName = "";

    // Message
    if (state.isNotEmpty) logMessage += "$state ";
    if (value.isNotEmpty) logMessage += "$value ";

    // Name
    if (fileName.isNotEmpty) logName += "$fileName";
    if (className.isNotEmpty) logName += ".$className";
    if (functionName.isNotEmpty) logName += ".$functionName";
    if (functionParameters.isNotEmpty) {
      logName += "($functionParameters)";
    } else {
      logName += "()";
    }

    // logMessage += "[$logName]";

    log(logMessage, name: logName);
  }
}
