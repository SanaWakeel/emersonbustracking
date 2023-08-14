import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/colors.dart';
import '../res/components/round_button.dart';
import '../utils/utils.dart';
import '../viewModel/auth_view_model.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/bus_route_model.dart';

class FirebaseView extends StatefulWidget {
  const FirebaseView({Key? key}) : super(key: key);

  @override
  State<FirebaseView> createState() => _FirebaseViewState();
}

class _FirebaseViewState extends State<FirebaseView> {
  bool loading = false;

  final databaseRef = FirebaseDatabase.instance.ref('BusRoutes');

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _routeNumberController = TextEditingController();
  final TextEditingController _sourceLocationNameController =
      TextEditingController();
  final TextEditingController _sourceLocationLatitudeController =
      TextEditingController();
  final TextEditingController _sourceLocationLongitudeController =
      TextEditingController();
  final TextEditingController _destinationLocationNameController =
      TextEditingController();
  final TextEditingController _destinationLocationLatitudeController =
      TextEditingController();
  final TextEditingController _destinationLocationLongitudeController =
      TextEditingController();

  // ValueNotifier<bool> obsurePassword = ValueNotifier<bool>(true);

  FocusNode routeNumberFocusNode = FocusNode();
  FocusNode sourceLocationNameFocusNode = FocusNode();
  FocusNode sourceLocationLatitudeFocusNode = FocusNode();
  FocusNode sourceLocationLongitudeFocusNode = FocusNode();
  FocusNode destinationLocationNameFocusNode = FocusNode();
  FocusNode destinationLocationLatitudeFocusNode = FocusNode();
  FocusNode destinationLocationLongitudeFocusNode = FocusNode();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _routeNumberController.dispose();
    _sourceLocationNameController.dispose();
    _sourceLocationLatitudeController.dispose();
    _sourceLocationLongitudeController.dispose();
    _destinationLocationNameController.dispose();
    _destinationLocationLatitudeController.dispose();
    _destinationLocationLongitudeController.dispose();
    routeNumberFocusNode.dispose();
    sourceLocationNameFocusNode.dispose();
    sourceLocationLatitudeFocusNode.dispose();
    sourceLocationLongitudeFocusNode.dispose();
    destinationLocationNameFocusNode.dispose();
    destinationLocationLatitudeFocusNode.dispose();
    destinationLocationLongitudeFocusNode.dispose();
    // obsurePassword.dispose();
  }

  void addBusRoute() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //     .then((value) {
    //
    //
    //   // Utils.toastMessage(value.user!.email.toString());
    // }).onError((error, stackTrace) {
    //   Utils.toastMessage("Error : $error");
    //   Navigator.of(context).pop();
    // });
    String? nodeKey = databaseRef.push().key;
    BusRouteModel busRouteModel = BusRouteModel(
      id: nodeKey,
      busRouteNumber: int.parse(_routeNumberController.text),
      sourceLocationName: _sourceLocationNameController.text,
      sourceLocationLatitude:
          double.parse(_sourceLocationLatitudeController.text),
      sourceLocationLongitude:
          double.parse(_sourceLocationLongitudeController.text),
      destinationLocationName: _destinationLocationNameController.text,
      destinationLocationLatitude:
          double.parse(_destinationLocationLatitudeController.text),
      destinationLocationLongitude:
          double.parse(_destinationLocationLongitudeController.text),
      timeStamp: DateTime.now().millisecondsSinceEpoch,
    );

    databaseRef.child(nodeKey!).set(busRouteModel.toJson()).then((value) {
      Utils.toastMessage("Successfully Added", AppColors.successToast);
      Navigator.of(context).pop();
    }).onError((error, stackTrace) =>
        Utils.toastMessage(error.toString(), AppColors.errorToast));
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              "Create Bus Route",
            ),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: Main
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _routeNumberController,
                      focusNode: routeNumberFocusNode,
                      decoration: const InputDecoration(
                        hintText: "Bus Root No",
                        label: Text("Bus Root No"),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(context, routeNumberFocusNode,
                            sourceLocationNameFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Bus Root No";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _sourceLocationNameController,
                      focusNode: sourceLocationNameFocusNode,
                      decoration: const InputDecoration(
                        hintText: "source location Name",
                        label: Text("Source location Name"),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(
                            context,
                            sourceLocationNameFocusNode,
                            sourceLocationLatitudeFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter source Location Name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _sourceLocationLatitudeController,
                      focusNode: sourceLocationLatitudeFocusNode,
                      decoration: const InputDecoration(
                        hintText: "source location Latitude",
                        label: Text("source location Latitude"),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(
                            context,
                            sourceLocationLatitudeFocusNode,
                            sourceLocationLongitudeFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter source location latitude";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _sourceLocationLongitudeController,
                      focusNode: sourceLocationLongitudeFocusNode,
                      decoration: const InputDecoration(
                        hintText: "source location Longitude",
                        label: Text("source location Longitude"),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(
                            context,
                            sourceLocationLongitudeFocusNode,
                            destinationLocationNameFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter source location longitude";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _destinationLocationNameController,
                      focusNode: destinationLocationNameFocusNode,
                      decoration: const InputDecoration(
                        hintText: "destination location Name",
                        label: Text("destination location Name"),
                        //prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(
                            context,
                            destinationLocationNameFocusNode,
                            destinationLocationLatitudeFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter destination Location Name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _destinationLocationLatitudeController,
                      focusNode: destinationLocationLatitudeFocusNode,
                      decoration: const InputDecoration(
                        hintText: "destination location Latitude",
                        label: Text("destination location Latitude"),
                        //prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(
                            context,
                            destinationLocationLatitudeFocusNode,
                            destinationLocationLongitudeFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter destination location latitude";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _destinationLocationLongitudeController,
                      focusNode: destinationLocationLongitudeFocusNode,
                      decoration: const InputDecoration(
                        hintText: "destination location Longitude",
                        label: Text("destination location Longitude"),
                        //prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        destinationLocationLongitudeFocusNode.unfocus();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter destination location longitude";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    RoundButton(
                        loading: AuthViewModel.isloading,
                        title: "Add Bus Route",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            // Utils.flushBarErrorMessage(
                            //     "Successfully log in", context);
                            addBusRoute();
                          }

                          // if (_emailController.text.isEmpty) {
                          //   Utils.flushBarErrorMessage(
                          //       "Please Enter Email", context);
                          // } else if (_passwordController.text.isEmpty) {
                          //   Utils.flushBarErrorMessage(
                          //       "Please Enter Password", context);
                          // } else if (_passwordController.text.length < 8) {
                          //   Utils.flushBarErrorMessage(
                          //       "Please Enter 8 digit password", context);
                          // } else {
                          //   Map data = {
                          //     "email": _emailController.text.toString(),
                          //     "password": _passwordController.text.toString(),
                          //     // "email": "eve.holt@reqres.in",
                          //     // "password": "cityslicka",
                          //   };
                          // authViewModel.loginApi(data, context);
                        }),
                    // CircleAvatar(
                    //   child: Image.asset('lib/res/images/bus_circle.png'),
                    //   backgroundColor: AppColors.white,
                    //   maxRadius: 80,
                    // ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
