import 'package:biocu/features/homepage/user_profile.dart';
import 'package:biocu/features/reports/presentation/report_page.dart';
import 'package:flutter/material.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:provider/provider.dart';
import '../../core/styles/styles_texts.dart';
import '../../core/widgets/custom_show_dialog.dart';
import '../../core/widgets/doubleTap_to_exit.dart';
import '../auth/providers/auth_provider.dart';
import '../enviroment_info/presentation/enviroment_card.dart';
import '../notice/noticePage.dart';
import '../reports/presentation/report_show_admin_list.dart';
import '../tutorial/onborad_page.dart';
import 'app_info_dialog.dart';

class HomePage extends StatefulWidget {
  final int? initialIndex;

  const HomePage({super.key, this.initialIndex});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de páginas disponibles
  final List<Widget> _pages = [
    const EnvironmentalCardsScreen(), // Contenido para todos los usuarios
    const ReportScreen(),             // Reportar problema
    const ReportsScreen(),           // Lista de reportes (admin)
    const SimpleProfileScreen(),     // Perfil
    NewsListScreen(),
  ];

  // Títulos de las páginas
  final List<String> _pageTitles = [
    'Contenidos',
    'Reportar problema',
    'Lista de reportes',
    'Perfil',
    'Noticias',
  ];

  @override
  void initState() {
    super.initState();
    _setInitialPage();

    // Si se proporciona un initialIndex, úsalo
    if (widget.initialIndex != null) {
      _selectedIndex = widget.initialIndex!;
    }
  }

  void _setInitialPage() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userRole = authProvider.profile?.role;

    // Si el rol es 'admin', la primera página será la lista de reportes
    if (userRole == 'admin') {
      setState(() {
        _selectedIndex = 2; // Establecer a la lista de reportes
      });
    } else {
      setState(() {
        _selectedIndex = 0; // Establecer a la página de contenido
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Cierra el drawer
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackExitWrapper(
      message: 'Presiona de nuevo para salir',
      scaffoldKey: _scaffoldKey, // Pasa la clave del Scaffold
      child: Scaffold(
        backgroundColor: AppColors.background,
        key: _scaffoldKey,
        appBar: AppBar(
          foregroundColor: AppColors.textLight,
          backgroundColor: AppColors.primary,
          title: Text(
            _pageTitles[_selectedIndex],
            style: AppTextStyles.buttonText,
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          //TODO si se quiere implementar buscador
          // actions: [
          //   if (_selectedIndex == 0) // Solo mostrar en pantalla de cards
          //     IconButton(
          //       icon: const Icon(Icons.search),
          //       onPressed: () {
          //         // Lógica de búsqueda (para implementar)
          //       },
          //     ),
          // ],
        ),
        body: _pages[_selectedIndex],
        drawer: _buildDrawer(),
      ),
    );
  }

  Widget _buildDrawer() {
    final authProvider = Provider.of<AuthProvider>(
      context,
    ); // Acceder al AuthProvider
    final userRole =
        authProvider.profile?.role; // Obtener el rol del usuario

    return Drawer(
      child: Container(
        color: AppColors.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildDrawerHeader(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Aprendizaje',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            if (userRole == 'user') ...[
              _buildListTile(Icons.eco, 'Información Ambiental', 0),
              const Divider(color: AppColors.textLight),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Reportes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              _buildListTile(Icons.report_problem, 'Reportar Problema', 1),
              //_buildListTile(Icons.list_alt, 'Mis Reportes', 2),
              const Divider(color: AppColors.textLight),
            ],
            if (userRole == 'admin') ...[
              _buildListTile(Icons.file_copy_rounded, 'Lista de reportes', 2),
              const Divider(color: AppColors.textLight),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Mántente informado',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            _buildListTile(Icons.person, 'Noticias', 4),
            const Divider(color: AppColors.textLight),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Otras opciones',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            _buildListTile(Icons.person, 'Perfil', 3),

            _buildListTile(Icons.logout, 'Cerrar sesión', null, () async {
              print(authProvider.profile?.nombre);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) => CustomAlertDialog(
                  title: 'Cerrar sesión',
                  message:
                  '¿Estás seguro de que quieres salir de tu cuenta?',
                  confirmColor: AppColors.accent,
                  confirmText: 'Cerrar sesión',
                  cancelText: 'Cancelar',
                  onConfirm: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(color: AppColors.primary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => const AppInfoDialog(),
            ),
            child: CircleAvatar(
              backgroundColor: AppColors.card,
              radius: 30,
              child: Image.asset('assets/images/logo.png', width: 40),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Biocu',
            style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
          ),
          Text(
            'Bioconciencia cubana',
            style: AppTextStyles.bodyText.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      IconData icon,
      String title, [
        int? index,
        VoidCallback? onTap,
      ]) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textDark),
      title: Text(title, style: AppTextStyles.bodyText),
      selected: index == _selectedIndex,
      selectedTileColor: AppColors.secondary.withOpacity(0.1),
      onTap: onTap ?? (index != null ? () => _onItemTapped(index) : null),
    );
  }
}

