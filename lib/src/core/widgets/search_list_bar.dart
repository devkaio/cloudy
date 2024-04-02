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

  final bool isLoading;
  final bool hasData;
  final List<T> items;
  final ValueSetter<String> onChanged;
  final Widget Function(BuildContext, T) builder;
  final String searchHintText;
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
