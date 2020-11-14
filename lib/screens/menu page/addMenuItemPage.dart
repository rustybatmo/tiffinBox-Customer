import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/item.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddMenuItem extends StatefulWidget {
  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

enum TypeOfDish { veg, nonveg, none }
final TextEditingController _nameController = TextEditingController();
final TextEditingController _priceController = TextEditingController();
final TextEditingController _typeOfDishController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
// int selectedRadio;

class _AddMenuItemState extends State<AddMenuItem> {
  TypeOfDish character;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TypeOfDish character = TypeOfDish.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Menu Item'),
      ),
      body: _buildContext(context),
    );
  }

  Widget _buildContext(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name of the menu item',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid menu item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                    hintText: 'Price', labelText: 'Price of the menu item'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a proper price';
                  }
                  return null;
                },
              ),
              Column(
                children: [
                  ListTile(
                    title: const Text('Veg'),
                    leading: Radio(
                      value: TypeOfDish.veg,
                      groupValue: character,
                      onChanged: (value) {
                        setState(() {
                          character = value;
                          _typeOfDishController.text = 'veg';
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Nonveg'),
                    leading: Radio(
                      value: TypeOfDish.nonveg,
                      groupValue: character,
                      onChanged: (value) {
                        setState(() {
                          character = value;
                          _typeOfDishController.text = 'nonveg';
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'description',
                  labelText: 'Description of the menu item',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a proper price';
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: () => _addMenuItem(context),
                child: Text('Add new item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMenuItem(BuildContext context) {
    final database = Provider.of<Database>(context);
    var uuid = Uuid();
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        character != TypeOfDish.none) {
      print('Everything looks alright');

      Map item = Item.toMap(
        _nameController.text,
        _descriptionController.text,
        _priceController.text,
        _typeOfDishController.text,
        uuid.v1(),
      );

      database.addItem(item);
      Navigator.pop(context);
    } else {
      print('something is off');
    }
  }
}
