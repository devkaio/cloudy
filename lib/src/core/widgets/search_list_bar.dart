import 'dart:async';

import 'package:flutter/material.dart';

class SearchListBar<T> extends StatefulWidget {
  const SearchListBar({
    super.key,
    required this.items,
    required this.onItemSelected,
    required this.onChanged,
    this.isSearching = false,
    required this.builder,
  });

  final bool isSearching;
  final List<T> items;
  final ValueSetter<String> onChanged;
  final ValueSetter<T> onItemSelected;
  final Widget Function(BuildContext, T) builder;

  @override
  State<SearchListBar<T>> createState() => _SearchListBarState<T>();
}

class _SearchListBarState<T> extends State<SearchListBar<T>> {
  final _queryTextController = TextEditingController();
  final _readyStatusController = StreamController<bool>.broadcast();

  @override
  void didUpdateWidget(covariant SearchListBar<T> oldWidget) {
    _readyStatusController.add(widget.isSearching);
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
    return Stack(
      children: [
        Column(
          children: [
            TextField(
              readOnly: true,
              controller: _queryTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              onTap: () {
                FocusScope.of(context).unfocus();
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const LinearBorder(),
                  context: context,
                  builder: (context) {
                    return StreamBuilder<bool>(
                        stream: _readyStatusController.stream,
                        builder: (context, snapshot) {
                          return _SearchListBottomSheet<T>(
                            showLoader: snapshot.data ?? false,
                            searchInput: _queryTextController.text,
                            onChanged: (text) {
                              _queryTextController.text = text;
                              widget.onChanged(text);
                            },
                            items: widget.items,
                            onItemSelected: widget.onItemSelected,
                            builder: widget.builder,
                          );
                        });
                  },
                );
              },
            ),
          ],
        )
      ],
    );
  }
}

class _SearchListBottomSheet<T> extends StatelessWidget {
  const _SearchListBottomSheet({
    super.key,
    required this.showLoader,
    required this.searchInput,
    required this.onChanged,
    required this.onItemSelected,
    required this.items,
    required this.builder,
  });

  final bool showLoader;
  final String searchInput;
  final ValueSetter<String> onChanged;
  final List<T> items;
  final ValueSetter<T> onItemSelected;
  final Widget Function(BuildContext, T) builder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(),
        TextFormField(
          initialValue: searchInput,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onChanged(value);
          },
        ),
        showLoader
            ? const Flexible(
                child: Column(
                  children: [
                    LinearProgressIndicator(),
                  ],
                ),
              )
            : Flexible(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return builder(context, item);
                  },
                ),
              )
      ],
    );
  }
}
