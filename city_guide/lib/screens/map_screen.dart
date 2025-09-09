import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import '../../models/attraction_model.dart';
import '../../utils/constants.dart';

class MapScreen extends StatefulWidget {
  final String cityId;

  const MapScreen({super.key, required this.cityId});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  List<AttractionModel> _attractions = [];
  Set<Marker> _markers = {};
  bool _isLoading = true;
  Position? _currentPosition;
  AttractionModel? _selectedAttraction;

  @override
  void initState() {
    super.initState();
    _loadAttractions();
    _getCurrentLocation();
  }

  Future<void> _loadAttractions() async {
    try {
      final databaseService = Provider.of<DatabaseService>(context, listen: false);
      final attractions = await databaseService.getAttractionsByCity(widget.cityId);
      
      setState(() {
        _attractions = attractions;
        _markers = _createMarkers(attractions);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationService = Provider.of<LocationService>(context, listen: false);
      final position = await locationService.getCurrentPosition();
      
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      // Handle location error silently
    }
  }

  Set<Marker> _createMarkers(List<AttractionModel> attractions) {
    return attractions.map((attraction) {
      return Marker(
        markerId: MarkerId(attraction.id),
        position: LatLng(attraction.latitude, attraction.longitude),
        infoWindow: InfoWindow(
          title: attraction.name,
          snippet: attraction.description,
          onTap: () {
            setState(() {
              _selectedAttraction = attraction;
            });
            _showAttractionInfo(attraction);
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    }).toSet();
  }

  void _showAttractionInfo(AttractionModel attraction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusLarge),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: AppConstants.paddingMedium),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attraction.name,
                      style: AppTextStyles.headline4,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      attraction.description,
                      style: AppTextStyles.body2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/attraction/${attraction.id}'),
                            icon: const Icon(Icons.info),
                            label: const Text('View Details'),
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        ElevatedButton.icon(
                          onPressed: () => _getDirections(attraction),
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getDirections(AttractionModel attraction) async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to get your current location'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final url = 'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${attraction.latitude},${attraction.longitude}';
    
    try {
      // Launch directions in Google Maps
      // You would need to add url_launcher package for this
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening directions in Google Maps...'),
          backgroundColor: AppColors.info,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open directions'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home/${widget.cityId}'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _goToCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _getInitialPosition(),
              zoom: AppConstants.defaultZoom,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          
          // Floating Action Button for current location
          Positioned(
            bottom: AppConstants.paddingLarge,
            right: AppConstants.paddingMedium,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.my_location,
                color: AppColors.surface,
              ),
            ),
          ),
          
          // Attractions count
          Positioned(
            top: AppConstants.paddingMedium,
            left: AppConstants.paddingMedium,
            right: AppConstants.paddingMedium,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.place,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Text(
                    '${_attractions.length} attractions',
                    style: AppTextStyles.body2.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LatLng _getInitialPosition() {
    if (_currentPosition != null) {
      return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    }
    
    // Default to first attraction or city center
    if (_attractions.isNotEmpty) {
      return LatLng(_attractions.first.latitude, _attractions.first.longitude);
    }
    
    // Default coordinates (New York City)
    return const LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude);
  }

  void _goToCurrentLocation() async {
    if (_currentPosition != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    } else {
      await _getCurrentLocation();
    }
  }
}
