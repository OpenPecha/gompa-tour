import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/organization_state.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/organization_card_item.dart';

class OrganizationListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/organization-list';
  final String? category;

  OrganizationListScreen({
    super.key,
    this.category,
  });

  @override
  ConsumerState createState() => _DetiesListScreenState();
}

class _DetiesListScreenState extends ConsumerState<OrganizationListScreen> {
  late OrganizationNotifier organizationNotifier;
  @override
  void initState() {
    super.initState();
    // Fetch initial deities when the screen is first loaded
    organizationNotifier = ref.read(organizationNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.category == "All") {
        organizationNotifier.fetchInitialOrganizations();
      } else {
        organizationNotifier
            .fetchCategorisedInitialOrganizations(widget.category ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final organizationState = ref.watch(organizationNotifierProvider);
    return Scaffold(
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.organization),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !organizationState.isLoading &&
              !organizationState.hasReachedMax) {
            if (widget.category == "All") {
              organizationNotifier.fetchPaginatedOrganizations();
            } else {
              organizationNotifier.fetchPaginatedCategorisedOrganizations(
                  widget.category ?? '');
            }
          }
          return false;
        },
        child: organizationState.organizations.isEmpty &&
                organizationState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : organizationState.organizations.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noRecordFound,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: organizationState.organizations.length +
                        (organizationState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == organizationState.organizations.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final organization =
                          organizationState.organizations[index];

                      return OrganizationCardItem(
                        organization: organization,
                      );
                    },
                  ),
      ),
    );
  }
}
