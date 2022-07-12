import '../../utilities/app_constants.dart';

class Claim {

  // CUSTOMER DETAILS
  final String insuredName;
  final String insuredCity;
  final String insuredState;
  final String insuredContactNumber;
  final String insuredAltContactNumber;
  final String email;

  // POLICY DETAILS
  final String policyNumber;
  final String policyStartDate;
  final String policyEndDate;

  // CLAIM DETAILS
  final int claimID;
  final String claimNumber;
  final String lossLocationCity;
  final String lossLocationState;
  final String lossType;
  final String sumInsured;
  final String balanceSumInsured;
  final String registrationDate;
  final String dateOfLoss;

  // PRODUCT DETAILS
  final String productCode;
  final String productType;
  final String assetCategory;
  final String manufacturer;
  final String model;
  final String imei;

  final String otsEligible;
  final String otsRemarks;
  final String closureDate;
  final String managerName;
  final String surveyorName;
  final String lastModifiedBy;
  final String otsManagerCallerNumber;

  Claim.fromJson(Map<String, dynamic> decodedJson)
      : claimID = decodedJson['id'] != null ? int.parse(decodedJson["id"]) : 0,
        //  CUSTOMER INFO
        insuredName = _cleanOrConvert(decodedJson["Insured_Name"]),
        insuredCity = _cleanOrConvert(decodedJson["Insured_City"]),
        insuredState = _cleanOrConvert(decodedJson["Insured_State"]),
        insuredContactNumber = _cleanOrConvert(
          decodedJson["Insured_Contact_Number"],
        ),
        insuredAltContactNumber = _cleanOrConvert(
          decodedJson["Insured_Alternate_Contact_Number"],
        ),
        email = _cleanOrConvert(decodedJson["Email_Id"]),

        // PRODUCT DETAILS
        productType = _cleanOrConvert(decodedJson["Product_Type"]),
        productCode = _cleanOrConvert(decodedJson['Product_Code']),
        assetCategory = _cleanOrConvert(decodedJson['Asset_Category']),
        imei = _cleanOrConvert(decodedJson['IMEI_Serial_Number']),
        manufacturer = _cleanOrConvert(decodedJson["Manufacturer"]),
        model = _cleanOrConvert(decodedJson["Model"]),

        // POLICY DETAILS
        policyNumber = _cleanOrConvert(decodedJson["Policy_Number"]),
        policyStartDate = _cleanOrConvert(decodedJson["Policy_start_date_From"]),
        policyEndDate = _cleanOrConvert(decodedJson["Policy_start_date_To"]),

        // CLAIM DETAILS
        claimNumber = _cleanOrConvert(decodedJson["Claim_No"]),
        lossLocationCity = _cleanOrConvert(decodedJson["Loss_Location_City"]),
        lossLocationState = _cleanOrConvert(decodedJson["Loss_Location_State"]),
        lossType = _cleanOrConvert(decodedJson['Loss_Type']),
        sumInsured = _cleanOrConvert(decodedJson['Sum_Insured']),
        balanceSumInsured = _cleanOrConvert(decodedJson['Balance_Sum_Insured']),
        registrationDate = _cleanOrConvert(decodedJson['Registration_Date']),
        dateOfLoss = _cleanOrConvert(decodedJson["Date_of_Loss"]),

        // EXTRAS
        otsEligible = _cleanOrConvert(decodedJson['OTS_Eligible']),
        otsRemarks = _cleanOrConvert(decodedJson['OTS_Remarks']),
        closureDate = _cleanOrConvert(decodedJson['Closure_Date']),
        managerName = _cleanOrConvert(decodedJson['Manager_Name']),
        surveyorName = _cleanOrConvert(decodedJson['Surveyor_Name']),
        lastModifiedBy = _cleanOrConvert(decodedJson['Last_Modified_By']),
        otsManagerCallerNumber = _cleanOrConvert(decodedJson['OTS_Manager_Caller_Number']);

  Map<String, Map<String, dynamic>> toMap() {
    return <String, Map<String, dynamic>>{
      'Customer Information': <String, dynamic>{
        'Insured name': insuredName,
        'Mobile number': insuredContactNumber,
        'Alternate number': insuredAltContactNumber,
        'Email ID': email,
        'State' : insuredState,
        'City name' : insuredCity
      },
      'Policy Details': <String, dynamic>{
        'Policy number': policyNumber,
        'Policy start date': policyStartDate,
        'Policy end date': policyEndDate,
      },
      'Product Details': <String, dynamic>{
        'Product type': productType,
        'Product code' : productCode,
        'Asset category' : assetCategory,
        'Manufacturer': manufacturer,
        'Model number': model,
        'IMEI/Serial Number' : imei,
      },
      'Claim Details': <String, dynamic>{
        'Claim no.' : claimNumber,
        'Location': _createAddress(lossLocationCity, lossLocationState),
        'Loss type/Defect': lossType,
        'Sum insured' : sumInsured,
        'Balance sum insured' : balanceSumInsured,
        'Registration date' : registrationDate,
        'Loss date': dateOfLoss,
        'OTS eligible/Denial reason' : otsEligible,
        'OTS remarks/Description' : otsRemarks,
        'Closure date' : closureDate,
        'Last modified by/OTS manager name' : lastModifiedBy,
        'OTS manager caller number' : otsManagerCallerNumber,
      }
    };
  }

