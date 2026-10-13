import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------- Design tokens ----------
const ink = Color(0xFF0F2E35);
const teal = Color(0xFF1F5A60);
const gold = Color(0xFFE8A33D);
const goldDark = Color(0xFFB87A1B);
const paper = Color(0xFFF6F2EA);
const heroGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ink, teal]);
final cardDeco = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 6))],
);

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Ishwarya E-Portfolio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: ink, secondary: gold),
          scaffoldBackgroundColor: paper,
        ),
        home: const LoginPage(),
      );
}

// ---------- Data ----------
class Cert {
  final String title, issuer, asset;
  final IconData icon;
  final List<Color> colors;
  const Cert(this.title, this.issuer, this.asset, this.icon, this.colors);
}

const certs = [
  Cert('Internal Hackathon SIH 2025', 'Certificate of Appreciation | BVRIT Hyderabad', 'assets/certs/sih.png', Icons.emoji_events, [Color(0xFF0F2E35), Color(0xFF2D8A8F)]),
  Cert('Java (Basic)', 'HackerRank | 21 Oct 2025', 'assets/certs/hr_java.png', Icons.code, [Color(0xFF3B2A6B), Color(0xFF7B5CD6)]),
  Cert('OOP Through Java', 'CodeChef | 31 Oct 2025', 'assets/certs/codechef_oops.png', Icons.school, [Color(0xFF7F1D3A), Color(0xFFE0577E)]),
  Cert('Data Structures (CS302PC)', 'CodeChef | 28 Nov 2025', 'assets/certs/codechef_ds.png', Icons.account_tree, [Color(0xFF14532D), Color(0xFF3FAE6A)]),
  Cert('Front End Web Developer', 'Infosys Springboard | 27 Feb 2026', 'assets/certs/infosys.png', Icons.web, [Color(0xFF123B6B), Color(0xFF3F8EE0)]),
  Cert('Cyber Job Simulation', 'Deloitte (via Forage) | 30 Jun 2026', 'assets/certs/deloitte.png', Icons.security, [Color(0xFF1B4332), Color(0xFF86BC25)]),
  Cert('Crafting Precision Prompts with Generative AI', 'Course certificate', 'assets/certs/gen_ai_prompts.png', Icons.auto_awesome, [Color(0xFF5B2A86), Color(0xFFC471ED)]),
];

// ---------- Shared widgets ----------
Widget blob(double s, Color c) =>
    Container(width: s, height: s, decoration: BoxDecoration(shape: BoxShape.circle, color: c));

InputDecoration deco(String l, IconData i, {Widget? suffix}) => InputDecoration(
      labelText: l,
      prefixIcon: Icon(i),
      suffixIcon: suffix,
      filled: true,
      fillColor: paper,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    );

class Reveal extends StatelessWidget {
  final int i;
  final Widget child;
  const Reveal(this.i, this.child, {super.key});
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 450 + (i > 6 ? 6 : i) * 80),
        curve: Curves.easeOutCubic,
        builder: (_, v, ch) =>
            Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 26 * (1 - v)), child: ch)),
        child: child,
      );
}

class Avatar extends StatelessWidget {
  final double size;
  const Avatar(this.size, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: gold, width: size * 0.035),
          boxShadow: [BoxShadow(color: gold.withValues(alpha: 0.35), blurRadius: 30, spreadRadius: 3)],
        ),
        child: ClipOval(
          child: Image.asset('assets/photo.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => Container(
                  color: gold,
                  alignment: Alignment.center,
                  child: Text('AI',
                      style: TextStyle(fontSize: size * 0.35, fontWeight: FontWeight.bold, color: ink)))),
        ),
      );
}

class Heading extends StatelessWidget {
  final String t;
  const Heading(this.t, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 12),
        child: Row(children: [
          Container(width: 5, height: 22, decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 10),
          Text(t, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink)),
        ]),
      );
}

class Tile extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final VoidCallback? onTap;
  const Tile(this.icon, this.title, this.sub, {this.onTap, super.key});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: cardDeco,
        child: ListTile(
          onTap: onTap,
          leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: ink)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(sub),
          trailing: onTap != null ? const Icon(Icons.copy, size: 16, color: Colors.black38) : null,
        ),
      );
}

