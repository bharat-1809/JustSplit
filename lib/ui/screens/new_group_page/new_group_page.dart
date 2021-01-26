import 'dart:math';

import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/components/friendSelector.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:contri_app/ui/components/selectAvatar_dialog.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:contri_app/ui/screens/home_page/bloc/home_bloc.dart';
import 'package:contri_app/ui/screens/home_page/home_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/groups_page/bloc/groups_bloc.dart';
import 'package:contri_app/ui/screens/new_group_page/bloc/newgroup_bloc.dart';
import 'package:contri_app/ui/screens/new_group_page/dropdown_bloc/bloc/dropdown_bloc.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';

class NewGroupPage extends StatelessWidget {
  static const String id = "new_group_page";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewgroupBloc(),
      child: NewGroupMainBody(),
    );
  }
}

class NewGroupMainBody extends StatefulWidget {
  @override
  _NewGroupMainBodyState createState() => _NewGroupMainBodyState();
}

class _NewGroupMainBodyState extends State<NewGroupMainBody> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownKey = GlobalKey<FriendSelectorDropdownState>();
  final _nameController = TextEditingController();
  final _photoUrlController = TextEditingController(
    text: userAvatars[Random().nextInt(userAvatars.length)],
  );

  @override
  void initState() {
    _photoUrlController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                DropdownBloc()..add(FriendDropdownRequested())),
        BlocProvider(create: (context) => GroupsBloc()),
        BlocProvider(create: (context) => HomeBloc()),
      ],
      child: AlertDialog(
        semanticLabel: "Create a new group",
        contentPadding: EdgeInsets.zero,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CANCEL"),
          ),
          FlatButton(
            onPressed: () {
              if (!_formKey.currentState.validate()) return;
              final _list = _dropdownKey.currentState.result;
              if (_list.length < 2) {
                BlocProvider.of<NewgroupBloc>(context)
                    .add(ErrorSelectingFriend());
                return;
              }
              BlocProvider.of<NewgroupBloc>(context).add(
                CreateGroupButtonClicked(
                  groupName: _nameController.text,
                  members: _list,
                  pictureUrl: _photoUrlController.text,
                ),
              );
            },
            child: Text("CREATE GROUP"),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
        title: Text(
          "Add New Group",
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: screenHeight * 0.030249047, //38
              ),
        ),
        scrollable: true,
        content: Container(
          height: screenHeight * 0.60,
          width: screenWidth * 0.8,
          child: Scaffold(
            backgroundColor: Theme.of(context).cardColor,
            body: Builder(
              builder: (context) => Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
                child: BlocConsumer<NewgroupBloc, NewgroupState>(
                  listener: (context, state) {
                    if (state is NewGroupFailure) {
                      context.showSnackBar(state.message);
                    } else if (state is NewGroupLoading) {
                      showProgress(context);
                    } else if (state is NewGroupSuccess) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context).pushReplacementNamed(
                        HomePage.id,
                        arguments: ScreenArguments(homeIndex: 1),
                      );
                    }
                  },
                  builder: (context, state) {
                    return GroupForm(
                      dropDownKey: _dropdownKey,
                      formKey: _formKey,
                      photoUrlController: _photoUrlController,
                      nameController: _nameController,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // ),
    // );
  }
}

class GroupForm extends StatelessWidget {
  final TextEditingController nameController;
  final GlobalKey<FormState> formKey;
  final GlobalKey<FriendSelectorDropdownState> dropDownKey;
  final TextEditingController photoUrlController;

  GroupForm(
      {@required this.formKey,
      @required this.dropDownKey,
      @required this.photoUrlController,
      @required this.nameController});

  final _validator = Validator();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.025,
      ),
      child: Form(
        key: formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark.withOpacity(0.7),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).primaryColorDark.withOpacity(0.20),
                      offset: Offset(3.0, 3.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                  ]),
              child: GestureDetector(
                onTap: () {
                  Feedback.forTap(context);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        AvatarPicker(pictureUrlController: photoUrlController),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/icons/misc/loader.png'),
                    image: FirebaseImage(photoUrlController.text),
                  ),
                  radius: screenHeight * 0.050702668,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.052249047), // 38
            CustomTextFormField(
              textInputAction: TextInputAction.done,
              maxLines: 1,
              fieldController: nameController,
              hintText: 'Group Name',
              prefixImage: 'assets/icons/auth_icons/firstName.svg',
              keyboardType: TextInputType.text,
              validator: _validator.validateName,
            ),
            SizedBox(height: screenHeight * 0.064459975),
            BlocConsumer<DropdownBloc, DropdownState>(
              listener: (context, state) {},
              builder: (context, state) {
                return FriendSelector(
                  key: dropDownKey,
                  label: "Select Friends",
                  elements: state.widgetList
                      .map<FriendSelectorItem>(
                        (item) => FriendSelectorItem.custom(
                          value: item.id,
                          child: item,
                        ),
                      )
                      .toList(),
                  values: [],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
