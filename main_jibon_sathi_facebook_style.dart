import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const JibonSathiApp());
}

class JibonSathiApp extends StatelessWidget {
  const JibonSathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jibon Sathi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1877F2),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  String profileName = 'Jibon';
  String profileBio = 'Jibon Sathi-তে আমার সাথে যুক্ত থাকুন';
  String? profileImagePath;

  String? selectedStoryImage;
  final List<String> comments = [];

  final List<Map<String, String>> stories = [
    {'name': 'রাহুল', 'initial': 'র'},
    {'name': 'সুমন', 'initial': 'স'},
    {'name': 'রিয়া', 'initial': 'র'},
    {'name': 'পূজা', 'initial': 'প'},
    {'name': 'অমিত', 'initial': 'অ'},
  ];

  final List<Map<String, dynamic>> posts = [
    {
      'name': 'Jibon',
      'time': '5 মিনিট আগে',
      'text': 'Jibon Sathi-তে সবাইকে স্বাগতম! ❤️',
      'likes': 24,
      'comments': 5,
      'liked': false,
    },
    {
      'name': 'Rahul',
      'time': '32 মিনিট আগে',
      'text': 'আজকের সুন্দর মুহূর্তটি আপনাদের সাথে শেয়ার করলাম। 🌿',
      'likes': 51,
      'comments': 12,
      'liked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _topBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          _homeFeed(),
          _friendsPage(),
          _videoPage(),
          _notificationsPage(),
          _profilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Friends',
          ),
          NavigationDestination(
            icon: Icon(Icons.ondemand_video_outlined),
            selectedIcon: Icon(Icons.ondemand_video),
            label: 'Video',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _topBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: const Text(
        'Jibon Sathi',
        style: TextStyle(
          color: Color(0xFF1877F2),
          fontSize: 25,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        _roundAction(
          Icons.search,
          () => showSearch(
            context: context,
            delegate: JibonSearchDelegate(
              [
                profileName,
                'Rahul',
                'রাহুল',
                'সুমন',
                'রিয়া',
                'পূজা',
                'অমিত',
              ],
            ),
          ),
        ),
        _roundAction(
          Icons.add,
          _showCreateMenu,
        ),
        _roundAction(
          Icons.chat_bubble_outline,
          _showMessage,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _roundAction(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: CircleAvatar(
        radius: 19,
        backgroundColor: const Color(0xFFE4E6EB),
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          icon: Icon(icon, size: 21, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _homeFeed() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {});
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: 18),
        children: [
          _createPostBox(),
          _storiesSection(),
          const SizedBox(height: 8),
          ...posts.asMap().entries.map(
                (entry) => _postCard(entry.key, entry.value),
              ),
        ],
      ),
    );
  }

  Widget _createPostBox() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              _profileAvatar(radius: 22),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _createTextPost,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      'আপনার মনের কথা কী?',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 22),
          Row(
            children: [
              Expanded(
                child: _createAction(
                  Icons.video_call,
                  'Live',
                  Colors.red,
                  _showMessage,
                ),
              ),
              Expanded(
                child: _createAction(
                  Icons.photo_library,
                  'Photo',
                  Colors.green,
                  _pickPhoto,
                ),
              ),
              Expanded(
                child: _createAction(
                  Icons.video_library,
                  'Video',
                  Colors.deepPurple,
                  _pickVideo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storiesSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      child: SizedBox(
        height: 190,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _createStoryCard(),
            ...stories.map(
              (story) => _storyCard(
                story['name']!,
                story['initial']!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createStoryCard() {
    return Container(
      width: 112,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFE4E6EB),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: _profileImagePath != null
                ? Image.file(
                    File(_profileImagePath!),
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF8AB4F8),
                          Color(0xFF1877F2),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 55,
                      color: Colors.white,
                    ),
                  ),
          ),
          Positioned(
            left: 8,
            top: 8,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.add,
                color: Color(0xFF1877F2),
              ),
            ),
          ),
          Positioned(
            left: 9,
            right: 9,
            bottom: 10,
            child: const Text(
              'Create Story',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _storyCard(String name, String initial) {
    return InkWell(
      onTap: () => _showStory(name, initial),
      child: Container(
        width: 112,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E60CE),
              Color(0xFF252525),
            ],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            const Positioned.fill(
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.white24,
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF1877F2),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 9,
              right: 9,
              bottom: 10,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black87,
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

  Widget _postCard(int index, Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(14, 6, 8, 0),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1877F2),
              child: Text(
                post['name'].toString()[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              post['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Text(post['time']),
                const SizedBox(width: 5),
                const Icon(Icons.public, size: 13),
              ],
            ),
            trailing: IconButton(
              onPressed: () => _showPostMenu(index),
              icon: const Icon(Icons.more_horiz),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Text(
              post['text'],
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (post['image'] != null)
            Image.file(
              File(post['image']),
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            )
          else
            Container(
              height: 230,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE8F0FE),
                    Color(0xFFDDE7FF),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 72,
                  color: Color(0xFF1877F2),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 9, 14, 5),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 9,
                  backgroundColor: Color(0xFF1877F2),
                  child: Icon(
                    Icons.thumb_up,
                    size: 11,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Text('${post['likes']}'),
                const Spacer(),
                Text('${post['comments']} comments'),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: _postButton(
                  post['liked'] == true
                      ? Icons.thumb_up
                      : Icons.thumb_up_outlined,
                  'Like',
                  post['liked'] == true
                      ? const Color(0xFF1877F2)
                      : Colors.black54,
                  () {
                    setState(() {
                      post['liked'] = !(post['liked'] == true);
                      post['likes'] += post['liked'] == true ? 1 : -1;
                    });
                  },
                ),
              ),
              Expanded(
                child: _postButton(
                  Icons.comment_outlined,
                  'Comment',
                  Colors.black54,
                  () => _showComment(index),
                ),
              ),
              Expanded(
                child: _postButton(
                  Icons.share_outlined,
                  'Share',
                  Colors.black54,
                  () => _sharePost(post['text'].toString()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _postButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 21, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileAvatar({double radius = 22}) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: profileImagePath != null
          ? FileImage(File(profileImagePath!))
          : null,
      backgroundColor: const Color(0xFF1877F2),
      child: profileImagePath == null
          ? Icon(
              Icons.person,
              color: Colors.white,
              size: radius,
            )
          : null,
    );
  }

  Widget _friendsPage() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'Friends',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...stories.map(
          (story) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1877F2),
                child: Text(
                  story['initial']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(story['name']!),
              subtitle: const Text('আপনার পরিচিত'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend request sent')),
                  );
                },
                child: const Text('Add'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _videoPage() {
    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(14, 14, 14, 8),
          child: Text(
            'Videos & Reels',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...posts.map(
          (post) => Card(
            margin: const EdgeInsets.fromLTRB(10, 4, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1877F2),
                    child: Text(
                      post['name'].toString()[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    post['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.black,
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 82,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(post['text']),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _notificationsPage() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _notificationTile(
          Icons.thumb_up,
          'Rahul আপনার পোস্টে Like দিয়েছেন',
        ),
        _notificationTile(
          Icons.person_add,
          'সুমন আপনাকে Friend request পাঠিয়েছেন',
        ),
        _notificationTile(
          Icons.comment,
          'রিয়া আপনার পোস্টে Comment করেছেন',
        ),
      ],
    );
  }

  Widget _notificationTile(IconData icon, String text) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE7F0FF),
          child: Icon(
            icon,
            color: const Color(0xFF1877F2),
          ),
        ),
        title: Text(text),
        subtitle: const Text('কিছুক্ষণ আগে'),
      ),
    );
  }

  Widget _profilePage() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 18),
          child: Column(
            children: [
              _profileAvatar(radius: 62),
              const SizedBox(height: 12),
              Text(
                profileName,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                profileBio.isEmpty
                    ? 'Jibon Sathi member'
                    : profileBio,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _profileStat('Friends', '128'),
                  _profileStat('Posts', '${posts.length}'),
                  _profileStat('Followers', '1.2K'),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _editProfile,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickProfileImage,
                      icon: const Icon(Icons.photo),
                      label: const Text('Photo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'Your Posts',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...posts
            .where((p) => p['name'] == profileName)
            .toList()
            .asMap()
            .entries
            .map(
              (entry) => _postCard(
                posts.indexOf(entry.value),
                entry.value,
              ),
            ),
      ],
    );
  }

  Widget _profileStat(String label, String value) {
    return SizedBox(
      width: 105,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        profileImagePath = result.files.single.path;
      });
    }
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      setState(() {
        posts.insert(0, {
          'name': profileName,
          'time': 'এখনই',
          'text': 'নতুন Photo পোস্ট 📸',
          'image': path,
          'likes': 0,
          'comments': 0,
          'liked': false,
        });
      });
      _showSnack('Photo পোস্ট হয়েছে');
    }
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      _showSnack('ভিডিও নির্বাচন হয়েছে');
    }
  }

  Future<void> _createTextPost() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Post'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'আপনার মনের কথা লিখুন...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  posts.insert(0, {
                    'name': profileName,
                    'time': 'এখনই',
                    'text': text,
                    'likes': 0,
                    'comments': 0,
                    'liked': false,
                  });
                });
                Navigator.pop(dialogContext);
                _showSnack('Post হয়েছে');
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  Future<void> _showComment(int index) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Comment'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'আপনার মন্তব্য লিখুন...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  comments.add(text);
                  posts[index]['comments'] += 1;
                });
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  Future<void> _sharePost(String text) async {
    await SharePlus.instance.share(
      ShareParams(
        text: '$text\n\nJibon Sathi',
      ),
    );
  }

  void _showCreateMenu() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            const ListTile(
              title: Text(
                'Create',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Color(0xFF1877F2),
              ),
              title: const Text('Post'),
              onTap: () {
                Navigator.pop(sheetContext);
                _createTextPost();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo,
                color: Colors.green,
              ),
              title: const Text('Photo'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickPhoto();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.auto_stories,
                color: Colors.deepPurple,
              ),
              title: const Text('Story'),
              onTap: () {
                Navigator.pop(sheetContext);
                _addStory();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addStory() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedStoryImage = result.files.single.path;
      });
      _showSnack('Story সফলভাবে যোগ হয়েছে');
    }
  }

  void _showStory(String name, String initial) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$name-এর Story'),
        content: SizedBox(
          height: 260,
          child: selectedStoryImage != null
              ? Image.file(
                  File(selectedStoryImage!),
                  fit: BoxFit.cover,
                )
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1877F2),
                        Color(0xFF5E60CE),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPostMenu(int index) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: const Text('Save post'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showSnack('Post saved');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove post'),
              onTap: () {
                Navigator.pop(sheetContext);
                setState(() {
                  posts.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    final nameController = TextEditingController(text: profileName);
    final bioController = TextEditingController(text: profileBio);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final bio = bioController.text.trim();

              setState(() {
                if (name.isNotEmpty) profileName = name;
                profileBio = bio;
              });

              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMessage() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Messenger'),
        content: const Text(
          'Chat feature-এর UI প্রস্তুত। পরের ধাপে Firebase দিয়ে real-time chat যুক্ত করা যাবে।',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class JibonSearchDelegate extends SearchDelegate<String> {
  final List<String> items;

  JibonSearchDelegate(this.items);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = items
        .where(
          (item) => item.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF1877F2),
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          title: Text(results[index]),
          onTap: () => close(context, results[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = items
        .where(
          (item) => item.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
