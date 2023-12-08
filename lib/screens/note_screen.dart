import 'dart:io';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/models/category_model.dart';
import 'package:premium_fivver_note_app/screens/view_image_screen.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../layout/layout_screen.dart';
import '../models/note_model.dart';
import '../style/colors.dart';
import 'background_image.dart';

class NoteScreen extends StatelessWidget {
  final Note note;

  final titleController = TextEditingController();
  final noteController = TextEditingController();


  final List<CategoryModel> categories = [
    CategoryModel(
        image: 'assets/images/harry_potter.webp', name: 'Harry Potter'),
    CategoryModel(
        image: 'assets/images/characters/albus_dumbledore.jpg',
        name: 'Albus Dumbledore'),
    CategoryModel(
        image: 'assets/images/characters/ginny_weasley.jfif',
        name: 'Ginny Weasley'),
    CategoryModel(
        image: 'assets/images/characters/hermione_granger.jpg',
        name: 'Hermione Granger'),
    CategoryModel(
        image: 'assets/images/characters/lord_voldemort.jpg',
        name: 'Lord Voldemort'),
    CategoryModel(
        image: 'assets/images/characters/neville_longbottom.jpg',
        name: 'Neville Longbottom'),
    CategoryModel(
        image: 'assets/images/characters/ron_weasley.jpg', name: 'Ron Weasley'),
    CategoryModel(
        image: 'assets/images/characters/rubeus_hagrid.jpg',
        name: 'Rubeus Hagrid'),
    CategoryModel(
        image: 'assets/images/characters/severus_snape.jpg',
        name: 'Severus Snape'),
    CategoryModel(
        image: 'assets/images/characters/sirius_black.jfif',
        name: 'Sirius Black'),
  ];

  NoteScreen(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    String images = note.images;
    final paths = images.split(',');
    AddNoteCubit.get(context).imageFiles =
        paths.map((path) => File(path.trim())).toList();
    titleController.text = note.title;
    noteController.text = note.note;
    if (images == 'null') {
      AddNoteCubit.get(context).removeImages();
    }

    return BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);

        return WillPopScope(
          onWillPop: () async {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: secondColor,
                  contentPadding: const EdgeInsetsDirectional.all(50),
                  content: Text(
                    'Do you want to save this edit'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('edit note success'),
                          ),
                        );
                        cubit
                            .updateNote(
                          title: titleController.text,
                          id: note.id,
                          time: DateFormat.jm().format(DateTime.now()),
                          date: DateFormat.yMMMMd().format(DateTime.now()),
                          note: noteController.text,
                        )
                            .then((value) {
                          cubit.removeImages();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'save'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        cubit.removeImages();
                        navigateTo(context, const LayoutScreen());
                      },
                      child: Text(
                        'cancel'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            return true;
          },
          child: Scaffold(
            body: BackgroundImage(
              sigma: 25,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20, left: 10),
                child: SafeArea(
                  child: Column(
                    children: [
                      ///appBar
                      Row(
                        children: [
                          defIconButton(
                            icon: Icons.arrow_back_ios,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Spacer(),
                          defIconButton(
                            icon: Icons.save_outlined,
                            onTap: () {
                              cubit
                                  .updateNote(
                                title: titleController.text,
                                id: note.id,
                                time: DateFormat.jm().format(DateTime.now()),
                                date:
                                    DateFormat.yMMMMd().format(DateTime.now()),
                                note: noteController.text,
                              )
                                  .then((value) {
                                Navigator.pop(context);
                                cubit.removeImages();
                              });
                            },
                          ),
                          defIconButton(
                            icon: Icons.add,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: defColor,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsetsDirectional.all(10),
                                        padding: const EdgeInsetsDirectional.all(15),
                                        decoration: BoxDecoration(
                                          color: secondColor,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text('Add to category'.toUpperCase(),style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              categoryItem(categories[index],context),
                                          itemCount: categories.length,
                                          physics: const BouncingScrollPhysics(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          defIconButton(
                            icon: Icons.photo_library_outlined,
                            onTap: () {
                              cubit.selectImages();
                            },
                          )
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 15),
                          child: Column(
                            children: [
                              /// title
                              TextFormField(
                                minLines: 1,
                                maxLines: 2,
                                controller: titleController,
                                style: const TextStyle(
                                  fontSize: 24,
                                  wordSpacing: 5,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title',
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              /// note
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  minLines: 1,
                                  maxLines: 1000,
                                  controller: noteController,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    wordSpacing: 5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'Type Something if you want ot edit ...',
                                  ),
                                ),
                              ),

                              /// images
                              if (cubit.imageFiles.isNotEmpty)
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 5),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: cubit.imageFiles.length,
                                        itemBuilder: (context, index) {
                                          if (cubit.imageFiles.isNotEmpty) {
                                            final file =
                                                cubit.imageFiles[index];
                                            return InkWell(
                                              onTap: () {
                                                navigateTo(
                                                  context,
                                                  FullScreenImage(
                                                      imagePath: file.path),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Image.file(file),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8.0,
                                                    ),
                                                    child: defIconButton(
                                                      height: 40,
                                                      icon:
                                                          Icons.delete_outline,
                                                      onTap: () =>
                                                          cubit.removeImage(
                                                        file,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget categoryItem(CategoryModel model,context) => InkWell(
    onTap: (){
      AddNoteCubit.get(context).updateCategory(category: model.name, id: note.id).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             behavior: SnackBarBehavior.floating,
            content: Text('Add note to ${model.name} category success'),
             duration: const Duration(seconds: 10),
          ),
        );
      });
      Navigator.pop(context);

    },
    child: Container(
      margin: const EdgeInsetsDirectional.all(10),
      padding: const EdgeInsetsDirectional.all(15),
       decoration: BoxDecoration(
         color: secondColor,
         borderRadius: BorderRadius.circular(20),
       ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(model.image,),
              ),
              const Spacer(),
              Text(model.name.toUpperCase(),style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              ),
            ],
          ),
        ),
  );
}
