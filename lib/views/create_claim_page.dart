import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rc_clone/blocs/new_claim_cubit/new_claim_cubit.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/utilities/show_snackbars.dart';
import 'package:rc_clone/utilities/upload_dialog.dart';
import 'package:rc_clone/widgets/buttons.dart';
import 'package:rc_clone/widgets/input_fields.dart';

class NewClaimPage extends StatefulWidget {
  const NewClaimPage({Key? key}) : super(key: key);

  @override
  State<NewClaimPage> createState() => _NewClaimPageState();
}

class _NewClaimPageState extends State<NewClaimPage> {
  Map<String, TextEditingController>? _textEditingControllers;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New claim"),
        leading: const AppBackButton(),
        actions: <Widget>[
          BlocProvider<NewClaimCubit>(
            create: (context) => NewClaimCubit(),
            child: BlocConsumer<NewClaimCubit, NewClaimState>(
              listener: (context, state) {
                if (state is CreatingClaim) {
                  showProgressDialog(context,
                      label: "Creating", content: "Creating new claim");
                } else if (state is CreatedClaim) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showInfoSnackBar(
                      context, "Claim created.",
                      color: Colors.green);
                } else if (state is CreationFailed) {
                  Navigator.pop(context);
                  showInfoSnackBar(context, "Failed to create claim.",
                      color: Colors.red);
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      Map<String, dynamic> _data = {};
                      Claim.getLabelDataMap().forEach((key, value) {
                        _data.putIfAbsent(
                          value,
                          () => _textEditingControllers![key]?.text ?? "",
                        );
                      });
                      BlocProvider.of<NewClaimCubit>(context).createClaim(
                        claimData: _data,
                      );
                    }
                  },
                  icon: const Icon(Icons.check),
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _key,
            child: Column(
              children: _createFormFields(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createFormFields() {
    final List<String> claimFields = Claim.fields;
    final Map<String, TextEditingController> textEditingControllers = {};
    List<CustomTextFormField> textFields = <CustomTextFormField>[];
    for (var fieldTitle in claimFields) {
      if (!(fieldTitle == "Manager Name" || fieldTitle == "Surveyor Name")) {
        TextEditingController textEditingController = TextEditingController();
        textEditingControllers.putIfAbsent(
            fieldTitle, () => textEditingController);
        textFields.add(
          CustomTextFormField(
            textEditingController: textEditingController,
            label: fieldTitle,
            hintText: "Enter $fieldTitle",
            validator: fieldTitle == "Insured_Name" ||
                    fieldTitle == "Insured_Contact_Number" ||
                    fieldTitle == "Claim_No"
                ? (value) {
                    if (value!.isEmpty) {
                      return "Please enter $fieldTitle";
                    } else {
                      return null;
                    }
                  }
                : null,
          ),
        );
      }
    }
    _textEditingControllers = textEditingControllers;
    return textFields;
  }

  @override
  void dispose() {
    _textEditingControllers?.forEach((key, value) {
      _textEditingControllers![key]?.dispose();
    });
    super.dispose();
  }
}
