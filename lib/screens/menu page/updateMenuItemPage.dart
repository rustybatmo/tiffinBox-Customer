import 'package:flutter/material.dart';
import 'package:phnauthnew/modals/item.dart';
import 'package:phnauthnew/screens/services/databaseService.dart';
import 'package:provider/provider.dart';

class UpdateMenuItem extends StatefulWidget {
  UpdateMenuItem({@required this.item, @required this.id});
  final Item item;
  final String id;
  @override
  _UpdateMenuItemState createState() => _UpdateMenuItemState();
}

enum TypeOfDish { veg, nonveg, none }
final TextEditingController _nameController = TextEditingController();
final TextEditingController _priceController = TextEditingController();
final TextEditingController _typeOfDishController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
// int selectedRadio;

class _UpdateMenuItemState extends State<UpdateMenuItem> {
  TypeOfDish character;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TypeOfDish character = TypeOfDish.none;
    _nameController.text = widget.item.itemName;
    _priceController.text = widget.item.pricePerServing;
    _typeOfDishController.text = widget.item.typeOfDish;
    _descriptionController.text = widget.item.dishDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Menu Item'),
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
                // initialValue: '${widget.item.itemName}',
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '${widget.item.itemName}',
                  labelText: 'Enter Name',
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
                onPressed: () => _updateMenuItem(context),
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateMenuItem(BuildContext context) {
    final database = Provider.of<Database>(context);
    // var uuid = Uuid();
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        character != TypeOfDish.none) {
      print('Everything looks alright');

      Map item = Item.toMap(
        _nameController.text,
        _descriptionController.text,
        _priceController.text,
        _typeOfDishController.text,
        widget.id,
      );

      database.updateItem(item, widget.id);
      Navigator.pop(context);
    } else {
      print('something is off');
    }
  }
}
