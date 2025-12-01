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

// Fondo con gradiente elegante
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

// Tarjeta estilo "Cristal" (Glassmorphism)
class GlassCard extends StatelessWidget {
  final Widget child;
  final double padding;
  
  const GlassCard({super.key, required this.child, this.padding = 20.0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
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
// BASE DE DATOS DE PALABRAS (EXPANDIDA)
// ==========================================
class WordDatabase {
  static final Map<String, List<String>> categories = {

    // ---------------------------------------------------------
    // 🔵 Redes & Postureo
    // ---------------------------------------------------------
    'Redes & Postureo': [
      // Originales
      'Story de Mejores Amigos', 'Shadowban', 'Blue Check (Verificado)', 'Hater', 
      'Troll', 'Reel', 'TikToker', 'Unfollow', 'Stalkear', 'Fake News', 
      'Filtro de Belleza', 'Influencer', 'Canje / Colaboración', 'Directo de Insta', 
      'Trending Topic', 'Algoritmo', 'Feed', 'Caption', 'Selfie en el espejo', 'DM (Direct Message)',
      // Nuevas
      'Viral', 'Postureo extremo', 'Link en la bio', 'Reel Loop', 'Spam',
      'Foto del gym', 'Close Friends', 'Ratio positivo', 'Cuenta Privada',
      'Cancelado', 'FYP (For You Page)', 'Comentario fijado', 'Highlights',
      'Face Reveal', 'Finsta',
      // Extras
      'Shadow Story', 'Quién vio tu perfil', 'Editar Recuerdos', 'Story Boomerang',
      'Mensaje eliminado', 'Pantallazo', 'Follow 4 Follow', 'Engagement'
    ],

    // ---------------------------------------------------------
    // 🟣 Jerga de Internet (Twitter/X)
    // ---------------------------------------------------------
    'Jerga de Internet (Twitter/X)': [
      // Originales
      'Funado', 'Ratio', 'Basado', 'Cringe', 'Red Flag', 'Green Flag', 
      'NPC', 'Main Character', 'Delulu', 'Gaslighting', 'Gatekeeping', 
      'POV', 'Lore', 'Fandom', 'Shippeo', 'Meme', 'Clickbait', 
      'Spoiler', 'Beef', 'Zasca', 'Modo Diablo', 'La Queso',
      // Nuevas
      'Sigma Male', 'Doomscrolling', 'Touch Grass', 'Overrated', 'Underrated',
      'Real', 'Cap', 'No Cap', 'Wholesome', 'Fanservice', 'Plot Twist',
      'Bait', 'Speedrun', 'Copium', 'Skill Issue',
      // Extras
      'NPC Walk', 'Bro Moment', 'Peak Fiction', 'Slay', 'It’s Giving',
      'You Fell Off', 'Shadow Realm', 'Maldito el que lo lea', 'Peak'
    ],

    // ---------------------------------------------------------
    // ❤️‍🔥 Ligoteo & Relaciones
    // ---------------------------------------------------------
    'Ligoteo & Relaciones (+18 soft)': [
      // Originales
      'Casi Algo', 'Situationship', 'Ghosting', 'Love Bombing', 'Tinder', 
      'Bumble', 'Grindr', 'Match', 'Friendzone', 'Sugar Daddy/Mommy', 
      'Golden Retriever Energy', 'Ick (El asco)', 'Body Count', 'OnlyFans', 
      'Nudes', 'Sexting', 'Stalker', 'Ex tóxico', 'Contacto Cero', 'Responsabilidad Afectiva',
      // Nuevas
      'Soft Launch', 'Hard Launch', 'Dry Texter', 'Pan sin sal', 'Chemistry',
      'Cita fallida', 'Pet Names', 'Enemigos a amantes', 'Rebound',
      'Hard Ghosting', 'Breadcrumbing', 'Casi-ex', 'Clingy',
      // Extras
      'Love Budget', 'Crush difícil', 'Mariposas', 'Tensión sexual no resuelta',
      'Date improvisada', 'DM sospechoso', 'Emoji del monito', 'Beso robado'
    ],

    // ---------------------------------------------------------
    // 🍾 Fiesta & Vicios
    // ---------------------------------------------------------
    'Fiesta & Vicios': [
      // Originales
      'Jagger', 'Vaper', 'Resaca moral', 'After', 'Barra Libre', 
      'El Portero/Segurata', 'VIP', 'Chupito', 'Yo nunca', 'Precopa', 
      'Gorra de fiesta', 'Perreo', 'Rave', 'Techno', 'Festival', 
      'Pulsera del festi', 'Uber de vuelta', 'Kebab a las 5am', 'La última y nos vamos',
      // Nuevas
      'Botellón', 'Resacón', 'Garrafón', 'Sala de fumadores', 'Warm Up',
      'Lista para entrar', 'After Party', 'DJ random', 'Mojarse', 'Fiesta temática',
      'Modo Fiesta', 'El que desaparece', 'De tranquis raros',
      // Extras
      'Shot Challenge', 'Amigo perdido', 'Baño lleno', 'Selfie borroso', 
      'Confesiones de borracho', 'Beber agua obligatorio', 'Cigarrito social'
    ],

    // ---------------------------------------------------------
    // 🌟 Cultura Pop & Actualidad
    // ---------------------------------------------------------
    'Cultura Pop & Actualidad': [
      // Originales
      'Ibai', 'Kings League', 'La Velada', 'Taylor Swift', 'Motomami', 
      'Bizarrap', 'Inteligencia Artificial', 'Crypto Bro', 'Gymbro', 'Aesthetic', 
      'Coquette', 'Milipili', 'Cayetana', 'Trap', 'Reggaeton', 
      'Horóscopo', 'Mercurio Retrógrado', 'Terapia', 'Ansiedad Social',
      // Nuevas
      'Shakira Session', 'Met Gala', 'Viral Challenge', 'It Girl',
      'NPC Streamer', 'Cancel Culture', 'Filtro Wes Anderson',
      'Anime enjoyer', 'Boomer', 'Resubido por TikTok',
      // Extras
      'Barbiecore', 'Oppenheimer Vibes', 'Cine de autor',
      'Spotify Wrapped', 'Marvel Fan', 'Series del momento'
    ],

    // ---------------------------------------------------------
    // 🟡 Situaciones Random
    // ---------------------------------------------------------
    'Situaciones Random': [
      // Originales
      'Tarjeta Denegada', 'Batería al 1%', 'Modo Avión', 'Grupo de WhatsApp sin el pesado', 
      'Audio de 5 minutos', 'Sticker', 'Bizum', 'Pedir perdón', 
      'Llegar tarde', 'Dejar en visto', 'Llamada perdida', 'Hacer la croqueta',
      // Nuevas
      'Cola infinita', 'No hay wifi', 'GPS fallando', 'Mini-infarto bancario',
      'Móvil en la cara', 'Grabar sin querer', 'Despertarse antes de la alarma',
      'Ropa en la silla', 'Foto mala subida', 'Quedarse sin papel',
      'Ascensor ocupado',
      // Extras
      'Ducha sin agua caliente', 'Llaves perdidas', 'Corte de luz', 'Ventana abierta lloviendo',
      'Se cae la compra', 'Mancharte comiendo', 'Abrir mal un paquete'
    ],

    // ---------------------------------------------------------
    // 🧃 NUEVA: Comida & Planes
    // ---------------------------------------------------------
    'Comida & Planes': [
      'Brunch', 'Poké Bowl', 'Comida fit', 'Cheat Meal', 'Delivery', 'Glovo', 
      'Café aesthetic', 'Smash Burger', 'Food Porn', 'Merendola', 'Tupper de mamá',
      'Pizza del domingo', 'Menú del día', 'Postre obligatorio', 'Tarta Lotus', 
      'Mesa compartida', 'Mojito sin alcohol', 'Buffet libre', 'Restaurante nuevo',
      'Cena improvisada', 'Helado artesanal', 'Patatas deluxe'
    ],

    // ---------------------------------------------------------
    // 🤓 NUEVA: Universidad & Estudiante
    // ---------------------------------------------------------
    'Universidad & Estudiante': [
      'Trabajo en grupo', 'Copiar en el examen', 'Apuntes prestados', 'Clase online',
      'PDF de 200 páginas', 'Estudiar la noche antes', 'Aula fría', 'Aula caliente',
      'Biblio', 'Moodle', 'Ansiedad pre-examen', 'Parcial sorpresa',
      'Suspenso colectivo', 'Examen tipo test', 'Semana de recuperación',
      'Memorizar a muerte', 'Trabajo final', 'Profe borde', 'Tareas acumuladas',
      'Grupo sin aportar', 'Clase cancelada'
    ],

    // ---------------------------------------------------------
    // 👟 NUEVA: Gym & Fitness
    // ---------------------------------------------------------
    'Gym & Fitness': [
      'PR', 'Series al fallo', 'Spotter', 'Hip Thrust', 'Pump', 'RPE',
      'Día de pierna', 'Crossfit', 'Prote shake', 'Rutina full body',
      'Pre-entreno', 'Cinturón de powerlifting', 'Calistenia', 'Peso muerto',
      'Dead Hang', 'Sudar mucho', 'Gente grabando', 'Progreso lineal',
      'Fallo técnico', 'Máquina ocupada', 'Cardio infinito'
    ],

    // ---------------------------------------------------------
    // 🎮 NUEVA: Videojuegos & Streaming
    // ---------------------------------------------------------
    'Videojuegos & Streaming': [
      'Lag', 'Ping alto', 'Camper', 'Tryhard', 'Streamer', 'Skin legendaria',
      'Battle Pass', 'Meta roto', 'Game Over', 'NPC glitch', 
      'Loot', 'Speedrun', 'Coop', 'Noob', 'Pro Player', 
      'Ragequit', 'Servidor caído', 'Chat tóxico', 'OP', 'Clutch',
      'Buff', 'Nerf', 'DLC'
    ],

    // ---------------------------------------------------------
    // 🚗 NUEVA: Vida Cotidiana
    // ---------------------------------------------------------
    'Vida Cotidiana': [
      'Tráfico infernal', 'Bus lleno', 'Pedir turno', 'Super lleno',
      'Lavadora rota', 'Despertador fallando', 'Luz cara', 'Ruido del vecino',
      'Paquete retrasado', 'Dormir mal', 'Día gris', 'Tarde eterna',
      'Plan cancelado', 'Mucho calor', 'Mucho frío', 'Olor raro en casa',
      'Cita en el médico', 'Sacar al perro', 'Tarde de sofá', 'Fregar platos'
    ],
        // ---------------------------------------------------------
    // 🧠 Ingeniería de Datos & IA (Tu carrera universitaria)
    // ---------------------------------------------------------
    'Ingeniería de Datos & IA': [
      // Aprendizaje Automático
      'Overfitting', 'Underfitting', 'Regularización', 'Gradiente Descendente',
      'Backpropagation', 'KNN', 'SVM', 'Árboles de Decisión', 'Random Forest',
      'Curva ROC', 'Cross Validation', 'Train/Test Split', 'Feature Scaling',
      'One-Hot Encoding', 'Pérdida MSE', 'Learning Rate', 'Batch Size',

      // Inferencia Estadística
      'Estimador insesgado', 'Varianza mínima', 'Muestreo', 'MLE',
      'Intervalo de Confianza', 'p-valor', 'Hipótesis Nula', 'Test Z',
      'Test t', 'Error Tipo I', 'Error Tipo II', 'Distribución Normal',
      'Distribución Exponencial', 'Asintótico', 'Consistencia',

      // Series Temporales
      'ARIMA', 'Autocorrelación', 'Ruido blanco', 'Suavizado Exponencial',
      'Estacionalidad', 'Tendencia', 'Lag', 'Ventana deslizante',
      'Modelo predictivo', 'Forecast',

      // Big Data & Computación en la Nube
      'Spark', 'Hadoop', 'MapReduce', 'Cluster', 'Kubernetes', 'Docker',
      'Data Lake', 'ETL', 'Pipeline', 'Notebook', 'Databricks',
      'Paralelización', 'GPU Computing', 'Escalabilidad',

      // Bases de Datos
      'SQL', 'NoSQL', 'CRUD', 'Índices', 'JOIN', 'Sharding', 'Replicación',
      'Transacciones', 'Normalización', 'Esquema', 'MongoDB',
      'JSON Schema', 'XML Schema',

      // Probabilidad & Señales Aleatorias
      'Proceso Estocástico', 'Señal Determinista', 'Esperanza Matemática',
      'Varianza', 'Autocovarianza', 'Densidad Espectral', 'Ruido Gaussiano',
      'Ley de los Grandes Números', 'Teorema Central del Límite',

      // Programación para Big Data
      'Clustering', 'K-Means', 'EDA (Exploratory Data Analysis)',
      'Outliers', 'Data Cleaning', 'Visualización', 'Correlación',
      'Colinealidad', 'Regresión Lineal Múltiple',

      // Teoría de la Información
      'Entropía', 'Información Mutua', 'Canal de Comunicación',
      'Capacidad del Canal', 'Ruido', 'Codificación Óptima',

      // Ingeniería y Sistemas de Datos
      'Modelado de Datos', 'Arquitectura de Sistemas',
      'Escalado Horizontal', 'Latencia', 'Tolerancia a Fallos',
      'Monitorización', 'Logs', 'APIs', 'Microservicios',
      'Data Warehouse', 'Batch vs Streaming',

      // Extras de tu perfil
      'Práctica de laboratorio', 'Memoria del proyecto', 'Notebook Jupyter',
      'Datasets', 'Carga de trabajo', 'Optimizaciones'
    ],

  };


  static List<String> getAllWords() {
    List<String> all = [];
    categories.values.forEach((list) => all.addAll(list));
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

  void _startGame() {
    final allWords = WordDatabase.getAllWords();
    final randomWord = allWords[Random().nextInt(allWords.length)];

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  "EL IMPOSTOR",
                  style: TextStyle(
                    fontSize: 42, 
                    fontWeight: FontWeight.w900, 
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
                const Text(
                  "EDICIÓN DEFINITIVA",
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w300, 
                    color: Color(0xFF6366F1),
                    letterSpacing: 6,
                  ),
                ),
                const Spacer(),
                
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
                      Divider(color: Colors.white.withOpacity(0.1)),
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
                
                const Spacer(),

                // Botón Iniciar con estilo Gradient
                Container(
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
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
                const SizedBox(height: 20),
              ],
            ),
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
            inactiveTrackColor: accentColor.withOpacity(0.2),
            thumbColor: Colors.white,
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayColor: accentColor.withOpacity(0.2),
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
                        side: _isRevealed ? BorderSide(color: Colors.white.withOpacity(0.2)) : BorderSide.none,
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
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
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
              style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6), height: 1.5),
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
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.5)),
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
                  Shadow(color: color.withOpacity(0.6), blurRadius: 20)
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