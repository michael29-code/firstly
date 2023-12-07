
import 'package:firstly/services/todo_service.dart';
import 'package:firstly/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';

class addTodoPage extends StatefulWidget {
  final Map? todo;
  const addTodoPage({super.key, this.todo});

  @override
  State<addTodoPage> createState() => _addTodoPageState();
}

class _addTodoPageState extends State<addTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit? 'Edit Todo' :'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(
            height: 20,
          ),

          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8, 
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: isEdit ? updateData : submitData, child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(isEdit ? 'Update':'Submit'),
          ))
        ],
      ),
    );
  }

  Future<void> updateData() async {

    final todo = widget.todo;

    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }

    final id = todo['_id'];
    // get the data form

      // submit updated data to the server
    final isSucces = await TodoService.updateTodo(id, body);

    if (isSucces) {
      showSuccessMessage(context, message: 'Updation Success');
    } else {
      showErrorMessage(context, message: 'Updation Error');
    }
  }

  Future<void> submitData() async {

    // submit data to the server
    final isSuccess = await TodoService.addTodo(body);
    // show succes or fail message based on status

    if(isSuccess){
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Creation Success');
    }else{
      showErrorMessage(context, message: 'Creation Error');
    }
    // print(response.statusCode);
  }

  Map get body{
    // get the data form

    final title = titleController.text;
    final description = descriptionController.text;

    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}