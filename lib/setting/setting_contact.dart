import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_here/model.dart';
import 'package:not_here/utils/launcher.dart';
import 'package:provider/provider.dart';

class ContactSetting extends StatefulWidget {
  const ContactSetting({Key? key}) : super(key: key);

  @override
  _ContactSettingState createState() => _ContactSettingState();
}

class _ContactSettingState extends State<ContactSetting>
    with WidgetsBindingObserver {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  var _prevBottomInset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    if (bottomInset == 0 && _prevBottomInset > 0) {
      _phoneFocusNode.unfocus();
    }
    _prevBottomInset = bottomInset;
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Widget _buildTextField(BuildContext context) {
    final _appModel = Provider.of<AppModel>(context);

    return TextFormField(
      controller: _phoneNumberController,
      focusNode: _phoneFocusNode,
      autofocus: false,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isDense: true,
        hintText: 'SOS Phone Number',
      ),
      keyboardType: TextInputType.phone,
      style: Theme.of(context).textTheme.bodyText2,
      onFieldSubmitted: (String text) => _appModel.phone = text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appModel = Provider.of<AppModel>(context);

    if (_appModel.isPhoneSet) {
      _phoneNumberController.text = _appModel.phone;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onBackground,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 5.0),
            color: Theme.of(context).shadowColor,
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Emergency Contact',
            style: Theme.of(context).textTheme.headline4,
          ),
          _buildTextField(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () =>
                    _appModel.isPhoneSet ? makePhoneCall(_appModel.phone) : '',
                icon: Icon(Icons.phone),
              ),
              IconButton(
                onPressed: () => _phoneFocusNode.requestFocus(),
                icon: Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