  Map<String, dynamic> toInternetMap() {
    return <String, String>{

      'Insured_Name': insuredName,
      'Insured_Contact_Number': insuredContactNumber,
      'Insured_Alternate_Contact_Number': insuredAltContactNumber,
      'Email_Id': email,
      'Insured_State' : insuredState,
      'Insured_City' : insuredCity,

      'Policy_Number': policyNumber,
      'Policy_start_date_From': policyStartDate,
      'Policy_start_date_To': policyEndDate,

      'Product_Type': productType,
      'Product_Code' : productCode,
      'Asset_Category' : assetCategory,
      'Manufacturer': manufacturer,
      'Model': model,
      'IMEI_Serial_Number' : imei,

      'Claim_No' : claimNumber,
      'Location': _createAddress(lossLocationCity, lossLocationState),
      'Loss_Location_City' : lossLocationCity,
      'Loss_Location_State' : lossLocationState,
      'Loss_Type': lossType,
      'Sum_Insured' : sumInsured,
      'Balance_Sum_Insured' : balanceSumInsured,
      'Registration_Date' : registrationDate,
      'Date_of_Loss': dateOfLoss,
      'OTS_Eligible' : otsEligible,
      'OTS_Remarks' : otsRemarks,
      'Closure_Date' : closureDate,
      'Manager_Name': managerName,
      'Surveyor_Name': surveyorName,
      'Last_Modified_By' : lastModifiedBy,
      'OTS_Manager_Caller_Number' : otsManagerCallerNumber,
    };
  }

  String get customerAddress {
    return _createAddress(insuredCity, insuredState);
  }

  String get lossAddress {
    return _createAddress(lossLocationCity, lossLocationState);
  }

  static String _cleanStrings(String? string) {
    if (string == null || string.isEmpty) {
      return "Unavailable";
    }
    return string;
  }

  static String _cleanOrConvert(Object? object) {
    if (object != null) {
      String string = object.toString();
      return _cleanStrings(string);
    }
    return "Unavailable";
  }

  String _createAddress(String city, String state) {
    if (city != AppStrings.unavailable && state != AppStrings.unavailable) {
      return "$city, $state";
    } else if (city != AppStrings.unavailable) {
      return city;
    } else if (state != AppStrings.unavailable) {
      return state;
    } else {
      return AppStrings.unavailable;
    }
  }

  static List<String> get fields {
    return [
      'Insured Name',
      'Mobile no.',
      'Alternate no.',
      'Email ID',
      'Insured state',
      'Insured city',
      'Policy number',
      'Policy start date',
      'Policy end date',
      'Product type',
      'Product code',
      'Asset category',
      'Manufacturer',
      'Model',
      'IMEI serial number',
      "Claim no.",
      "Location",
      "Loss location city",
      "Loss location state",
      "Loss type",
      "Sum insured",
      "Balance sum insured",
      "Registration date",
      "Date of loss",
      "OTS eligible",
      "OTS remarks",
      "Closure date",
      "Last modified by",
      "OTS manager caller number",
    ];
  }

  static List<String> get createFields {
    return <String>[
      "Insured_Name",
      "Insured_Contact_Number",
      "Insured_Alternate_Contact_Number",
      "Email_Id",
      "Insured_State",
      "Insured_City",
      "Policy_Number",
      "Policy_start_date_From",
      "Policy_start_date_To",
      "Product_Type",
      "Product_Code",
      "Asset_Category",
      "Manufacturer",
      "Model",
      "IMEI_Serial_Number",
      "Claim_No",
      "Location",
      "Loss_Location_City",
      "Loss_Location_State",
      "Loss_Type",
      "Sum_Insured",
      "Balance_Sum_Insured",
      "Registration_Date",
      "Date_of_Loss",
      "OTS_Eligible",
      "OTS_Remarks",
      "Closure_Date",
      "Last_Modified_By",
      "OTS_Manager_Caller_Number",
    ];
  }

  static Map<String, String> getLabelDataMap() {
    return Map.fromIterables(fields, createFields);
  }
}
