import 'dart:async';

import 'package:flutter/material.dart';

class SearchListBar<T> extends StatefulWidget {
  const SearchListBar({
    super.key,
    required this.items,
    required this.onChanged,
    this.isLoading = false,
    this.hasData = false,
    required this.builder,
    this.searchHintText = 'Type to search...',
    this.onDataResultText = 'No results found for this search.\nPlease try again.',
  });

  /// If `true`, a [LinearProgressIndicator] will be shown below the search text field.
  final bool isLoading;

  /// If `true`, [onDataResultText] will be displayed.
  final bool hasData;

  /// List of items to be displayed in the search list bar as result.
  final List<T> items;

  /// Callback function when the text in the search bar changes.
  final ValueSetter<String> onChanged;

  /// Used to build the widget for each item in the search list bar. Since the search list bar is generic, we are providing this builder.
  final Widget Function(BuildContext, T) builder;

  /// Text to display as a hint in the search list bar.
  final String searchHintText;

  /// Text to display after the search list returns the result.
  final String onDataResultText;

  @override
  State<SearchListBar<T>> createState() => _SearchListBarState<T>();
}

class _SearchListBarState<T> extends State<SearchListBar<T>> {
  final _queryTextController = TextEditingController();
  final _readyStatusController = StreamController<bool>.broadcast();

  @override
  void didUpdateWidget(covariant SearchListBar<T> oldWidget) {
    _readyStatusController.add(widget.isLoading);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _queryTextController.dispose();
    _readyStatusController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            children: [
              TextField(
                readOnly: true,
                controller: _queryTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: widget.searchHintText,
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondary) {
                        return StreamBuilder<bool>(
                          stream: _readyStatusController.stream,
                          builder: (context, snapshot) {
                            return PopScope(
                              onPopInvoked: (didPop) {
                                _queryTextController.clear();
                                widget.onChanged('');
                              },
                              child: Scaffold(
                                appBar: AppBar(
                                  leading: BackButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _queryTextController.clear();
                                      widget.onChanged('');
                                    },
                                  ),
                                ),
                                body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: _queryTextController,
                                        onTapOutside: (event) => FocusScope.of(context).unfocus(),
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: widget.searchHintText,
                                        ),
                                        onChanged: widget.onChanged,
                                      ),
                                      if (widget.isLoading)
                                        const Flexible(
                                            child: Column(children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.0),
                                            child: LinearProgressIndicator(),
                                          )
                                        ])),
                                      if (!widget.isLoading && widget.items.isNotEmpty)
                                        Flexible(
                                          child: ListView.builder(
                                            physics: const ClampingScrollPhysics(),
                                            itemCount: widget.items.length,
                                            itemBuilder: (context, index) {
                                              final item = widget.items[index];

                                              return widget.builder(context, item);
                                            },
                                          ),
                                        ),
                                      widget.hasData
                                          ? Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                widget.onDataResultText,
                                                style: const TextStyle(fontSize: 20.0),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
