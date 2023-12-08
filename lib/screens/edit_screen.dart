import 'dart:io';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../style/colors.dart';
import 'background_image.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var birthdayController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        NotesCubit cubit = NotesCubit.get(context);
        var profileImage = cubit.profileImage;
        String month = cubit.date.month.toString();
        String day = cubit.date.day.toString();
        if (cubit.date.month < 10) {
          month = '0${cubit.date.month}';
        }
        if (cubit.date.day < 10) {
          day = '0${cubit.date.day}';
        }

        if (cubit.putDate) {
          birthdayController.text = "${cubit.date.year.toString()}-$month-$day";
        }
        return Scaffold(
          body: BackgroundImage(
              child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    /// APPBAR
                    defAppBar(context: context, screenName: 'edit profile'),

                    /// body
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              /// image
                              Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: InkWell(
                                      onTap: () {
                                        cubit.getImageFromGallery();
                                      },
                                      child: CircleAvatar(
                                        radius: 110,
                                        backgroundColor: secondColor,
                                        child: CircleAvatar(
                                          backgroundImage: profileImage == null
                                              ? FileImage(
                                                  File(
                                                    cubit.model.profileImage,
                                                  ),
                                                )
                                              : FileImage(profileImage),
                                          radius: 100,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: CircleAvatar(
                                      radius: 23,
                                      backgroundColor: secondColor,
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.getImageFromGallery();
                                        },
                                        icon: const Icon(
                                          Icons.photo,
                                          size: 30,
                                          color: defColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              ///   NAME
                                Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  cubit.model.name.toUpperCase(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: secondColor,
                                  ),
                                ),
                              ),

                              /// birthday
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  cubit.model.birthday.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: secondColor,
                                  ),
                                ),
                              ),

                              /// name edit
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: defTextField(
                                  controller: nameController,
                                  icon:
                                      Icons.drive_file_rename_outline_outlined,
                                  text: 'Enter a new name',
                                ),
                              ),

                              /// birthday edit
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: defTextField(
                                  hideKeyboard: true,
                                  onTap: () {
                                    cubit.showTheDate(context: context);
                                  },
                                  fontSize: 20,
                                  controller: birthdayController,
                                  icon: Icons.cake_outlined,
                                  text: 'your birthday',
                                ),
                              ),

                              /// items
                              InkWell(
                                onTap: () {
                                  if(formKey.currentState!.validate()) {
                                    cubit.updateData(
                                    nameController.text,
                                    birthdayController.text,
                                    profileImage?.path ??
                                        cubit.model.profileImage,
                                  );
                                    nameController.clear();
                                    birthdayController.clear();
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 230,
                                  padding: const EdgeInsetsDirectional.all(10),
                                  margin: const EdgeInsetsDirectional.symmetric(
                                      vertical: 15,),
                                  decoration:
                                      const BoxDecoration(color: defColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      const Icon(
                                        Icons.cake_outlined,
                                        color: secondColor,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'update Date'.toUpperCase(),
                                        style: const TextStyle(
                                          color: secondColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
        );
      },
    );
  }
}