class Tags extends StatelessWidget {
  final List<String> items;
  final bool dark;
  const Tags(this.items, {this.dark = false, super.key});
  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: [
        for (final s in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: dark ? Colors.white.withValues(alpha: 0.14) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: dark ? Colors.white24 : gold.withValues(alpha: 0.7)),
            ),
            child: Text(s, style: TextStyle(fontSize: 13, color: dark ? Colors.white : ink, fontWeight: FontWeight.w500)),
          ),
      ]);
}

class TimelineItem extends StatelessWidget {
  final String tag, title, sub;
  final bool last;
  const TimelineItem(this.tag, this.title, this.sub, {this.last = false, super.key});
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: 22,
            child: Column(children: [
              Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(color: gold, shape: BoxShape.circle, border: Border.all(color: ink, width: 3))),
              if (!last) Expanded(child: Container(width: 2, color: ink.withValues(alpha: 0.2))),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, bottom: last ? 0 : 18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tag, style: const TextStyle(color: goldDark, fontWeight: FontWeight.w700, fontSize: 13)),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                Text(sub, style: const TextStyle(color: Colors.black54)),
              ]),
            ),
          ),
        ]),
      );
}

class Stat extends StatelessWidget {
  final String v, l;
  const Stat(this.v, this.l, {super.key});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          CountText(v, const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: gold)),
          Text(l, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      );
}

// ---------- Interactive helpers ----------
void copyText(BuildContext c, String t) {
  Clipboard.setData(ClipboardData(text: t));
  ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('Copied: $t'), duration: const Duration(seconds: 2)));
}

Widget chevron(bool open, {Color color = ink}) => AnimatedRotation(
    turns: open ? 0.5 : 0, duration: const Duration(milliseconds: 300), child: Icon(Icons.expand_more, color: color));

class CountText extends StatelessWidget {
  final String v;
  final TextStyle style;
  const CountText(this.v, this.style, {super.key});
  @override
  Widget build(BuildContext context) {
    final m = RegExp(r'^([\d.]+)(.*)$').firstMatch(v);
    if (m == null) return Text(v, style: style);
    final n = double.parse(m[1]!);
    final dec = m[1]!.contains('.') ? m[1]!.split('.')[1].length : 0;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: n),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (_, x, __) => Text('${x.toStringAsFixed(dec)}${m[2]}', style: style),
    );
  }
}

class TypeLine extends StatefulWidget {
  const TypeLine({super.key});
  @override
  State<TypeLine> createState() => _TypeLineState();
}

class _TypeLineState extends State<TypeLine> {
  static const words = ['Java Developer', 'Android Developer', 'Hackathon Participant', 'CSI Member'];
  int w = 0, c = 0, hold = 0;
  bool del = false;
  Timer? t;
  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(milliseconds: 90), (_) {
      setState(() {
        if (!del) {
          if (c < words[w].length) {
            c++;
          } else if (++hold > 14) {
            del = true;
            hold = 0;
          }
        } else if (c > 0) {
          c--;
        } else {
          del = false;
          w = (w + 1) % words.length;
        }
      });
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text('${words[w].substring(0, c)}|',
      style: const TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.w700));
}

Widget page(List<Widget> c) => Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
          children: [for (var i = 0; i < c.length; i++) Reveal(i, c[i])],
        ),
      ),
    );

