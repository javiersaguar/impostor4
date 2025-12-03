import 'dart:convert'; // Para convertir datos a JSON
import 'dart:math';
import 'dart:ui'; // Necesario para el efecto Glassmorphism
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar datos en el móvil

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ImpostorApp());
}

// ==========================================
// TEMA Y CONFIGURACIÓN GENERAL
// ==========================================
class ImpostorApp extends StatelessWidget {
  const ImpostorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Impostor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Azul noche profundo
        useMaterial3: true,
        fontFamily: 'Roboto', 
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1), // Indigo elegante
          secondary: Color(0xFFEC4899), // Rosa moderno
          surface: Color(0xFF1E293B), // Pizarra oscuro
        ),
      ),
      home: const SetupScreen(),
    );
  }
}

// ==========================================
// GESTOR DE DATOS (NUEVO: Para guardar tus categorías)
// ==========================================
class DataManager {
  static const String _customCategoriesKey = 'custom_categories_v1';

  // Cargar categorías guardadas
  static Future<Map<String, List<String>>> loadCustomCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_customCategoriesKey);
    
    if (storedData == null) return {};

    try {
      Map<String, dynamic> decoded = jsonDecode(storedData);
      Map<String, List<String>> result = {};
      decoded.forEach((key, value) {
        result[key] = List<String>.from(value);
      });
      return result;
    } catch (e) {
      return {};
    }
  }

  // Guardar nueva categoría
  static Future<void> saveCategory(String name, List<String> words) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> current = await loadCustomCategories();
    current[name] = words;
    await prefs.setString(_customCategoriesKey, jsonEncode(current));
  }

  // Borrar categoría
  static Future<void> deleteCategory(String name) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> current = await loadCustomCategories();
    current.remove(name);
    await prefs.setString(_customCategoriesKey, jsonEncode(current));
  }
}

// ==========================================
// WIDGETS DE DISEÑO (REUTILIZABLES)
// ==========================================

