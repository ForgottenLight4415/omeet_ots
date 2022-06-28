import '../../utilities/app_constants.dart';

class Claim {
  final int claimID;
  final String typeOfClaim;
  final String dateOfTheft;
  final String dateOfIntimation;
  final String invReferralDate;
  final String productType;
  final String locationCode;
  final String claimNumber;
  final String policyNumber;
  final String insuredName;
  final String insuredContactNumber;
  final String insuredAltContactNumber;
  final String email;
  final String policyStartDate;
  final String policyEndDate;
  final String vehicleRegistrationNumber;
  final String make;
  final String model;
  final String engineNumber;
  final String chassisNumber;
  final String reserveAmount;
  final String prevInsurerName;
  final String prevPolicyNumber;
  final String prevPolicyExpDate;
  final String noClaimBonus;
  final String imtEndorsement;
  final String insuredCity;
  final String insuredState;
  final String lossLocationCity;
  final String lossLocationState;
  final String pastClaimNumber;
  final String dateOfLoss;
  final String previousTypeOfClaim;
  final String autoManualTrigger;
  final String managerName;
  final String surveyorName;
  final String lotNo;
  final String dateOfAllocation;
  final String timeOfAllocation;
  final String currentStatus;
  final String scheduler;
  final String videoOps;
  final String videoOpsStatement;
  final String finalConclusion;
  final String videoMeetDate;
  final String videoMeetTime;
  final String tat;
  final String kycStatus;
  final String kycStatusProof;
  final String faceMatch;

  Claim.fromJson(Map<String, dynamic> decodedJson)
      : claimID = int.parse(decodedJson["id"]),
        //  CUSTOMER INFO
        insuredName = cleanStrings(decodedJson["Insured_Name"]),
        insuredCity = cleanOrConvert(decodedJson["Insured_City"]),
        insuredState = cleanStrings(decodedJson["Insured_State"]),
        insuredContactNumber = cleanStrings(
          decodedJson["Insured_Contact_Number"],
        ),
        insuredAltContactNumber = cleanStrings(
          decodedJson["Insured_Alternate_Contact_Number"],
        ),
        email = cleanStrings(decodedJson["Insured_Alternate_Contact_Number"]),

        // VEHICLE DETAILS
        productType = cleanStrings(decodedJson["Product_Type"]),
        make = cleanStrings(decodedJson["Make"]),
        model = cleanStrings(decodedJson["Model"]),
        engineNumber = cleanStrings(decodedJson["Engine_No"]),
        chassisNumber = cleanStrings(decodedJson["Engine_No"]),
        vehicleRegistrationNumber = cleanStrings(decodedJson["Vehicle_Reg_No"]),

        // POLICY DETAILS
        policyNumber = cleanStrings(decodedJson["Policy_Number"]),
        policyStartDate = cleanStrings(decodedJson["Policy_start_date_From"]),
        policyEndDate = cleanStrings(decodedJson["Policy_start_date_To"]),
        prevPolicyNumber = cleanStrings(decodedJson["Previous_Policy_Number"]),
        prevPolicyExpDate = cleanStrings(
          decodedJson["Previous_Policy_Expiry_Date"],
        ),

        // CLAIM DETAILS
        claimNumber = cleanStrings(decodedJson["Claim_No"]),
        currentStatus = cleanStrings(decodedJson["Current_Status"]),
        typeOfClaim = cleanStrings(decodedJson["Type_of_Claim"]),
        pastClaimNumber = cleanStrings(decodedJson["Past_Claim_Number"]),
        previousTypeOfClaim = cleanStrings(
          decodedJson["Previous_Type_of_Claim"],
        ),
        dateOfTheft = cleanStrings(decodedJson["Date_of_Theft"]),
        dateOfLoss = cleanStrings(decodedJson["Date_of_Loss"]),
        dateOfIntimation = cleanStrings(decodedJson["Date_of_Intimation"]),
        invReferralDate = cleanStrings(decodedJson["Inv_Referral_Date"]),
        lossLocationCity = cleanStrings(decodedJson["Loss_Location_City"]),
        lossLocationState = cleanStrings(decodedJson["Loss_Location_State"]),
        locationCode = cleanOrConvert(decodedJson["Location_Code"]),

        // EXTRAS
        managerName = cleanStrings(decodedJson["Manager_Name"]),
        surveyorName = cleanStrings(decodedJson["Surveyor_Name"]),
        dateOfAllocation = cleanStrings(decodedJson["Date_of_Allocation"]),
        timeOfAllocation = cleanStrings(decodedJson["Time_of_Allocation"]),
        prevInsurerName = cleanStrings(decodedJson["Previous_Insurer_Name"]),
        reserveAmount = cleanOrConvert(decodedJson["Reserve_Amount"]),
        noClaimBonus = cleanOrConvert(decodedJson["No_Claim_Bonus"]),
        imtEndorsement = cleanOrConvert(decodedJson["IMT_Endorsement"]),
        autoManualTrigger = cleanStrings(decodedJson["Auto_Manual_Trigger"]),
        lotNo = cleanOrConvert(decodedJson["Lot_no"]),
        scheduler = cleanStrings(decodedJson["Scheduler"]),
        videoOps = cleanStrings(decodedJson["Video_Ops"]),
        videoOpsStatement = cleanStrings(decodedJson["Video_Ops_Statement"]),
        finalConclusion = cleanStrings(decodedJson["Final_Conclusion"]),
        videoMeetDate = cleanStrings(decodedJson["Video_Meet_Date"]),
        videoMeetTime = cleanStrings(decodedJson["Video_Meet_Time"]),
        tat = cleanOrConvert(decodedJson["TAT"]),
        kycStatus = cleanStrings(decodedJson["KYC_Status"]),
        kycStatusProof = cleanStrings(decodedJson["KYC_Status_Proof"]),
        faceMatch = cleanStrings(decodedJson["Face_Match"]);

  Map<String, Map<String, dynamic>> toMap() {
    return <String, Map<String, dynamic>>{
      'Customer Information': <String, dynamic>{
        'Customer name': insuredName,
        'Customer address': _createAddress(insuredCity, insuredState),
        'Phone number': insuredContactNumber,
        'Alternate phone number': insuredAltContactNumber,
        'Email address': email,
      },
      'Policy Details': <String, dynamic>{
        'Policy number': policyNumber,
        'Policy start date': policyStartDate,
        'Policy end date': policyEndDate,
        'Previous policy number': prevPolicyNumber,
        'Previous policy expiration date': prevPolicyExpDate,
      },
      'Vehicle Details': <String, dynamic>{
        'Type': productType,
        'Make': make,
        'Model': model,
        'Engine number': engineNumber,
        'Chassis number': chassisNumber,
      },
      'Claim Details': <String, dynamic>{
        'Type': typeOfClaim,
        'Current status': currentStatus,
        'Date of theft': dateOfTheft,
        'Date of loss': dateOfLoss,
        'Date of intimation': dateOfIntimation,
        'Invoice referral date': invReferralDate,
        'Loss location': _createAddress(lossLocationCity, lossLocationState),
        'Location code': locationCode
      }
    };
  }

  static String cleanStrings(String? string) {
    if (string == null || string.isEmpty) {
      return "Unavailable";
    }
    return string;
  }

  static String cleanOrConvert(Object? object) {
    if (object != null) {
      String string = object.toString();
      return cleanStrings(string);
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
}
