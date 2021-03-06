import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarty/authenticate/authenticate.dart';
import 'package:smarty/models/darkModeSwitchProvider.dart';
import 'package:smarty/models/dbService.dart';
import 'package:smarty/models/devicesModel.dart';
import 'package:smarty/models/generationModel.dart';
import 'package:smarty/models/leaderboardModel.dart';
import 'package:smarty/models/navigationBar.dart';
import 'package:smarty/models/routineModel.dart';
import 'package:smarty/models/themeModel.dart';
import 'package:smarty/models/user.dart';
import 'package:smarty/screens/home_manager/dashboard_manager.dart';
import 'package:smarty/services/dialogManager.dart';
import 'package:smarty/services/dialogProvider.dart';
import 'models/consumptionModel.dart';
import 'models/currentDayProvider.dart';
import 'models/dbRoutines.dart';
import 'models/roomModel.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppThemeProvider>(
            create: (_) => AppThemeProvider(darkTheme: true),
          ),
        ],
        child: Consumer<AppThemeProvider>(builder: (context, myModel, child) {
          return MaterialApp(
            home: Authenticate(),
            theme: Provider.of<ThemeModel>(context).currentTheme,
          );
        }),
      );
    } else {
      if (user.type == "M") {
        return StreamProvider<List<Room>>.value(
          value: DatabaseService1().streamRooms(user),
          child: StreamProvider<List<LeaderboardModel>>.value(
            value: DatabaseService1().streamLeaderBoards(user),
            child: StreamProvider<List<Device>>.value(
              value: DatabaseService1().streamDevices(user),
              child: StreamProvider<List<int>>.value(
                value: DatabaseService1().streamHomiIDs(),
                child: StreamProvider<List<dbRoutine>>.value(
                  value: DatabaseService1().getSuggestedRoutines(user),
                  child: StreamProvider<List<String>>.value(
                    value: DatabaseService1().StreamUserlist(user.houseId),
                    child: MultiProvider(
                      providers: [
                        ChangeNotifierProvider<AppThemeProvider>(
                          create: (_) => AppThemeProvider(darkTheme: true),
                        ),
                      ],
                      child: Consumer<AppThemeProvider>(
                        builder: (context, myModel, child) {
                          MaterialApp(
                            theme:
                                Provider.of<ThemeModel>(context).currentTheme,
                            home: DashboardManager(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return StreamProvider<List<Room>>.value(
          value: DatabaseService1().streamRooms(user),
          child: StreamProvider<List<Device>>.value(
            value: DatabaseService1().streamDevices(user),
            child: StreamProvider<List<int>>.value(
              value: DatabaseService1().streamHomiIDs(),
              child: StreamProvider<List<dbRoutine>>.value(
                value: DatabaseService1().getSuggestedRoutines(user),
                child: StreamProvider<List<Routine>>.value(
                  value: DatabaseService1().getCurrentRoutines(user),
                  child: StreamProvider<List<LeaderboardModel>>.value(
                    value: DatabaseService1().streamLeaderBoards(user),
                    child: StreamProvider<Generation>.value(
                      value: DatabaseService1().streamGeneratedEnergy(user),
                      child: StreamProvider<Consumption>.value(
                        value: DatabaseService1().streamConsumedEnergy(user),
                        child: StreamProvider<List<String>>.value(
                          value:
                              DatabaseService1().StreamUserlist(user.houseId),
                          child: MultiProvider(
                            providers: [
                              ChangeNotifierProvider<DialogProvider>(
                                create: (_) => DialogProvider(),
                              ),
                              ChangeNotifierProvider<AppThemeProvider>(
                                create: (_) =>
                                    AppThemeProvider(darkTheme: true),
                              ),
                            ],
                            child: Consumer<AppThemeProvider>(
                              builder: (context, myModel, child) {
                                return MaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  builder: (context, widget) => Navigator(
                                    onGenerateRoute: (settings) =>
                                        MaterialPageRoute(
                                      builder: (context) => DialogManager(
                                        child: widget,
                                      ),
                                    ),
                                  ),
                                  theme: Provider.of<ThemeModel>(context)
                                      .currentTheme,
                                  home: MyNavigationBar(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