// ---------- Page 1: Login ----------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(text: '24wh1a0581@bvrithyderabad.edu.in');
  final _pass = TextEditingController();
  bool _hide = true;

  void _login() {
    if (!_form.currentState!.validate()) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const Dashboard(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(
          opacity: a,
          child: ScaleTransition(scale: Tween(begin: 0.94, end: 1.0).animate(a), child: child),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: heroGradient),
        child: Stack(children: [
          Positioned(top: -70, right: -50, child: blob(230, gold.withValues(alpha: 0.18))),
          Positioned(bottom: -100, left: -70, child: blob(280, Colors.white.withValues(alpha: 0.06))),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Reveal(0, const Avatar(150)),
                    const SizedBox(height: 20),
                    Reveal(1, const Text('Alluri Ishwarya',
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 0.4))),
                    const SizedBox(height: 4),
                    Reveal(2, const Text('B.Tech CSE | BVRIT Hyderabad', style: TextStyle(color: Colors.white70))),
                    const SizedBox(height: 12),
                    Reveal(3, const TypeLine()),
                    const SizedBox(height: 10),
                    Reveal(3, const Tags(['Java', 'Android', 'Python', 'CSI Member'], dark: true)),
                    const SizedBox(height: 28),
                    Reveal(
                      4,
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 40, offset: Offset(0, 18))],
                        ),
                        child: Form(
                          key: _form,
                          child: Column(children: [
                            const Text('Welcome', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ink)),
                            const Text('Sign in to view my portfolio', style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _email,
                              decoration: deco('College email', Icons.mail_outline),
                              validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _pass,
                              obscureText: _hide,
                              decoration: deco('Password', Icons.lock_outline,
                                  suffix: IconButton(
                                      icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () => setState(() => _hide = !_hide))),
                              validator: (v) => (v == null || v.length < 4) ? 'Use at least 4 characters' : null,
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                    backgroundColor: gold,
                                    foregroundColor: ink,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                onPressed: _login,
                                child: const Text('Open my portfolio',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Demo: any password with 4+ characters',
                                style: TextStyle(color: Colors.black45, fontSize: 12)),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ---------- Page 2: Dashboard ----------
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _i = 0;
  static const _titles = ['About me', 'Skills', 'Projects', 'Achievements', 'Certificates'];
  final _pages = const [AboutTab(), SkillsTab(), ProjectsTab(), AchievementsTab(), CertificatesTab()];

  void _contact() => showModalBottomSheet(
        context: context,
        backgroundColor: paper,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Heading('Get in touch (tap to copy)'),
            Tile(Icons.mail_outline, '24wh1a0581@bvrithyderabad.edu.in', 'Email',
                onTap: () => copyText(context, '24wh1a0581@bvrithyderabad.edu.in')),
            Tile(Icons.phone_outlined, '9347589500', 'Phone', onTap: () => copyText(context, '9347589500')),
            Tile(Icons.link, 'github.com/Ishu-81', 'GitHub', onTap: () => copyText(context, 'https://github.com/Ishu-81')),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: heroGradient, borderRadius: BorderRadius.vertical(bottom: Radius.circular(28))),
          padding: EdgeInsets.fromLTRB(18, MediaQuery.of(context).padding.top + 12, 8, 18),
          child: Row(children: [
            const Avatar(48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Hi, I am Ishwarya', style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text(_titles[_i], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              ]),
            ),
            IconButton(
              tooltip: 'Log out',
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
            ),
          ]),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: KeyedSubtree(key: ValueKey(_i), child: _pages[_i]),
          ),
        ),
      ]),
      floatingActionButton: _i == 4
          ? null
          : FloatingActionButton.extended(
              backgroundColor: gold,
              foregroundColor: ink,
              onPressed: _contact,
              icon: const Icon(Icons.mail_outline),
              label: const Text('Contact', style: TextStyle(fontWeight: FontWeight.w800))),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        backgroundColor: Colors.white,
        indicatorColor: gold.withValues(alpha: 0.4),
        onDestinationSelected: (v) => setState(() => _i = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'About'),
          NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: 'Skills'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.star_outline), selectedIcon: Icon(Icons.star), label: 'Awards'),
          NavigationDestination(icon: Icon(Icons.workspace_premium_outlined), selectedIcon: Icon(Icons.workspace_premium), label: 'Certs'),
        ],
      ),
    );
  }
}

