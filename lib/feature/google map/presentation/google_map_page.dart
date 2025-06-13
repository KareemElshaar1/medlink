import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/routes/page_routes_name.dart';
import '../../../core/utils/color_manger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  String? _error;
  String? _currentAddress;
  String? _savedAddress;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
    _checkPermissionsAndGetLocation();
  }

  Future<void> _loadSavedAddress() async {
    try {
      final savedAddress = await SharedPrefHelper.getString('user_address');
      final savedLat = await SharedPrefHelper.getDouble('user_latitude');
      final savedLng = await SharedPrefHelper.getDouble('user_longitude');

      if (savedAddress != null && savedLat != null && savedLng != null) {
        if (!mounted) return;
        setState(() {
          _savedAddress = savedAddress;
          _currentPosition = LatLng(savedLat, savedLng);
          _markers = {
            Marker(
              markerId: const MarkerId("saved_location"),
              position: _currentPosition!,
              infoWindow: InfoWindow(
                title: "العنوان المحفوظ",
                snippet: savedAddress,
              ),
            ),
          };
        });
      }
    } catch (e) {
      print('Error loading saved address: $e');
    }
  }

  Future<void> _checkPermissionsAndGetLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'خدمات الموقع معطلة';
          _isLoading = false;
        });
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'تم رفض إذن الموقع';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'تم رفض إذن الموقع بشكل دائم';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        _markers = {
          Marker(
            markerId: const MarkerId("current_location"),
            position: _currentPosition!,
            infoWindow: const InfoWindow(
              title: "موقعك الحالي",
              snippet: "جاري تحميل العنوان...",
            ),
          ),
        };
      });

      // Get address from coordinates
      await _getAddressFromLatLng(_currentPosition!);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'خطأ في الحصول على الموقع: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Format address in Arabic style
        List<String> addressParts = [];

        if (place.street?.isNotEmpty ?? false) {
          addressParts.add(place.street!);
        }
        if (place.subLocality?.isNotEmpty ?? false) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality?.isNotEmpty ?? false) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea?.isNotEmpty ?? false) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country?.isNotEmpty ?? false) {
          addressParts.add(place.country!);
        }

        String address = addressParts.join('، ');

        if (!mounted) return;

        setState(() {
          _currentAddress = address;
          _markers = {
            Marker(
              markerId: const MarkerId("selected_location"),
              position: position,
              infoWindow: InfoWindow(
                title: "الموقع المحدد",
                snippet: address,
              ),
            ),
          };
        });

        // Save address and coordinates to SharedPreferences
        await SharedPrefHelper.setData('user_address', address);
        await SharedPrefHelper.setData('user_latitude', position.latitude);
        await SharedPrefHelper.setData('user_longitude', position.longitude);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'خطأ في الحصول على العنوان: ${e.toString()}';
      });
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _currentPosition = position;
      _markers = {
        Marker(
          markerId: const MarkerId("selected_location"),
          position: position,
          infoWindow: const InfoWindow(
            title: "الموقع المحدد",
            snippet: "جاري تحميل العنوان...",
          ),
        ),
      };
    });
    _getAddressFromLatLng(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.background,
      appBar: AppBar(
        title: Text(
          "اختر موقعك",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorsManager.textDark,
          ),
        ),
        backgroundColor: ColorsManager.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: ColorsManager.primary),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              _checkPermissionsAndGetLocation();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primary,
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.w,
                        color: ColorsManager.error,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: ColorsManager.textDark,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _checkPermissionsAndGetLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            color: ColorsManager.background,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 16,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      onTap: _onMapTapped,
                      markers: _markers,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                    if (_savedAddress != null)
                      Positioned(
                        top: 16.h,
                        left: 16.w,
                        right: 16.w,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: ColorsManager.background,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: ColorsManager.border,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: ColorsManager.primary,
                                      size: 20.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'العنوان المحفوظ:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        color: ColorsManager.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  _savedAddress!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorsManager.textMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (_currentAddress != null)
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        right: 16.w,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: ColorsManager.background,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: ColorsManager.border,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: ColorsManager.primary,
                                      size: 20.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'العنوان المحدد:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        color: ColorsManager.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  _currentAddress!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorsManager.textMedium,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLoading = true;
                                            _error = null;
                                          });
                                          _checkPermissionsAndGetLocation();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorsManager.lightGray,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                        ),
                                        child: Text(
                                          'العودة لموقعي',
                                          style: TextStyle(
                                            color: ColorsManager.textDark,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_currentPosition != null &&
                                          _currentAddress != null) {
                                        // Save the location data
                                        SharedPrefHelper.setData(
                                            'user_address', _currentAddress!);
                                        SharedPrefHelper.setData(
                                            'user_latitude',
                                            _currentPosition!.latitude);
                                        SharedPrefHelper.setData(
                                            'user_longitude',
                                            _currentPosition!.longitude);

                                        // Show success message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'تم حفظ العنوان بنجاح'),
                                            backgroundColor:
                                                ColorsManager.success,
                                            duration:
                                                const Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                          ),
                                        );

                                        // Navigate to checkout screen
                                        Navigator.pushReplacementNamed(
                                            context, PageRouteNames.checkout);
                                      } else {
                                        // Show error if location not selected
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'يجب تحديد موقعك على الخريطة'),
                                            backgroundColor:
                                                ColorsManager.error,
                                            duration:
                                                const Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorsManager.primary,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'التالي',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: ColorsManager.background,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
