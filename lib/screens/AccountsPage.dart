import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  static String routeName = 'Accounts';
  static String routePath = '/accounts';

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F4F8),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF57636C), size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cuentas asociadas',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF1D2429),
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Titulares de cuenta',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF57636C),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            _buildAccountList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar cuenta...',
                labelStyle:
                    const TextStyle(color: Color(0xFF57636C), fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.search_rounded,
                color: Color(0xFF1D2429), size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAccountList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildAccountItem();
      },
    );
  }

  Widget _buildAccountItem() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Color.fromARGB(255, 238, 237, 237),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Image.network(
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=900&q=60',
            width: 36,
            height: 36,
            fit: BoxFit.cover,
          ),
        ),
        title: const Text(
          'Nombre del usuario',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF1D2429)),
        ),
        subtitle: const Text(
          'user@domainname.com',
          style: TextStyle(fontSize: 14, color: Color(0xFF57636C)),
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF126CD8),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Ver'),
        ),
      ),
    );
  }
}