class BackgroundGradient extends StatelessWidget {
  final Widget child;
  const BackgroundGradient({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF1E1B4B), // Indigo 950
            Color(0xFF312E81), // Indigo 900
          ],
        ),
      ),
      child: child,
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final Color? backgroundColor;
  final Color? borderColor;
  
  const GlassCard({
    super.key, 
    required this.child, 
    this.padding = 20.0,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ==========================================
// BASE DE DATOS DE PALABRAS (TU LISTA COMPLETA)
// ==========================================
class WordDatabase {
  static final Map<String, List<String>> categories = {
    // --- REDES & INTERNET ---
    'Redes & Postureo': [
      'Story de Mejores Amigos', 'Hater', 'Troll', 'Reel', 
      'TikToker', 'Unfollow', 'Stalkear', 'Fake News', 
      'Influencer', 'Directo', 'Trending Topic', 
      'Feed', 'Selfie', 'DM', 'Podcast', 'Viral',
      'Postureo', 'Highlights', 'Like a la histoia' 
    ],
    'Jerga de Internet': [
      'Funado',  'Basado', 'Cringe', 'Red Flag', 'NPC', 
      'Main Character', 'POV', 'Lore', 'Shippeo', 'Meme', 'Clickbait', 
      'Spoiler', 'Beef', 'Zasca', 'Modo Diablo', 'Fomo',
      'Sigma', '67', 'Simp', 'Virgen'
    ],
    
    // --- RELACIONES & FIESTA ---
    'Relaciones (+18 soft)': [
      'Casi Algo', 'Ghosting', 'Tinder', 'Grinder',
      'Friendzone', 'Sugar Daddy',
      'Body Count', 'OnlyFans', 'Nudes', 'Sexting', 'Ex tóxico', 
      'Contacto Cero', 'Responsabilidad Afectiva', 'Poliamor',
      'Amantes', 'A Cuatro', 'Rollos de una noche', 'Pene 20cm',
      'Guarrindonga', 'Bisexual', 'Putero', 'Lechazo', 'Baños',
      'Coño Peludo', 'Trío', 'Tetazas', 'Paja', 'Cuernos', 'Infiel'
    ],
    'Fiesta & Noche': [
      'Jagger', 'Vaper', 'Resaca', 'After', 'Barra Libre', 
      'Segurata', 'Zona VIP', 'Chupito',
      'Perreo', 'Rave', 'Techno', 'Festival', 'Pulsera', 
      'Uber', 'Kebab','Botellón', 'Garrafón', 'Barceló',
      'Mamada', 'Amego Segarro', 'Cubata', 'Marihuana', 'Fentanilo',
      'Nuit', 'Vomitar', 'Guarreo en el parque de Nuit'
    ],

    // --- TEMÁTICAS ESPECIALES ---
    'Famosos & Hollywood': [
      'Zendaya', 'Lana Rohades', 'Leonardo DiCaprio', 'Margot Robbie',
      'The Rock', 'Will Smith', 'Johnny Depp', 'Angelina Jolie', 
      'Brad Pitt', 'Kylie Jenner', 'Kim Kardashian', 'Harry Styles',
      'Aitana','Quevedo','Rosalía','BadBunny', 'Jordi ENP',
      'Rafa Nadal'
    ],
      'Fútbol & Leyendas': [
    // Jugadores históricos
    'Pelé', 'Maradona', 'Johan Cruyff', 'Franz Beckenbauer', 'Alfredo Di Stéfano',
      'Ronaldo Nazário', 'Ronaldinho', 'Zidane', 'Paolo Maldini', 'Roberto Carlos',
      'George Best', 'Eusebio', 'Bobby Charlton', 'Xavi', 'Iniesta', 'Garrincha',
      'Marco van Basten', 'Gerd Müller', 'Romário', 'Batistuta', 'Totti', 'Henry',
      'Raúl González', 'Buffon', 'Iker Casillas',

  // Jugadores actuales top
      'Messi', 'Cristiano Ronaldo', 'Mbappé', 'Haaland', 'Neymar', 'Vinicius Jr',
      'Lewandowski', 'Kane', 'Salah', 'Benzema', 'Modric', 'De Bruyne', 'Griezmann',
      'Kvaratskhelia', 'Rodri', 'Pedri', 'Gavi', 'Bellingham', 'Son Heung-min',
      'Bruno Fernandes', 'João Félix', 'Valverde', 'Odegaard', 'Ter Stegen',
      'Courtois', 'Enzo Fernández', 'Endrick', 'Lautaro Martínez',

  // Equipos europeos
      'Real Madrid', 'FC Barcelona', 'Atlético de Madrid', 'Sevilla FC',
      'Manchester United', 'Manchester City', 'Liverpool', 'Chelsea', 'Arsenal',
      'Tottenham', 'Bayern de Múnich', 'Borussia Dortmund', 'PSG', 'Olympique Lyon',
      'Olympique de Marsella', 'Juventus', 'Inter de Milán', 'AC Milan', 'Roma',
      'Napoli', 'Ajax', 'PSV Eindhoven', 'Benfica', 'Porto',

  // Equipos sudamericanos
      'Boca Juniors', 'River Plate', 'Flamengo', 'Palmeiras', 'Corinthians',
      'Santos FC', 'São Paulo', 'Colo-Colo', 'Peñarol', 'Nacional',

  // Selecciones
      'España', 'Brasil', 'Argentina', 'Francia', 'Alemania', 'Italia', 'Inglaterra',
      'Portugal', 'Países Bajos', 'Uruguay', 'Croacia', 'Bélgica', 
      'Colombia', 'Chile', 'México',

  // Términos del fútbol
      'Balón de Oro', 'Champions League', 'Europa League', 'Mundial',
      'Eurocopa', 'Copa América', 'Fuera de Juego', 'VAR', 'Penalti',
      'Tarjeta Roja', 'Tarjeta Amarilla', 'Corner', 'Falta', 'Golazo',
      'Hat-Trick', 'Chilena', 'Rabona', 'Tiki-Taka', 'Contraataque',
      'Clásico', 'Derbi', 'Remontada', 'Portero', 'Extremo', 'Central',
      'Delantero Centro', 'Árbitro comprado', 'Negreira'

    ],
    'Políticos & Salseo': [
      'Feijóo', 'Ayuso', 'Trump', 'Biden', 'Putin',
      'Zelenski', 'Rey Felipe', 'Reina Letizia', 'Perro Sanxe', 
      'El Coletas', 'Errejón' , 'Irene Montero','Mazón',
      'Ábalos', 'Vito Quiles', 'Gabriel Rufián', 'Jorge Javier',
      'ZonaGemelos'
    ],
    'Moda & Ropa Íntima': [
      'Tanga', 'Boxer', 'Desnudo', 'Sujetador Push-up', 'Oversize', 'Pitillos',
      'Chándal', 'Tacones', 'Bikini', 'Vestido corto' , 'Minifalda', 'Escote'
    ],
    'Insultos & Expresiones': [
      'Bocachancla', 'Pagafantas', 'Pringado', 'Fantasma', 'Flipado',
      'Cuñado', 'Calzonazos', 'Vividor', 'Lameculos',
      'Aguafiestas', 'Bienqueda', 'Marronero', 'Perroflauta',' Cayetano',
      'Pija', 'Choni'
    ],

    // --- ESTILO DE VIDA & HOBBIES (Fusionados) ---
    'Deportes & Gym': [
      'Burpee', 'Agujetas', 'Proteína', 'Creatina',
      'Press Banca', 'Sentadilla', 'Yoga', 'Pilates', 'Padel',
      'Tenis', 'Baloncesto', 'Natación', 'Formula 1', 'MotoGP',
      'Dopaje', 'Maratón', 'Ironman', 'PR (Personal Record)', 
      'Día de pierna', 'Pre-entreno'
    ],
    'Videojuegos & Streaming': [
      'Tryhard', 'Streamer', 'Skin legendaria',
      'Speedrun', 'Noob', 'Pro Player',
      'Buff', 'Nerf', 
    ],
    'Comida & Planes': [
      'Glovo', 'Café', 'Smash Burger', 'Merendola', 'Tupper',
      'Pizza', 'Menú del día', 'Postre', 'Tarta', 
      'Mesa', 'Mojito', 'Buffet', 'RonCola'
    ],
    'Vida Diaria & Random': [
      'Tarjeta Denegada', 'Batería 1%', 'Modo Avión', 'Grupo WhatsApp', 
      'Audio Infinito', 'Sticker', 'Bizum', 'Llegar Tarde', 
      'Visto', 'Llamada Perdida', 'Hacer la croqueta', 'Wifi'
    ],
    'Cultura Pop': [
      'Ibai', 'Kings League', 'La Velada', 'Taylor Swift', 'Motomami', 
      'Bizarrap', 'Inteligencia Artificial', 'Crypto', 'Gymbro', 'Aesthetic', 
      'Coquette', 'Trap', 'Reggaeton', 'Horóscopo',
      'Shakira', 'Oppenheimer'
    ],

    // --- ACADÉMICO & PRO ---
    'Universidad & Estudiante': [
      'Trabajo en grupo', 'Copiar en el examen', 'Apuntes prestados', 'Clase online',
      'PDF de 200 páginas', 'Estudiar la noche antes', 
      'Biblio', 'Moodle', 'Ansiedad pre-examen', 'Parcial',
      'Suspenso colectivo', 'Examen tipo test', 'Recuperación',
      'Memorizar', 'Trabajo final', 'Profe gilipollas', 'Buen Profesor'
    ],
    'Ingeniería de Datos & IA': [
      'Overfitting', 'KNN', 'Árboles de Decisión', 
      'p-valor',  'Kubernetes', 'Docker', 'SQL',
      'K-Means', 'Entropía', 'APIs', 'Alcolea Ratón', 'Alcoputas',
      'Gomezsito', 'Rugby Teleco', 'Susez', 'Javito', 'Naval', 'Djokovic',
      'Hyundai i20', 'Parking  ETSIT'
    ],
      'Humor Negro & Tabú': [
      'Pedófilo', 'Auschwitz', 'Atentado', 'Aborto', 'Sida', 'Discapacitado', 
      'Ceniza de abuela',  'Tener síndrome de Down', 'Ser gitano', 
      'Incesto', 'Hijoputa'
    ],
    'Cuerpo & Fluidos (+18)': [
      'Caca', 'Pedo',  'Meado',  'Coño', 'Polla', 'Huevo',
      'Culo', 'Teta',  'Regla', 'Flujo vaginal', 'Esperma', 
      'Leche', 'Eyaculación', 'Orificio', 'Clítoris', 'Glande', 
      'Prepucio', 'Circuncisión', 'Selva genital','El orgasmo',
      'La eyaculación femenina', 'El punto G', 'Kamasutra',
      'Mueble roto'
    ],
    'Mundo Rural & Básico': [
      'Tractor', 'Ordeñar', 'Ganado', 'Cerdos', 'Gallinas', 
      'Cosecha',  'Pozo', 'Chorizo', 'Fiesta del pueblo', 
      'Verbena', 'Peña', 'El cura', 'El alcalde', 
      'El tonto del pueblo', 'Mear en la esquina', 'Peña'
    ],
    'Militar & Armas': [
      'AK-47', 'Pistola', 'Escopeta', 'Francotirador',
      'Cargador', 'Dinamita', 'Granada', 'Bomba',
    ],
    'Coches & Tuning (Callejero)': [
      'Seat Ibiza', 'Porsche', 'Ferrari', 
      'Radar', 'Multas', 'Fumar un porro en el coche', 
      'Sexo en el coche', 'Aparcar mal', 'Robar el coche'
    ],
    'Medicina & Enfermedad (Gráfica)': [
      'Médico', 'Enfermera', 'Hospital', 'Jeringuilla', 
      'Inyección', 'Muletas', 'Silla de ruedas', 'Vómitos',
      'Diarrea', 'Estreñimiento', 'Fisura anal', 'Piojos', 
      'Sarna', 'Hongos', 'Infección', 'Coma etílico'
    ],
    'Ley & Crimen': [
      'Policía', 'Guardia Civil', 'Denunciar', 'Detener',
      'Esposas', 'Comisaría', 'Celda', 'Juzgado',
      'Abogado', 'Procesado', 'Culpable', 'Inocente', 'Cárcel',
      'Asesinato', 'Atraco', 'Ladrón', 'Carterista', 'Estafador', 
      'Mafia', 'Sicario', 'Testigo'
    ],
    'Fetichismos': [
      'Masoquismo', 'Voyerismo', 'Exhibicionismo','Zoofilia', 
      'Ninfomanía', 'Cuero', 'Latex', 'Sumiso', 'Esclava', 
      'Cadena', 'Antifaz', 'Dildo con IA', 'Pegging', 'Plug Anal',
      'Misionero', 'Perrito', 'La cubana', '69', 'Sin condón'
    ],
    'Armas Blancas & Supervivencia': [
      'Machete', 'Katana', 'Navaja', 'Garrote', 'Porra', 
      'Ballesta', 'Mechero', 'Cazar', 'Fonsi táctico'
    ],
    'Economía & Estafa': [
      'Pirámide', 'Phishing', 'Criptomoneda','Felix', 
      'Quiebra','Evasión de impuestos', 'Paraíso fiscal', 
      'Blanqueo de capitales', 'Chiringuito', 'Hacer negocio',
      'Pagar en negro', 'Bitcoin'
    ],
    'Conspiranoia & Sectas': [
      'Illuminati', 'Masonería', 'Terra plana', 'Reptilianos', 
      'Microchip', 'Gran Hermano', 'Abuso sexual', 'Primado negativo',
      'Mr Tartaria', 'Lavado de cerebro'
    ],
    'Cuerpo & Modificación': [
      'Tatuaje', 'Piercing','Tercer pezon', 'Inyección de silicona', 
      'Lifting brasileño (BBL)', 'Llenado de labios', 'Glúteos de silicona',
      'Botox', 'Cirugía plástica', 'Rinoplastia', 'Anorexia', 
      'Dismorfia muscular', 'Esteroides', 'Joan Pradells'
    ],
    'Peligro & Catástrofe': [
      'Terremoto', 'Tsunami', 'Huracán', 'Tornado', 'Inundación', 
      'Apocalipsis', 'Zombie', 'Pandemia', 'Virus', 'Contagio', 
      'Cuarentena', 'Guerra civil', 'Guerra mundial', 
      'Caníbal'
    ],
    'Submundos & Marginación': [
      'Pobreza','Indigente', 'Carterista', 'Ladrón', 'Prostituta', 
      'Gigoló', 'Yonqui', 'Alcohólico/a','Okupa','Guetto', 'Favela', 
      'Tráfico de personas', 'Explotación infantil', 'Bandas latinas', 
      'Gangster', 'Camello', 'Chulo'
    ],
  };
}

// ==========================================
// PANTALLA 1: CONFIGURACIÓN (HOME) - ACTUALIZADA
// ==========================================
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  double _players = 5;
  double _impostors = 1;
  
  // Estado para las categorías seleccionadas
  Set<String> _selectedCategories = {};
  // Combinación de categorías base + personalizadas
  Map<String, List<String>> _allCategories = {}; 

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Cargamos categorías base + las del teléfono
  Future<void> _loadData() async {
    Map<String, List<String>> custom = await DataManager.loadCustomCategories();
    setState(() {
      _allCategories = {...WordDatabase.categories, ...custom};
      // Por defecto seleccionamos las base si no hay nada seleccionado
      if (_selectedCategories.isEmpty) {
         _selectedCategories = Set.from(WordDatabase.categories.keys);
      }
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  // Función para borrar (Solo funciona en categorías custom)
  void _deleteCustomCategory(String categoryName) async {
    // Protección: No dejar borrar las base
    if (WordDatabase.categories.containsKey(categoryName)) return;

    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("¿Borrar categoría?", style: TextStyle(color: Colors.white)),
        content: Text("Se eliminará '$categoryName' y sus palabras para siempre.", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(child: const Text("CANCELAR"), onPressed: () => Navigator.pop(context, false)),
          TextButton(child: const Text("BORRAR", style: TextStyle(color: Colors.red)), onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await DataManager.deleteCategory(categoryName);
      await _loadData(); // Recargar lista
      setState(() {
        _selectedCategories.remove(categoryName);
      });
    }
  }

  void _openCategoryCreator() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoryCreatorScreen()),
    );
    _loadData(); // Recargar al volver por si creó una nueva
  }

  void _startGame() {
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona al menos una categoría"),
          backgroundColor: Color(0xFFEC4899),
        ),
      );
      return;
    }

    // Recolectar todas las palabras de las categorías activas
    List<String> validWords = [];
    _allCategories.forEach((key, list) {
      if (_selectedCategories.contains(key)) {
        validWords.addAll(list);
      }
    });

    if (validWords.isEmpty) return;

    final randomWord = validWords[Random().nextInt(validWords.length)];

    int playerCount = _players.toInt();
    int impostorCount = _impostors.toInt();
    
    List<String> roles = List.filled(playerCount, randomWord);
    var rng = Random();
    Set<int> impostorIndices = {};
    while (impostorIndices.length < impostorCount) {
      impostorIndices.add(rng.nextInt(playerCount));
    }
    for (var index in impostorIndices) {
      roles[index] = "IMPOSTOR";
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(roles: roles, secretWord: randomWord)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_impostors >= _players) _impostors = _players - 1;

    return Scaffold(
      // Botón flotante para crear categorías
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCategoryCreator,
        backgroundColor: const Color(0xFFEC4899),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("CREAR TUYA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BackgroundGradient(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "EL IMPOSTOR",
                          style: TextStyle(
                            fontSize: 42, 
                            fontWeight: FontWeight.w900, 
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "EDICIÓN DEFINITIVA",
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.w300, 
                            color: Color(0xFF6366F1),
                            letterSpacing: 6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Configuración de Jugadores
                      GlassCard(
                        child: Column(
                          children: [
                            _buildSliderRow(
                              title: "JUGADORES",
                              value: _players,
                              min: 3, max: 20,
                              accentColor: const Color(0xFF6366F1),
                              onChanged: (v) => setState(() => _players = v),
                            ),
                            const SizedBox(height: 20),
                            Divider(color: Colors.white.withValues(alpha: 0.1)),
                            const SizedBox(height: 20),
                            _buildSliderRow(
                              title: "IMPOSTORES",
                              value: _impostors,
                              min: 1, 
                              max: (_players - 1 > 1) ? _players - 1 : 1,
                              accentColor: const Color(0xFFEC4899),
                              onChanged: (v) => setState(() => _impostors = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      
                      const Text(
                        "CATEGORÍAS DISPONIBLES",
                        style: TextStyle(color: Colors.white70, letterSpacing: 1.5, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      
                      // Selector de Categorías (Chips)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _allCategories.keys.map((category) {
                          final isSelected = _selectedCategories.contains(category);
                          // Detectamos si es custom porque NO está en la base hardcoded
                          final isCustom = !WordDatabase.categories.containsKey(category);

                          return GestureDetector(
                            onTap: () => _toggleCategory(category),
                            // Si mantienes pulsado una custom, pregunta si borrar
                            onLongPress: isCustom ? () => _deleteCustomCategory(category) : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF6366F1).withValues(alpha: 0.3) 
                                    : (isCustom ? const Color(0xFFEC4899).withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05)),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected 
                                      ? const Color(0xFF6366F1) 
                                      : (isCustom ? const Color(0xFFEC4899).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1)),
                                  width: 1.5,
                                ),
                                boxShadow: isSelected ? [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ] : [],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isCustom) 
                                    const Padding(
                                      padding: EdgeInsets.only(right: 5), 
                                      child: Icon(Icons.star, size: 12, color: Color(0xFFEC4899))
                                    ),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white60,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 80), // Espacio extra para el botón flotante
                    ],
                  ),
                ),
              ),
              
              // Botón Iniciar (Fijo abajo)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: _selectedCategories.isNotEmpty 
                        ? [const Color(0xFF6366F1), const Color(0xFFEC4899)]
                        : [Colors.grey, Colors.grey.shade700],
                    ),
                    boxShadow: _selectedCategories.isNotEmpty ? [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ] : [],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: _startGame,
                    child: const Text(
                      "INICIAR PARTIDA", 
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String title,
    required double value,
    required double min,
    required double max,
    required Color accentColor,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, letterSpacing: 1.5, fontSize: 12)),
            Text(
              value.toInt().toString(),
              style: TextStyle(color: accentColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accentColor,
            inactiveTrackColor: accentColor.withValues(alpha: 0.2),
            thumbColor: Colors.white,
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayColor: accentColor.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt() > 0 ? (max - min).toInt() : 1,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// PANTALLA: CREADOR DE CATEGORÍAS (NUEVA)
// ==========================================
class CategoryCreatorScreen extends StatefulWidget {
  const CategoryCreatorScreen({super.key});

  @override
  State<CategoryCreatorScreen> createState() => _CategoryCreatorScreenState();
}

class _CategoryCreatorScreenState extends State<CategoryCreatorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wordController = TextEditingController();
  final List<String> _words = [];

  void _addWord() {
    if (_wordController.text.trim().isNotEmpty) {
      setState(() {
        _words.add(_wordController.text.trim());
        _wordController.clear();
      });
    }
  }

  void _saveCategory() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ponle nombre a la categoría")));
      return;
    }
    if (_words.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Añade al menos 5 palabras")));
      return;
    }

    await DataManager.saveCategory(_nameController.text.trim(), _words);
    if (mounted) Navigator.pop(context); // Volver al home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text("Crear Pack Propio")),
      body: BackgroundGradient(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration(
                  labelText: "Nombre del Pack (ej: Mi Pueblo)",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEC4899))),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _wordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Añadir palabra...",
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addWord(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _addWord,
                    style: IconButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.all(12)),
                    icon: const Icon(Icons.add, color: Colors.white),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GlassCard(
                  child: _words.isEmpty 
                    ? const Center(child: Text("Añade palabras para empezar", style: TextStyle(color: Colors.white30)))
                    : ListView.builder(
                        itemCount: _words.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(_words[index], style: const TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.redAccent),
                            onPressed: () => setState(() => _words.removeAt(index)),
                          ),
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC4899)),
                  onPressed: _saveCategory,
                  child: const Text("GUARDAR PACK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// PANTALLA 2: JUEGO (ANIMACIONES AVANZADAS)
// ==========================================
class GameScreen extends StatefulWidget {
  final List<String> roles;
  final String secretWord;

  const GameScreen({super.key, required this.roles, required this.secretWord});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentIndex = 0;
  bool _isRevealed = false;

  void _nextStep() {
    if (_isRevealed) {
      if (_currentIndex < widget.roles.length - 1) {
        setState(() {
          _isRevealed = false;
          _currentIndex++;
        });
      } else {
        _showEndGame();
      }
    } else {
      setState(() {
        _isRevealed = true;
      });
    }
  }

  void _showEndGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("FASE DE DISCUSIÓN", 
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.how_to_reg, size: 50, color: Color(0xFF6366F1)),
            SizedBox(height: 15),
            Text(
              "El reparto ha terminado. Es hora de debatir y encontrar al mentiroso.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("FINALIZAR", style: TextStyle(color: Color(0xFFEC4899), fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior minimalista
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "JUGADOR ${_currentIndex + 1} / ${widget.roles.length}",
                  style: const TextStyle(color: Colors.white54, letterSpacing: 2, fontSize: 12),
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                    },
                    child: _isRevealed ? _buildRevealedCard() : _buildHiddenCard(),
                  ),
                ),
              ),

              // Botón de Acción
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRevealed ? const Color(0xFF1E293B) : const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: _isRevealed ? BorderSide(color: Colors.white.withValues(alpha: 0.2)) : BorderSide.none,
                      ),
                    ),
                    onPressed: _nextStep,
                    child: Text(
                      _isRevealed 
                          ? (_currentIndex == widget.roles.length - 1 ? "FINALIZAR" : "OCULTAR Y PASAR")
                          : "REVELAR IDENTIDAD",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHiddenCard() {
    return GlassCard(
      key: const ValueKey(1),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.fingerprint, size: 60, color: Color(0xFF6366F1)),
            ),
            const SizedBox(height: 30),
            const Text(
              "IDENTIDAD OCULTA",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Text(
              "Asegúrate de que nadie más esté mirando la pantalla.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.6), height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealedCard() {
    final isImpostor = widget.roles[_currentIndex] == "IMPOSTOR";
    final color = isImpostor ? const Color(0xFFEC4899) : const Color(0xFF10B981); // Rosa o Esmeralda

    return GlassCard(
      key: const ValueKey(2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.5)),
              ),
              child: Text(
                isImpostor ? "OBJETIVO" : "CLAVE",
                style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              isImpostor ? "IMPOSTOR" : widget.roles[_currentIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(color: color.withValues(alpha: 0.6), blurRadius: 20)
                ]
              ),
            ),
            const SizedBox(height: 40),
            Text(
              isImpostor 
                  ? "Engaña a los demás. No dejes que descubran que no sabes la palabra." 
                  : "Esta es la palabra secreta. Úsala sabiamente para identificarte.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