// ---------- Tab 1: About ----------
class AboutTab extends StatelessWidget {
  const AboutTab({super.key});
  void _copy(BuildContext c, String t) {
    Clipboard.setData(ClipboardData(text: t));
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('Copied: $t'), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) => page([
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: heroGradient, borderRadius: BorderRadius.circular(24)),
          child: Column(children: [
            Row(children: const [
              Avatar(84),
              SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Alluri Ishwarya', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('CSE student | Java and Android developer', style: TextStyle(color: Colors.white70)),
                ]),
              ),
            ]),
            const SizedBox(height: 18),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
            const Row(children: [Stat('9.20', 'CGPA'), Stat('3', 'Projects'), Stat('7', 'Certificates'), Stat('CSI', 'Member')]),
          ]),
        ),
        const Heading('About me'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardDeco,
          child: const Text(
            'Computer Science and Engineering student with strong foundations in Java, Data Structures & Algorithms, '
            'OOP, DBMS and SQL. Experienced in building applications with Java, Python, Android, web technologies and '
            'databases, with hands-on hackathon and research projects.',
            style: TextStyle(height: 1.55),
          ),
        ),
        const Heading('Education'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardDeco,
          child: const Column(children: [
            TimelineItem('2024 - 2028 | CGPA 9.20', 'B.Tech, BVRIT Hyderabad', 'College of Engineering for Women'),
            TimelineItem('2022 - 2024 | 96%', 'Intermediate (TSBIE)', 'KGBV Junior College, Kaghaznagar'),
            TimelineItem('2021 - 2022 | 97%', 'SSC (BSE)', 'Kasturba Gandhi Balika Vidyalaya', last: true),
          ]),
        ),
        const Heading('Contact (tap to copy)'),
        Tile(Icons.mail_outline, '24wh1a0581@bvrithyderabad.edu.in', 'Email', onTap: () => _copy(context, '24wh1a0581@bvrithyderabad.edu.in')),
        Tile(Icons.phone_outlined, '9347589500', 'Phone', onTap: () => _copy(context, '9347589500')),
        Tile(Icons.link, 'github.com/Ishu-81', 'GitHub', onTap: () => _copy(context, 'https://github.com/Ishu-81')),
      ]);
}

// ---------- Tab 2: Skills ----------
class SkillsTab extends StatelessWidget {
  const SkillsTab({super.key});
  static const groups = [
    (Icons.code, 'Programming languages', ['Java', 'C', 'Python', 'SQL', 'Dart']),
    (Icons.handyman_outlined, 'Tools & platforms', ['Git', 'GitHub', 'VS Code', 'Android Studio', 'Tableau', 'Power BI', 'Docker', 'Linux']),
    (Icons.web, 'Web development', ['HTML', 'CSS', 'JavaScript (ES6)', 'REST APIs (basic)']),
    (Icons.memory, 'Core CS', ['DSA', 'OOP', 'DBMS', 'Operating Systems', 'Computer Networks']),
  ];
  @override
  Widget build(BuildContext context) => page([
        for (final g in groups)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: cardDeco,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(g.$1, color: goldDark),
                const SizedBox(width: 8),
                Text(g.$2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: ink)),
              ]),
              const SizedBox(height: 12),
              Tags(g.$3),
            ]),
          ),
      ]);
}

// ---------- Expandable card (tap to open) ----------
class Expandable extends StatefulWidget {
  final Widget Function(bool open) header;
  final Widget body;
  const Expandable({required this.header, required this.body, super.key});
  @override
  State<Expandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  bool _open = false;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: cardDeco,
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              widget.header(_open),
              AnimatedSize(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: _open ? widget.body : const SizedBox(width: double.infinity),
              ),
            ]),
          ),
        ),
      );
}

