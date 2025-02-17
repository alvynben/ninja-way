import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ninja_way/constants.dart';
import 'package:ninja_way/controller/map_controller.dart';
import 'package:ninja_way/controller/waypoints_controller.dart';
import 'package:ninja_way/widgets/map_draggable_scroll_sheet.dart';

void main() => runApp(const NinjaWayApp());

class NinjaWayApp extends StatelessWidget {
  const NinjaWayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final MapController mapController = Get.put<MapController>(MapController());
    final WaypointController waypointController =
        Get.put<WaypointController>(WaypointController());
    mapController.initialize();
    Future.delayed(const Duration(seconds: 3), () {
      mapController.moveCameraToFirstWaypoint();
    });
    waypointController.fetchWaypoints();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NunitoSans',
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'NunitoSans',
              fontSizeFactor: 1,
            ),
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primaryColor,
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: primaryColor,
            onPrimary: Colors.white,
            secondary: primaryLightColor,
            onSecondary: Colors.black,
            error: Colors.black,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ninja Way'),
          backgroundColor: primaryColor,
        ),
        body: Obx(
          () => mapController.isLoading.value
              ? Center(child: CircularProgressIndicator(key: UniqueKey()))
              : Stack(
                  children: [
                    Positioned.fill(
                      bottom: 130,
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        markers: Set<Marker>.from(mapController.markers),
                        polylines: mapController.polylines,
                        onMapCreated: mapController.onMapCreated,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: mapController.center.value,
                          zoom: 15.0,
                        ),
                      ),
                    ),
                    const MapDraggableScrollSheet(),
                  ],
                ),
        ),
      ),
    );
  }
}
