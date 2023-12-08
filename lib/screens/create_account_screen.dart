import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/layout/layout_screen.dart';
import 'package:premium_fivver_note_app/models/user_model.dart';
import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/states.dart';
import 'package:premium_fivver_note_app/shared/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/constants.dart';
import '../style/colors.dart';
import 'background_image.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController birthdayController = TextEditingController();
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
            sigma: 8,
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          ///text
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Let\'s get to know you \nEnter your details to continue',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          ///image
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25),
                                child: InkWell(
                                  onTap: () {
                                    cubit.getImageFromGallery();
                                  },
                                  child: CircleAvatar(
                                    radius: 110,
                                    backgroundColor: secondColor,
                                    child: CircleAvatar(
                                      radius: 100,
                                      backgroundImage: profileImage == null
                                          ? const AssetImage(
                                              'assets/images/harry_potter.webp',)
                                          : FileImage(profileImage)
                                              as ImageProvider,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: CircleAvatar(
                                  radius: 25,
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

                          ///name
                          defTextField(
                            controller: nameController,
                            icon: Icons.person_outline,
                            text: 'your name',
                          ),

                          ///birthday
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
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

                          defTextButton(
                            text: 'START',
                            onTap: () {
                              if (profileImage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please choose any photo',
                                    ),
                                  ),
                                );
                              } else if (formKey.currentState!.validate()) {
                                Shared.saveDate(
                                  key: login,
                                  value: true,
                                )?.then(
                                  (value) {
                                    UserInfo model = UserInfo(
                                        name: nameController.text,
                                        birthday:
                                        birthdayController.text,
                                        profileImage:
                                        profileImage.path);
                                    cubit.saveDate(model);
                                    
                                    navigateAndFinish(
                                      context,
                                      const LayoutScreen(),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