// ---------- Tab 3: Projects (tap a card for details) ----------
class ProjectCard extends StatelessWidget {
  final IconData icon;
  final String label, title, desc;
  final List<String> points, tags;
  const ProjectCard(this.icon, this.label, this.title, this.desc, this.points, this.tags, {super.key});
  @override
  Widget build(BuildContext context) => Expandable(
        header: (open) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(gradient: heroGradient),
            child: Row(children: [
              CircleAvatar(backgroundColor: gold, child: Icon(icon, color: ink)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(label, style: const TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.w700)),
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                ]),
              ),
              chevron(open, color: Colors.white),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(16), child: Text(desc, style: const TextStyle(height: 1.5))),
        ]),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final p in points)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.check_circle, size: 18, color: goldDark),
                  const SizedBox(width: 8),
                  Expanded(child: Text(p)),
                ]),
              ),
            const SizedBox(height: 6),
            Tags(tags),
          ]),
        ),
      );
}

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});
  @override
  Widget build(BuildContext context) => page(const [
        ProjectCard(Icons.notifications_active, 'REAL-TIME RESEARCH PROJECT', 'AI Faculty Reminder App',
            'Faculty schedule app with real-time reminders. Tap for details.',
            ['CRUD operations for schedules', 'Real-time notifications', 'Timetable conflict detection'],
            ['Java', 'Android Studio', 'XML', 'Firebase/MySQL']),
        ProjectCard(Icons.face, 'SIH HACKATHON PROJECT', 'Automated Attendance System',
            'Smart attendance for rural schools using face recognition. Tap for details.',
            ['Face recognition with OpenCV', 'Works offline', 'Cost-effective for rural schools', 'Built for Smart India Hackathon'],
            ['Python', 'OpenCV', 'Face Recognition']),
        ProjectCard(Icons.grid_on, 'PYTHON PROJECT', 'Sudoku Game',
            'Interactive Sudoku with an automatic solver. Tap for details.',
            ['Puzzle validation', 'Automated backtracking solver', 'Modular, user-friendly GUI'],
            ['Python', 'NumPy', 'Tkinter/Pygame']),
      ]);
}

// ---------- Extra-curricular widgets ----------
class ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title, sub, desc;
  final List<String> tags;
  const ActivityCard(this.icon, this.title, this.sub, this.desc, this.tags, {super.key});
  @override
  Widget build(BuildContext context) => Expandable(
        header: (open) => Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [gold, Color(0xFFF2C066)]),
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: ink, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: ink)),
                Text(sub, style: const TextStyle(color: Colors.black54)),
              ]),
            ),
            chevron(open),
          ]),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(desc, style: const TextStyle(height: 1.45)),
            const SizedBox(height: 10),
            Tags(tags),
          ]),
        ),
      );
}

class CsiBadge extends StatelessWidget {
  const CsiBadge({super.key});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: heroGradient,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: gold, width: 1.5),
          boxShadow: [BoxShadow(color: gold.withValues(alpha: 0.3), blurRadius: 22, offset: const Offset(0, 8))],
        ),
        child: Row(children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: gold),
            alignment: Alignment.center,
            child: const Text('CSI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: ink)),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CSI Member', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
              Text('Computer Society of India', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Tags(['Member', 'Technical community'], dark: true),
            ]),
          ),
        ]),
      );
}

// ---------- Tab 4: Achievements ----------
class AchievementsTab extends StatelessWidget {
  const AchievementsTab({super.key});
  Widget big(String v, String l) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(gradient: heroGradient, borderRadius: BorderRadius.circular(18)),
          child: Column(children: [
            CountText(v, const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: gold)),
            Text(l, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
      );
  @override
  Widget build(BuildContext context) => page([
        const Heading('Academic achievements'),
        Row(children: [big('9.20', 'B.Tech CGPA'), big('96%', 'Intermediate'), big('97%', 'SSC')]),
        const Heading('Extra-curricular (tap to expand)'),
        const CsiBadge(),
        const ActivityCard(Icons.emoji_events, 'Hackathons', 'Smart India Hackathon 2025',
            'Participated in the Internal Smart India Hackathon (SIH 2025) at BVRIT Hyderabad on 16-17 September 2025 and received a certificate of appreciation. Project: an automated attendance system for rural schools.',
            ['SIH 2025', 'Teamwork', 'Problem solving']),
        const ActivityCard(Icons.terminal, 'Coding contests', 'HackerRank and CodeChef',
            'Take part in coding contests and practise on HackerRank and CodeChef to improve data structures, algorithms and problem-solving speed.',
            ['HackerRank', 'CodeChef', 'DSA']),
        const ActivityCard(Icons.computer, 'Technical events', 'Workshops and competitions',
            'Participate in technical events, workshops and competitions to learn new technologies and apply them in practice.',
            ['Workshops', 'Competitions', 'Learning']),
        const ActivityCard(Icons.volunteer_activism, 'Student volunteering', 'Campus events and activities',
            'Volunteer in student activities and college events, helping with organisation and coordination.',
            ['Volunteering', 'Leadership', 'Coordination']),
      ]);
}

// ---------- Tab 5: Certificates "video" reel ----------
class CertificatesTab extends StatefulWidget {
  const CertificatesTab({super.key});
  @override
  State<CertificatesTab> createState() => _CertificatesTabState();
}

class _CertificatesTabState extends State<CertificatesTab> with SingleTickerProviderStateMixin {
  static const slide = Duration(seconds: 4);
  final _pc = PageController(viewportFraction: 0.86);
  late final AnimationController _bar = AnimationController(vsync: this, duration: slide);
  Timer? _t;
  int _cur = 0;
  bool _playing = true;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _t?.cancel();
    _bar.forward(from: 0);
    _t = Timer.periodic(slide, (_) => _go((_cur + 1) % certs.length));
  }

