import 'dart:math';
import 'dart:ui'; // Necesario para el efecto Glassmorphism
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
// BASE DE DATOS DE PALABRAS (MEGA FUSIÓN)
// ==========================================
class WordDatabase {
  static final Map<String, List<String>> categories = {
    // --- REDES & INTERNET ---
    'Redes & Postureo': [
      'Story de Mejores Amigos', 'Shadowban', 'Blue Check', 'Hater', 
      'Troll', 'Reel', 'TikToker', 'Unfollow', 'Stalkear', 'Fake News', 
      'Influencer', 'Canje', 'Directo', 'Trending Topic', 'Algoritmo', 
      'Feed', 'Caption', 'Selfie', 'DM', 'Podcast', 'Viral', 'Link en Bio',
      'Postureo extremo', 'Ratio positivo', 'Cuenta Privada', 'Highlights'
    ],
    'Jerga de Internet': [
      'Funado', 'Ratio', 'Basado', 'Cringe', 'Red Flag', 'NPC', 
      'Main Character', 'Delulu', 'Gaslighting', 'Gatekeeping', 
      'POV', 'Lore', 'Fandom', 'Shippeo', 'Meme', 'Clickbait', 
      'Spoiler', 'Beef', 'Zasca', 'Modo Diablo', 'La Queso', 'Fomo',
      'Sigma Male', 'Doomscrolling', 'Touch Grass', 'Skill Issue'
    ],
    
    // --- RELACIONES & FIESTA ---
    'Relaciones (+18 soft)': [
      'Casi Algo', 'Situationship', 'Ghosting', 'Love Bombing', 'Tinder', 
      'Bumble', 'Match', 'Friendzone', 'Sugar Daddy', 'Ick', 
      'Body Count', 'OnlyFans', 'Nudes', 'Sexting', 'Ex tóxico', 
      'Contacto Cero', 'Responsabilidad Afectiva', 'Poliamor', 'Date',
      'Pet Names', 'Enemigos a amantes', 'Rebound', 'Breadcrumbing'
    ],
    'Fiesta & Noche': [
      'Jagger', 'Vaper', 'Resaca', 'After', 'Barra Libre', 
      'Segurata', 'Zona VIP', 'Chupito', 'Yo nunca', 'Precopa', 
      'Perreo', 'Rave', 'Techno', 'Festival', 'Pulsera', 
      'Uber', 'Kebab', 'Cierre de Boliche', 'Happy Hour',
      'Botellón', 'Garrafón', 'Sala de fumadores', 'Warm Up'
    ],

    // --- TEMÁTICAS ESPECIALES ---
    'Famosos & Hollywood': [
      'Zendaya', 'Timothée Chalamet', 'Pedro Pascal', 'Jenna Ortega', 
      'Tom Holland', 'Leonardo DiCaprio', 'Margot Robbie', 'Ryan Gosling',
      'The Rock', 'Will Smith', 'Johnny Depp', 'Angelina Jolie', 
      'Brad Pitt', 'Kylie Jenner', 'Kim Kardashian', 'Harry Styles'
    ],
    'Fútbol & Leyendas': [
      'Messi', 'Cristiano Ronaldo', 'Mbappé', 'Haaland', 'Neymar',
      'Vinicius Jr', 'Lewandowski', 'Balón de Oro', 'Champions League',
      'Mundial', 'Fuera de Juego', 'VAR', 'Penalti', 'Tarjeta Roja',
      'El Clásico', 'Chilena', 'Portero', 'Árbitro comprado', 'Hooligan'
    ],
    'Políticos & Salseo': [
      'Pedro Sánchez', 'Feijóo', 'Ayuso', 'Trump', 'Biden', 'Putin',
      'Zelenski', 'Rey Felipe', 'Reina Letizia', 'Perro Sanxe', 
      'El Coletas', 'Moción de Censura', 'Elecciones', 'Urnas', 'Ministro'
    ],
    'Moda & Ropa Íntima': [
      'Tanga', 'Boxer', 'Lencería de encaje', 'Sujetador Push-up', 'Corsé',
      'Calcetines con sandalias', 'Crop Top', 'Oversize', 'Pitillos',
      'Chándal de táctel', 'Tacones de aguja', 'Bikini', 'Bañador slip',
      'Pijama de abuela', 'Calzoncillos de la suerte', 'Picardías'
    ],
    'Insultos & Expresiones': [
      'Bocachancla', 'Pagafantas', 'Pringado', 'Fantasma', 'Flipado',
      'Cuñado', 'Calzonazos', 'Vividor', 'Lameculos', 'Cuerneador',
      'Aguafiestas', 'Bienqueda', 'Listillo', 'Marrullero', 'Sieso'
    ],

    // --- ESTILO DE VIDA & HOBBIES (Fusionados) ---
    'Deportes & Gym': [
      'Crossfit', 'Burpee', 'Agujetas', 'Proteína', 'Creatina',
      'Press Banca', 'Sentadilla', 'Yoga', 'Pilates', 'Padel',
      'Tenis', 'Baloncesto', 'Natación', 'Formula 1', 'MotoGP',
      'Dopaje', 'Maratón', 'Ironman', 'PR (Personal Record)', 'Spotter',
      'Día de pierna', 'Pre-entreno', 'Calistenia', 'Peso muerto'
    ],
    'Videojuegos & Streaming': [
      'Lag', 'Ping alto', 'Camper', 'Tryhard', 'Streamer', 'Skin legendaria',
      'Battle Pass', 'Meta roto', 'Game Over', 'NPC glitch', 
      'Loot', 'Speedrun', 'Coop', 'Noob', 'Pro Player', 
      'Ragequit', 'Servidor caído', 'Chat tóxico', 'OP', 'Clutch',
      'Buff', 'Nerf', 'DLC'
    ],
    'Comida & Planes': [
      'Brunch', 'Poké Bowl', 'Comida fit', 'Cheat Meal', 'Delivery', 'Glovo', 
      'Café aesthetic', 'Smash Burger', 'Food Porn', 'Merendola', 'Tupper de mamá',
      'Pizza del domingo', 'Menú del día', 'Postre obligatorio', 'Tarta Lotus', 
      'Mesa compartida', 'Mojito sin alcohol', 'Buffet libre'
    ],
    'Vida Diaria & Random': [
      'Tarjeta Denegada', 'Batería 1%', 'Modo Avión', 'Grupo WhatsApp', 
      'Audio Infinito', 'Sticker', 'Bizum', 'Llegar Tarde', 
      'Visto', 'Llamada Perdida', 'Hacer la croqueta', 'No hay wifi',
      'GPS fallando', 'Mini-infarto bancario', 'Móvil en la cara',
      'Despertarse antes de la alarma', 'Ascensor ocupado'
    ],
    'Cultura Pop': [
      'Ibai', 'Kings League', 'La Velada', 'Taylor Swift', 'Motomami', 
      'Bizarrap', 'Inteligencia Artificial', 'Crypto', 'Gymbro', 'Aesthetic', 
      'Coquette', 'Milipili', 'Trap', 'Reggaeton', 'Horóscopo',
      'Shakira Session', 'Met Gala', 'Barbiecore', 'Oppenheimer Vibes'
    ],

    // --- ACADÉMICO & PRO ---
    'Universidad & Estudiante': [
      'Trabajo en grupo', 'Copiar en el examen', 'Apuntes prestados', 'Clase online',
      'PDF de 200 páginas', 'Estudiar la noche antes', 'Aula fría', 'Aula caliente',
      'Biblio', 'Moodle', 'Ansiedad pre-examen', 'Parcial sorpresa',
      'Suspenso colectivo', 'Examen tipo test', 'Semana de recuperación',
      'Memorizar a muerte', 'Trabajo final', 'Profe borde'
    ],
    'Ingeniería de Datos & IA': [
      'Overfitting', 'Underfitting', 'Gradiente Descendente', 'Backpropagation',
      'KNN', 'Árboles de Decisión', 'Random Forest', 'Curva ROC', 
      'Train/Test Split', 'One-Hot Encoding', 'Batch Size', 'Estimador insesgado',
      'p-valor', 'Hipótesis Nula', 'Distribución Normal', 'ARIMA', 
      'Spark', 'Hadoop', 'Kubernetes', 'Docker', 'SQL', 'NoSQL', 'JOIN',
      'K-Means', 'Entropía', 'Microservicios', 'APIs'
    ],
  };

  // Método para filtrar categorías
  static List<String> getWordsForCategories(Set<String> selectedCategories) {
    List<String> all = [];
    categories.forEach((key, list) {
      if (selectedCategories.contains(key)) {
        all.addAll(list);
      }
    });
    return all;
  }
}

// ==========================================
// PANTALLA 1: CONFIGURACIÓN (HOME)
// ==========================================
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  double _players = 5;
  double _impostors = 1;
  
  // Estado para las categorías seleccionadas (todas activas por defecto)
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.from(WordDatabase.categories.keys);
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

    final validWords = WordDatabase.getWordsForCategories(_selectedCategories);
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
                          "CONFIGURACIÓN",
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
                        "CATEGORÍAS",
                        style: TextStyle(color: Colors.white70, letterSpacing: 1.5, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      
                      // Selector de Categorías (Chips)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: WordDatabase.categories.keys.map((category) {
                          final isSelected = _selectedCategories.contains(category);
                          return GestureDetector(
                            onTap: () => _toggleCategory(category),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF6366F1).withValues(alpha: 0.3) 
                                    : Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected 
                                      ? const Color(0xFF6366F1) 
                                      : Colors.white.withValues(alpha: 0.1),
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
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white60,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
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