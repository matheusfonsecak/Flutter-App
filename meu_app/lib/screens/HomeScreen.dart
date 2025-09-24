import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position _currentPosition;
  bool _isLoading = true;
  String _locationError = '';

  // Lista de hospitais públicos de Feira de Santana
  final List<Map<String, dynamic>> _allHospitals = [
    {
      'name': 'Hospital Geral Clériston Andrade',
      'latitude': -12.2472,
      'longitude': -38.9482,
    },
    {
      'name': 'Hospital Estadual da Criança',
      'latitude': -12.2570,
      'longitude': -38.9700,
    },
    {
      'name': 'Hospital de Clínicas de Feira de Santana',
      'latitude': -12.2642,
      'longitude': -38.9566,
    },
    {
      'name': 'Hospital Dom Pedro de Alcântara',
      'latitude': -12.2612,
      'longitude': -38.9669,
    },
    {
      'name': 'Policlínica Municipal',
      'latitude': -12.2599,
      'longitude': -38.9585,
    },
  ];

  List<Map<String, dynamic>> _nearbyHospitals = [];

  @override
  void initState() {
    super.initState();
    _getNearbyHospitals();
  }

  Future<void> _getNearbyHospitals() async {
    setState(() {
      _isLoading = true;
      _locationError = '';
    });
    try {
      _currentPosition = await _determinePosition();
      _calculateDistances();
      _isLoading = false;
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        _locationError = e.toString();
        _isLoading = false;
      });
    }
  }

  void _calculateDistances() {
    _nearbyHospitals = _allHospitals.where((hospital) {
      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        hospital['latitude'],
        hospital['longitude'],
      );
      // Filtra hospitais em um raio de 10km (10000 metros)
      return distanceInMeters <= 10000;
    }).toList();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviços de localização desabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissões de localização foram negadas.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('As permissões de localização foram permanentemente negadas. Não podemos solicitar permissões.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFE6EFFF),
        child: Stack(
          children: [
            // Círculos de fundo
            Positioned(
              left: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: 10,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -50,
              bottom: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // AppBar do app
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.menu, color: Color(0xFF001A4A)),
                            ),
                            const Expanded(
                              child: Text(
                                'Monospitolar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001A4A),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(color: Colors.white),
                                child: Image.asset(
                                  'assets/images/monospitolar_logo.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Cartão de perfil
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF001A4A),
                                    width: 3.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/foto.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Antonio Fagundes',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001A4A),
                                ),
                              ),
                              const Text(
                                '123.456.789-01',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                '76 Anos',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildActionIcon(Icons.assignment_outlined, 'Exames'),
                                  _buildActionIcon(Icons.medical_services_outlined, 'Prontuário'),
                                  _buildActionIcon(Icons.credit_card_outlined, 'Cartão'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Lista de hospitais
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hospitais Próximos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001A4A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _locationError.isNotEmpty
                              ? Text(_locationError, style: const TextStyle(color: Colors.red))
                              : _nearbyHospitals.isEmpty
                                  ? const Text('Nenhum hospital encontrado perto de você.', style: TextStyle(color: Colors.grey))
                                  : Column(
                                      children: _nearbyHospitals.map((hospital) {
                                        return Card(
                                          elevation: 4,
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            leading: const Icon(Icons.local_hospital_outlined, color: Colors.blue),
                                            title: Text(
                                              hospital['name'],
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF001A4A)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