  void _go(int i) => _pc.animateToPage(i, duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic);

  void _toggle() {
    setState(() => _playing = !_playing);
    if (_playing) {
      _start();
    } else {
      _t?.cancel();
      _bar.stop();
    }
  }

  @override
  void dispose() {
    _t?.cancel();
    _bar.dispose();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = certs.length;
    return Column(children: [
      const SizedBox(height: 14),
      Expanded(
        child: PageView.builder(
          controller: _pc,
          itemCount: n,
          onPageChanged: (i) {
            setState(() => _cur = i);
            if (_playing) _start();
          },
          itemBuilder: (_, i) => AnimatedBuilder(
            animation: _pc,
            builder: (_, child) {
              double d = i == 0 ? 1 : 0.85;
              if (_pc.hasClients && _pc.position.haveDimensions) {
                d = (1 - ((_pc.page ?? 0) - i).abs() * 0.15).clamp(0.85, 1.0);
              }
              return Center(child: Transform.scale(scale: d, child: Opacity(opacity: d * d, child: child)));
            },
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(16),
                  child: InteractiveViewer(child: SizedBox(height: 460, child: _CertCard(certs[i], i, true))),
                ),
              ),
              child: _CertCard(certs[i], i, i == _cur),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        child: AnimatedBuilder(
          animation: _bar,
          builder: (_, __) => ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: _bar.value, color: gold, backgroundColor: Colors.black12, minHeight: 5),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: () => _go((_cur - 1 + n) % n), icon: const Icon(Icons.skip_previous_rounded, size: 30)),
          const SizedBox(width: 8),
          IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: ink, fixedSize: const Size(56, 56)),
              onPressed: _toggle,
              icon: Icon(_playing ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 30)),
          const SizedBox(width: 8),
          IconButton(onPressed: () => _go((_cur + 1) % n), icon: const Icon(Icons.skip_next_rounded, size: 30)),
        ]),
      ),
    ]);
  }
}

class _CertCard extends StatelessWidget {
  final Cert c;
  final int index;
  final bool active;
  const _CertCard(this.c, this.index, this.active);
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: c.colors),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: c.colors.last.withValues(alpha: 0.45), blurRadius: 26, offset: const Offset(0, 14))],
        ),
        child: Column(children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
              child: Text('${(index + 1).toString().padLeft(2, '0')} / ${certs.length.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            const Icon(Icons.zoom_out_map, color: Colors.white70, size: 20),
          ]),
          const SizedBox(height: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                color: Colors.white,
                // Certificate images live in assets/certs/. A missing file shows an animated icon instead.
                child: Image.asset(c.asset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                          color: c.colors.first,
                          child: Center(
                            child: TweenAnimationBuilder<double>(
                              key: ValueKey(active),
                              tween: Tween(begin: 0.5, end: 1),
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.elasticOut,
                              builder: (_, v, __) => Transform.scale(scale: v, child: Icon(c.icon, size: 84, color: Colors.white)),
                            ),
                          ),
                        )),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(c.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(c.issuer, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ]),
      );
}
