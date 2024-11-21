import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/organization_state.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/organization_card_item.dart';

class OrganizationListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/organization-list';

  const OrganizationListScreen({super.key});

  @override
  ConsumerState createState() => _DetiesListScreenState();
}

class _DetiesListScreenState extends ConsumerState<OrganizationListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _page = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchDeties();
  }

  Future<void> _fetchDeties() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(organizationNotifierProvider.notifier)
        .fetchPaginatedOrganizations(_page, _pageSize);
    setState(() {
      _isLoading = false;
      _page++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchDeties();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final organizationList = ref.watch(organizationNotifierProvider);

    return Scaffold(
      appBar: const GonpaAppBar(title: 'Organization List'),
      body: organizationList.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: organizationList.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == organizationList.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final organization = organizationList[index];

                return OrganizationCardItem(
                  organization: organization,
                );
              },
            ),
    );
  }
}
