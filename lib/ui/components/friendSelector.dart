import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendSelectorItem<T> {
  T value;
  Widget child;
  List<Widget> leading = [];
  bool disabled = false;
  // select default action is added by default
  List<Widget> actions = [];
  bool isSelected = false;

  FriendSelectorItem.custom(
      {@required this.child,
      @required this.value,
      this.leading,
      this.actions,
      this.disabled = false});

  FriendSelectorItem.simple(
      {@required String title,
      @required this.value,
      List<Widget> actions,
      this.disabled = false}) {
    this.child = Text(title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
          decoration: TextDecoration.none,
        ));
    this.actions = actions;
  }
}

class FriendSelector extends StatefulWidget {
  final String label;
  final List<FriendSelectorItem> elements;
  final List values;
  final bool disabled;

  const FriendSelector({
    Key key,
    @required this.label,
    @required this.elements,
    @required this.values,
    this.disabled = false,
  })  : assert(values != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => FriendSelectorDropdownState();
}

class FriendSelectorDropdownState extends State<FriendSelector> {
  // this will return the selected value. Please use key to fetch from current state.
  List _result = [];
  List get result => this._result;

  void updateSelectedState(FriendSelectorItem<dynamic> source, bool state) {
    setState(() {
      source.isSelected = state;
      if (this.widget.values.contains(source.value)) {
        source.isSelected = true;
      }
    });
  }

  Widget _getContent() {
    if (this._result.length <= 0 && this.widget.label != null) {
      return Row(
        children: [
          SizedBox(width: 15.0),
          Text(
            this.widget.label,
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: screenHeight * 0.015565438,
                ),
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: this
              .widget
              .elements
              .where((element) => this._result.contains(element.value))
              .map((element) {
            updateSelectedState(element, true); //element.isSelected = true;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: RawChip(
                isEnabled: !this.widget.disabled,
                label: element.child,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onDeleted: () {
                  if (!this.widget.disabled) {
                    updateSelectedState(element, false);
                    setState(() {
                      this._result.remove(element.value);
                    });
                  }
                },
              ),
            );
          }).toList(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (this.widget.values != null)
      this._result = this.widget.values.map((x) => x.toString()).toList();
  }

  void _showMultipleSelectDialog() async {
    var result = await showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (context) => SelectListModal(
        label: this.widget.label,
        elements: this.widget.elements,
        values: this._result,
      ),
    );
    setState(() {
      if (result != null) {
        this._result = result ?? this._result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Opacity(
          opacity: this.widget.disabled ? 0.4 : 1,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    this._getContent(),
                  ],
                ),
              ),
              Container(
                height: 23,
                width: 23,
                child: SvgPicture.asset(
                  'assets/icons/misc/add-group.svg',
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 15.0),
            ],
          ),
        ),
        onTap: () {
          if (!this.widget.disabled) _showMultipleSelectDialog();
        },
      ),
    );
  }
}

class SelectListModal extends StatefulWidget {
  final String label;
  final List<FriendSelectorItem> elements;
  final List values;

  const SelectListModal(
      {Key key,
      @required this.label,
      @required this.elements,
      @required this.values})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => SelectListModalState();
}

class SelectListModalState extends State<SelectListModal> {
  List _result = [];
  List get result => this._result;

  @override
  void initState() {
    super.initState();
    if (this.widget.values != null) this._result = this.widget.values;
  }

  List<Widget> _buildItemRow(FriendSelectorItem item) {
    List<Widget> widgets = [];
    widgets.addAll(item.leading ?? []);
    widgets.add(Expanded(child: item.child));
    widgets.add(item.isSelected
        ? Icon(
            Icons.radio_button_checked,
            size: 30,
            color: Theme.of(context).primaryIconTheme.color,
          )
        : Icon(
            Icons.add,
            size: 30,
            color: Theme.of(context).primaryIconTheme.color,
          ));
    widgets.addAll(item.actions ?? []);
    return widgets;
  }

  var getToolbar = (context, values) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        height: 40,
        child: GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            Navigator.pop(context, values);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 2,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
              ),
              color: Theme.of(context).cardColor,
            ),
            child: Container(
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 35,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 30,
                  child: Text(
                    this.widget.label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 18.0),
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 1.0),
                  itemCount: this.widget.elements.length,
                  itemBuilder: (context, index) {
                    FriendSelectorItem item = this.widget.elements[index];
                    return GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        this._result.contains(item.value)
                            ? this._result.remove(item.value)
                            : this._result.add(item.value);
                        setState(() {
                          item.isSelected = this._result.contains(item.value);
                        });
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _buildItemRow(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 40.0),
            ],
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.25),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
              ]),
          padding: EdgeInsets.only(top: 20, bottom: 5, left: 6, right: 6),
          // margin: EdgeInsets.only(top: this.widget.height, bottom: 40),
        ),
        this.getToolbar(context, this._result),
      ],
    );
  }
}
