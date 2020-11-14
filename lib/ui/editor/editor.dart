import 'package:basic_utils/basic_utils.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:web/models/article.dart';
import 'package:web/ui/editor/select_image.dart';
import 'package:web/ui/editor/select_link.dart';
import 'package:web/ui/editor/submit_dialog.dart';
import 'package:web/widgets/textfields.dart';
import 'package:web/widgets/texts.dart';

class Editor extends StatefulWidget {
  final Article article;

  const Editor({this.article});

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  TextEditingController dataController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  FocusNode dataFocus = FocusNode();
  FocusNode titleFocus = FocusNode();
  FocusNode fileNameFocus = FocusNode();
  FocusNode tagsFocus = FocusNode();

  ScrollController mdScrollController = ScrollController();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();

    if (widget.article != null) {
      titleController = TextEditingController(text: widget.article.title);

      String tags = '';
      widget.article.tags.forEach((tag) {
        tags += tag + ', ';
      });

      tagsController = TextEditingController(text: tags);

      dataController = TextEditingController(text: widget.article.content);

      fileNameController = TextEditingController(text: widget.article.fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    print(width);

    return Scaffold(
      body: ListView(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Texts.headline3(
                  (widget.article != null) ? 'Edit' : 'Create', Colors.white),
            ),
          ),
          Wrap(
            children: [
              Container(
                width: (width >= 500) ? width / 2 : width,
                height: height - 57,

                // color: Colors.red,
                child: Column(
                  children: [
                    TextFields.defaultTextField(
                        controller: titleController,
                        focusNode: titleFocus,
                        labelText: 'Title',
                        onSubmitted: (value) {
                          _fieldFocusChange(context, titleFocus, tagsFocus);
                        },
                        enabled: true,
                        onChanged: (value) {
                          if (widget.article == null) {
                            setState(() {
                              fileNameController.text = titleController.text
                                  .replaceAll(' ', '-')
                                  .toLowerCase();
                            });
                          }
                        },
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: 20,
                        )),
                    TextFields.defaultTextField(
                      controller: tagsController,
                      focusNode: tagsFocus,
                      labelText: 'Tags',
                      onSubmitted: (value) {
                        _fieldFocusChange(context, tagsFocus, dataFocus);
                      },
                      enabled: true,
                      hintText: 'separated by \",\"',
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.format_bold,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '****',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 2));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.format_italic,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '**',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 1));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.strikethrough_s,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '~~~~',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 2));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.text_fields,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '# ',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 2));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.text_fields,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '## ',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 3));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.text_fields,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '### ',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 4));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.text_fields,
                                color: Colors.white,
                                size: 12,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '#### ',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 5));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.code,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '```\n\n```',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 4));

                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.link,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                showDialog(
                                        context: context,
                                        builder: (context) => SelectLink())
                                    .then((value) {
                                  if (value != null) {
                                    dataController.text =
                                        StringUtils.addCharAtPosition(
                                            dataController.text,
                                            value + '\n',
                                            cursorPosition);

                                    dataController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: cursorPosition +
                                                value.length +
                                                1));

                                    setState(() {});
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                showDialog(
                                        context: context,
                                        builder: (context) => SelectImage())
                                    .then((value) {
                                  if (value != null) {
                                    dataController.text =
                                        StringUtils.addCharAtPosition(
                                            dataController.text,
                                            value + '\n\n',
                                            cursorPosition);

                                    dataController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: cursorPosition +
                                                value.length +
                                                2));

                                    setState(() {});
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '\n---\n',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 5));

                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.format_list_numbered,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '1. ',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 3));

                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 8,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '- ',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 2));

                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.check_box,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '[x] ',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 4));

                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.check_box_outline_blank,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                int cursorPosition =
                                    dataController.selection.baseOffset;

                                dataController.text =
                                    StringUtils.addCharAtPosition(
                                        dataController.text,
                                        '[ ] ',
                                        cursorPosition);

                                dataController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: cursorPosition + 4));

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextFields.expandedTextField(
                      controller: dataController,
                      focusNode: dataFocus,
                      onSubmitted: (value) {},
                      hintText: 'Enter your article here',
                      onChanged: (value) {
                        setState(() {});
                      },
                      enabled: true,
                      margin: EdgeInsets.only(
                        left: 20,

                        right: 20,
                        bottom: 10,
                        //  top: 10
                      ),
                    ),
                    (widget.article == null)
                        ? TextFields.defaultTextField(
                            controller: fileNameController,
                            focusNode: fileNameFocus,
                            labelText: 'Url',
                            onSubmitted: (value) {},
                            enabled: true,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              Container(
                width: (width >= 500) ? width / 2 : width,
                height: height - 57,
                child: DraggableScrollbar.rrect(
                  alwaysVisibleScrollThumb: true,
                  controller: mdScrollController,
                  child: ListView(
                    shrinkWrap: true,
                    controller: mdScrollController,
                    children: [
                      MarkdownWidget(
                        // controller: ,
                        data: dataController.text,
                        padding: EdgeInsets.all(20),
                        loadingWidget: Center(
                          child: SizedBox(),
                        ),
                        shrinkWrap: true,
                        styleConfig: StyleConfig(
                          markdownTheme: MarkdownTheme.darkTheme,
                          titleConfig: TitleConfig(
                            showDivider: false,
                          ),
                        ),


                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.save_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          if (dataController.text.isNotEmpty &&
              titleController.text.isNotEmpty &&
              fileNameController.text.isNotEmpty) {
            List<String> tags = tagsController.text.split(',');
            tags = tags
                .where((element) => element.length != 0)
                .map((tag) {
                  while (tag[0] == ' ') {
                    tag = tag.substring(1);
                    if (tag.length == 0) {
                      break;
                    }
                  }
                  if (tag.isNotEmpty) {
                    while (tag[tag.length - 1] == ' ') {
                      tag = tag.substring(0, tag.length - 1);
                    }
                  }
                  return tag;
                })
                .where((tag) => tag.length != 0)
                .toList();

            String date;
            if (widget.article == null) {
              DateTime dateTime = DateTime.now();

              String month = (dateTime.month.toString().length == 1)
                  ? '0' + dateTime.month.toString()
                  : dateTime.month.toString();

              String day = (dateTime.day.toString().length == 1)
                  ? '0' + dateTime.day.toString()
                  : dateTime.day.toString();

              date = dateTime.year.toString() + '-' + month + '-' + day;
            } else {
              date = widget.article.date;
            }

            String content =
                '+++\ntitle = \"${titleController.text}\"\ntags = ${tags.map((tag) => '\"$tag\"').toList().toString()}\ndate = \"$date\"\n+++\n';
            content = content + dataController.text;

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SubmitDialog.create(context,
                  content: content, filePath: fileNameController.text),
            ).then((value) {
              if (value != null) {
                Navigator.pop(context, value);
              }
            });
          } else {}
        },
      ),
    );
  }
}
