import 'package:grouped_list/grouped_list.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/domain/models/notification_model.dart';
import 'package:picsa/utilities/packages.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<UserCubit, UserState>(
            buildWhen: (previous, current) =>
                previous.notifications != current.notifications,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state.status == UserStatus.loading) {
                          return const LinearProgressIndicator(
                            color: Color(
                              0xff70B93E,
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          'Notifications',
                          style: GoogleFonts.inter(
                            fontSize: 2.8 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[200],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.read<UserCubit>().markAsRead(),
                          child: Text(
                            'Mark all as read',
                            style: GoogleFonts.inter(
                              fontSize: 1.7 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w600,
                              color: green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Gap(2 * SizeConfig.widthMultiplier),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: SvgPicture.asset(
                            AppImages.close,
                            height: 3 * SizeConfig.heightMultiplier,
                            width: 3 * SizeConfig.heightMultiplier,
                            color: Colors.grey[300],
                          ),
                        )
                      ],
                    ),
                    GroupedListView<NotificationModel, String>(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      elements: state.notifications,
                      groupBy: (element) => !element.read
                          ? 'Unread Notification'
                          : 'Read Notification',
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              groupByValue,
                              style: GoogleFonts.inter(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const Spacer()
                          ],
                        ),
                      ),
                      itemBuilder: (context, NotificationModel notification) =>
                          NotificationCard(notification: notification),
                      separator: Gap(1 * SizeConfig.heightMultiplier),
                      itemComparator: (item1, item2) =>
                          item1.name.compareTo(item2.name),
                      useStickyGroupSeparators: true,
                      floatingHeader: true,
                      order: GroupedListOrder.DESC,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xff000000).withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(notification.name,
              style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                color: Colors.grey[200],
              )),
          Text(
            notification.content,
            maxLines: 10,
            style: GoogleFonts.inter(
              fontSize: 1.8 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Text(
            '${DateFormat.yMMMMd().format(DateTime.parse(notification.createdAt))} - ${DateFormat.jm().format(DateTime.parse(notification.createdAt))}',
            style: GoogleFonts.inter(
              fontSize: 1.6 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
