import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
class MultiContactPage extends StatefulWidget {
  static const String id = "MultiSelect_contacts";
  MultiContactPage({Key key, this.title}) : super(key: key);

  final String title;
  // declared strings for the widget
  final String fireLabel = 'Done';
  final Color floatingButtonColor = Colors.red;
  final IconData reloadIcon = Icons.refresh;
  final IconData fireIcon = Icons.filter_center_focus;

  //override widget
  @override
  _MultiContactPageState createState() => new _MultiContactPageState(
    floatingButtonLabel: this.fireLabel,
    icon: this.fireIcon,
    floatingButtonColor: this.floatingButtonColor,
  );
}

class _MultiContactPageState extends State<MultiContactPage> {
  //  List Used to store the populated contacts
  List<Contact> _contacts = new List<Contact>();
  //List for storing contacts of custom types i.e with isChecked and Emails
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  List<CustomContact> _EmailListCustomContact= List<CustomContact>();
  List<CustomContact> _allContacts = List<CustomContact>();
  bool isNameDisplayed  = true;
  bool _isLoading = false;
  bool _isSelectedContactsView = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  String email;
  IconData icon;
  // cons
  _MultiContactPageState({
    this.floatingButtonLabel,
    this.icon,
    this.floatingButtonColor,
  });

  // Getting permission by calling getPermissions method when the  initailized.
  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Contact Multi Select"),
      ),
      // if body is not loading display container widget or show loading circular progress
      body: !_isLoading
          ? Container(
        // display the list only when the length of the list is greater than 0
        child: _uiCustomContacts?.length >0 ?  ListView.builder(
          itemCount: isNameDisplayed?_uiCustomContacts?.length:_EmailListCustomContact?.length ,
          itemBuilder: (BuildContext context, int index) {

            if(isNameDisplayed){
              CustomContact _contact = _uiCustomContacts[index];
              var _phonesList = _contact.contact.phones.toList();

              return _buildListTile(_contact, _phonesList,isNameDisplayed);
            }else{
              CustomContact _contact = _EmailListCustomContact[index];
              var _phonesList = _contact.contact.phones.toList();

              return _buildListTile(_contact, _phonesList,isNameDisplayed);
            }

          },
        //  Or display text notifying users to select a contact
        ): Text("Please Check a Contact",style: TextStyle(fontSize: 20.0) ,),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
         floatingActionButton: isNameDisplayed ? FloatingActionButton.extended(

        backgroundColor: floatingButtonColor,
        onPressed: _onSubmit,
        icon: Icon(icon),
        label: Text(floatingButtonLabel),
      ):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // onSubmit method is triggered when button is clicked
  void _onSubmit() {
    setState(() {
      isNameDisplayed = false;
      if (!_isSelectedContactsView) {
        var   _CustomContacts = _allContacts.where((contact) => contact.isChecked == true ).toList();
        List<String>  emailList = new List<String>();
        for(int i = 0 ;i<_CustomContacts.length;i++ ){
          var tempContact ;

          _CustomContacts[i].contact.emails.forEach((item) => {

          tempContact = new CustomContact(contact: _CustomContacts[i].contact, email: "", isChecked: true),
              tempContact.email = item.value,
            _EmailListCustomContact.add(tempContact),
            emailList.add(item.value),
          });
        }
        print(emailList);
       for(int i=0; i< _EmailListCustomContact.length;i++){
         print(_EmailListCustomContact[i].email);
       }
        _uiCustomContacts = _CustomContacts;
        _isSelectedContactsView = true;

      } else {
        // here only is the error it should be _CustomContacts instead of _allContacts
        _uiCustomContacts = _allContacts;
        _isSelectedContactsView = true;
        _restateFloatingButton(
          widget.fireLabel,
          Icons.filter_center_focus,
          Colors.red,
        );
      }
    });
  }
  // Build custom list tile with Contact name with display name
  ListTile _buildListTile(CustomContact c, List<Item> list,bool isNameDisplayed) {
    return ListTile(
      leading: (c.contact.avatar != null)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          : CircleAvatar(
        child: Text(
            (c.contact.displayName[0] +
                c.contact.displayName[1].toUpperCase()),
            style: TextStyle(color: Colors.white)),
      ),
      title: Text(isNameDisplayed ? (c.contact.displayName ?? ""):c.email),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Column(children: [
            Row(
             children: [
               Text(list[0].value),
             ],
            ),
            Row(
              children: [
                Text(c.contact.emails.first.value),
              ],
            ),


      ],)
          : Text(c.contact.emails.first.value),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;

            });

          }),
    );
  }
  // method to state floating action button useful for button triggers
  void _restateFloatingButton(String label, IconData icon, Color color) {
    floatingButtonLabel = label;
    icon = icon;
    floatingButtonColor = color;
  }

  // method to refresh the contacts
  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  // Getting all the device contacts using Flutter Contact Services and populate it to list
  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null && item.emails.length >0).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }

  //Getting Permission for android and ios using Permission Handler
  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      refreshContacts();
    }else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text('Looks like permission to read contacts is not granted.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }
// Future<bool> getContactsPermission() =>
//     SimplePermissions.requestPermission(Permission.ReadContacts);
}

//Custom Class with constructor for Custom type widgets
class CustomContact {
  final Contact contact;
  bool isChecked;
  String email;
  CustomContact({
    this.contact,
    this.email,
    this.isChecked = false,
  });
}
